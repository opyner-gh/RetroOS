class_name BootSequence
extends Control
## BIOS POST and Operating System boot text crawl sequence (`BootSequence`).
## Renders period-correct firmware headers, hardware initialization logs, and triggers
## synchronized acoustic effects (fan spin-up, POST beep, floppy seek, HDD chatter)
## via `AudioManager` at an authentic, unhurried 1990s/2000s boot pace.

const OSProfile = preload("res://data/os_profile.gd")
## Global multiplier applied to boot log delays so BIOS POST, SCSI/IDE probing,
## floppy calibration, and kernel initialization unfold at a realistic hardware pace.
const BOOT_PACE_SCALE := 1.35

@onready var bg_rect: ColorRect = $BackgroundRect
@onready var bios_header_label: Label = $MarginContainer/VBoxContainer/TopBar/BiosHeaderLabel
@onready var badge_label: Label = $MarginContainer/VBoxContainer/TopBar/EnergyBadgeLabel
@onready var boot_log_rtl: RichTextLabel = $MarginContainer/VBoxContainer/BootLogLabel
@onready var progress_bar: ProgressBar = $MarginContainer/VBoxContainer/BottomRow/BootProgressBar
@onready var skip_btn: Button = $MarginContainer/VBoxContainer/BottomRow/SkipButton
@onready var abort_btn: Button = $MarginContainer/VBoxContainer/BottomRow/AbortButton

var _profile: OSProfile
var _step_index: int = 0
var _speed_multiplier: float = 1.0
var _step_timer: Timer
var _sub_hdd_timer: Timer
var _boot_finished: bool = false
var _bbs_panel: PanelContainer
var _bbs_hint_label: Label
var _is_awaiting_bbs: bool = false


func _ready() -> void:
	_setup_bbs_panel()

	_step_timer = Timer.new()
	_step_timer.one_shot = true
	_step_timer.timeout.connect(_process_next_boot_line)
	add_child(_step_timer)

	_sub_hdd_timer = Timer.new()
	_sub_hdd_timer.one_shot = true
	_sub_hdd_timer.timeout.connect(_on_sub_hdd_tick)
	add_child(_sub_hdd_timer)

	skip_btn.pressed.connect(_on_fast_forward_pressed)
	abort_btn.pressed.connect(_on_abort_pressed)

	if GameState.current_profile:
		start_boot_for_os(GameState.current_profile)


func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event is InputEventKey and event.pressed:
		if _is_awaiting_bbs:
			if event.keycode == KEY_1:
				_on_sr2_os_picked("win7")
				return
			elif event.keycode == KEY_2:
				_on_sr2_os_picked("lion")
				return
			elif event.keycode == KEY_3:
				_on_sr2_os_picked("solaris")
				return
			elif event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
				_on_sr2_os_picked(GameState.sr2_active_os)
				return
			elif event.keycode == KEY_ESCAPE:
				_on_abort_pressed()
				return
		else:
			if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
				_on_fast_forward_pressed()
			elif event.keycode == KEY_ESCAPE:
				_on_abort_pressed()


func start_boot_for_os(profile: OSProfile) -> void:
	_profile = profile
	_step_index = 0
	_speed_multiplier = 1.0
	_boot_finished = false
	_is_awaiting_bbs = false
	if _bbs_panel:
		_bbs_panel.visible = false

	if not is_node_ready():
		await ready

	bg_rect.color = profile.boot_bg_color
	bios_header_label.text = profile.bios_header
	bios_header_label.add_theme_color_override("font_color", profile.boot_text_color)
	if not profile.has_energy_star_badge:
		badge_label.text = ""
		badge_label.visible = false
	else:
		badge_label.visible = true
		badge_label.text = (
			"  /\\  EPA POLLUTION PREVENTER\n"
			+ " /  \\   [" + profile.release_year + " ROM BIOS]\n"
			+ "/____\\  " + profile.short_name.to_upper()
		)
	skip_btn.text = "[SPACE] 5x Fast-Forward Boot"

	boot_log_rtl.clear()
	boot_log_rtl.add_theme_color_override("default_color", profile.boot_text_color)
	progress_bar.max_value = max(1, profile.boot_logs.size())
	progress_bar.value = 0

	# Initial CRT relay & cooling fan spin-up pause before first POST line
	AudioManager.trigger_fan_spinup(profile)
	_step_timer.start(1.10)


func _process_next_boot_line() -> void:
	if _boot_finished or not _profile:
		return

	if _step_index >= _profile.boot_logs.size():
		_boot_finished = true
		AudioManager.play_hdd_burst()
		await get_tree().create_timer(1.40 / _speed_multiplier).timeout
		if is_inside_tree() and _boot_finished:
			GameState.finish_boot_to_desktop()
		return

	var entry: Dictionary = _profile.boot_logs[_step_index]
	var line_text := str(entry.get("text", ""))
	var line_color := str(entry.get("color", ""))
	var sfx_key := str(entry.get("sfx", ""))
	var raw_delay := float(entry.get("delay", 0.85))

	if not sfx_key.is_empty():
		AudioManager.trigger_boot_sfx(sfx_key, _profile)

	if line_color.is_empty():
		boot_log_rtl.append_text(line_text + "\n")
	else:
		boot_log_rtl.append_text("[color=%s]%s[/color]\n" % [line_color, line_text])

	_step_index += 1
	progress_bar.value = _step_index

	# Interactive BIOS BBS boot device selector for the EVGA SR-2 Triple-Boot Workstation
	if _profile.id == "evga_sr2" and line_text.contains("Press [F12] or [BBS POPUP]"):
		_show_sr2_bbs_menu()
		return

	var wait_time := maxf(0.03, (raw_delay * BOOT_PACE_SCALE) / _speed_multiplier)

	# If waiting on a longer disk-intensive step, trigger secondary HDD head movement midway
	if wait_time >= 0.85 and (sfx_key == "hdd_burst" or sfx_key == "hdd_click"):
		_sub_hdd_timer.start(wait_time * 0.52)

	_step_timer.start(wait_time)


func _setup_bbs_panel() -> void:
	_bbs_panel = PanelContainer.new()
	_bbs_panel.visible = false
	_bbs_panel.custom_minimum_size = Vector2(760, 240)

	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("0a1220ee")
	sb.border_color = Color("eab308")
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(6)
	sb.set_content_margin_all(14)
	_bbs_panel.add_theme_stylebox_override("panel", sb)

	var margin := MarginContainer.new()
	_bbs_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "╔═════════════ EVGA CLASSIFIED SR-2 BIOS BOOT DEVICE SELECTION (BBS POPUP) ═════════════╗"
	title.add_theme_color_override("font_color", Color("facc15"))
	title.add_theme_font_size_override("font_size", 13)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Select dedicated physical SSD drive / target operating system to initialize and boot:"
	subtitle.add_theme_color_override("font_color", Color("94a3b8"))
	subtitle.add_theme_font_size_override("font_size", 11)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(subtitle)

	var btn_vbox := VBoxContainer.new()
	btn_vbox.add_theme_constant_override("separation", 6)
	vbox.add_child(btn_vbox)

	var targets := [
		{
			"key": "win7",
			"label": "[ 🪟 1. Drive 0: Windows 7 Ultimate SP1 (x64) • SATA Port 0: OCZ Vertex 3 (240GB) ]\n     Bootloader: Windows Boot Manager • 24-Screen FirePro Eyefinity Wall & DirectX 11 / 3ds Max",
			"color": Color("60a5fa")
		},
		{
			"key": "lion",
			"label": "[ 🍏 2. Drive 1: Mac OS X 10.7 Lion (x86_64) • SATA Port 1: OCZ Vertex 3 (240GB) ]\n     Bootloader: Chameleon v2.1 r1684 • Final Cut Studio Pro 7 & OpenCL Quad-V9800 Engine",
			"color": Color("a78bfa")
		},
		{
			"key": "solaris",
			"label": "[ ☀️ 3. Drive 2: Oracle Solaris 11 11/11 (x86) • SATA Port 2: OCZ Vertex 3 (240GB) ]\n     Bootloader: GRUB2 ZFS Root Pool • Enterprise RAIDZ2 Multi-TB Vault & DTrace Kernel Monitor",
			"color": Color("38bdf8")
		}
	]

	for t in targets:
		var btn := Button.new()
		btn.text = str(t["label"])
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.focus_mode = Control.FOCUS_NONE
		btn.add_theme_font_size_override("font_size", 11)
		var k := str(t["key"])
		btn.pressed.connect(func(): _on_sr2_os_picked(k))
		btn_vbox.add_child(btn)

	_bbs_hint_label = Label.new()
	_bbs_hint_label.text = "Press [1], [2], or [3] on keyboard or click an option above • Press [SPACE] to boot active OS"
	_bbs_hint_label.add_theme_color_override("font_color", Color("e2e8f0"))
	_bbs_hint_label.add_theme_font_size_override("font_size", 11)
	_bbs_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(_bbs_hint_label)

	# Add inside MarginContainer / VBoxContainer right above BottomRow
	var main_vbox: VBoxContainer = $MarginContainer/VBoxContainer
	main_vbox.add_child(_bbs_panel)
	main_vbox.move_child(_bbs_panel, main_vbox.get_child_count() - 2)


func _show_sr2_bbs_menu() -> void:
	_is_awaiting_bbs = true
	_step_timer.stop()
	_sub_hdd_timer.stop()
	if _bbs_hint_label:
		_bbs_hint_label.text = "Press [1], [2], or [3] on keyboard or click an option above • Press [SPACE] to boot active OS (" + GameState.get_sr2_os_title() + ")"
	_bbs_panel.visible = true
	AudioManager.play_hdd_click(0.08)


func _on_sr2_os_picked(os_sub_id: String) -> void:
	if not _is_awaiting_bbs:
		return
	_is_awaiting_bbs = false
	if _bbs_panel:
		_bbs_panel.visible = false

	GameState.set_sr2_active_os(os_sub_id)
	AudioManager.play_hdd_burst()

	match os_sub_id:
		"lion":
			boot_log_rtl.append_text("[color=#a78bfa]BIOS BBS: Booting SATA Port 1 -> OCZ-VERTEX3 240GB SSD (Chameleon v2.1-r1684)...[/color]\n")
			boot_log_rtl.append_text("Darwin/x86 boot v5.0.132 - Chameleon v2.1-r1684\n")
			boot_log_rtl.append_text("Loading /System/Library/Kernels/mach_kernel...\n")
			boot_log_rtl.append_text("[color=#4ade80]FakeSMC v4.2.0: Hardware SMC emulation active on Dual Xeon X5690[/color]\n")
			boot_log_rtl.append_text("[color=#4ade80]ATY_Init: 4x ATI FirePro V9800 Cypress XT Framebuffers configured[/color]\n")
			boot_log_rtl.append_text("[color=#a78bfa]Mac OS X 10.7 Lion (Build 11A511) Aqua WindowServer ready.[/color]\n")
		"solaris":
			boot_log_rtl.append_text("[color=#38bdf8]BIOS BBS: Booting SATA Port 2 -> OCZ-VERTEX3 240GB SSD (GRUB2 ZFS Root Pool)...[/color]\n")
			boot_log_rtl.append_text("SunOS Release 5.11 Version 11/11 64-bit\n")
			boot_log_rtl.append_text("Copyright (c) 1983, 2011, Oracle and/or its affiliates. All rights reserved.\n")
			boot_log_rtl.append_text("[color=#4ade80]Importing ZFS root pool 'rpool' on OCZ-VERTEX3 SSD 2...[/color]\n")
			boot_log_rtl.append_text("[color=#4ade80]ATI FirePro S400 Genlock: 24/24 Synced Displays locked @ 59.94 Hz[/color]\n")
			boot_log_rtl.append_text("[color=#38bdf8]Starting Sun Java Desktop System / GNOME 2...[/color]\n")
		_: # "win7"
			boot_log_rtl.append_text("[color=#60a5fa]BIOS BBS: Booting SATA Port 0 -> OCZ-VERTEX3 240GB SSD (Windows Boot Manager)...[/color]\n")
			boot_log_rtl.append_text("Starting Windows...\n")
			boot_log_rtl.append_text("[color=#4ade80][OK] Windows 7 Ultimate SP1 (Build 7601) x64 Kernel loaded[/color]\n")
			boot_log_rtl.append_text("[color=#4ade80][OK] ATI FirePro Catalyst 8.911 Workstation Driver initialized[/color]\n")
			boot_log_rtl.append_text("[color=#4ade80][OK] S400 Hardware Genlock: 24 Displays locked in frame sync @ 59.94 Hz[/color]\n")
			boot_log_rtl.append_text("[color=#60a5fa][OK] Desktop Window Manager (Aero DWM Compositor) ready.[/color]\n")

	progress_bar.value = progress_bar.max_value
	_step_index = _profile.boot_logs.size()

	# Pause briefly before transitioning into the loaded desktop
	await get_tree().create_timer(1.2 / _speed_multiplier).timeout
	if is_inside_tree() and not _boot_finished:
		_boot_finished = true
		GameState.finish_boot_to_desktop()


func _on_sub_hdd_tick() -> void:
	if not _boot_finished and is_visible_in_tree():
		AudioManager.play_hdd_click(0.07)


func _on_fast_forward_pressed() -> void:
	if _is_awaiting_bbs:
		_on_sr2_os_picked(GameState.sr2_active_os)
		return

	if _speed_multiplier < 4.0:
		_speed_multiplier = 5.0
		skip_btn.text = ">> 5x Speed (Press SPACE for Instant Boot)"
		if not _step_timer.is_stopped():
			_step_timer.start(maxf(0.04, _step_timer.time_left / 5.0))
	else:
		_boot_finished = true
		_step_timer.stop()
		_sub_hdd_timer.stop()
		GameState.finish_boot_to_desktop()


func _on_abort_pressed() -> void:
	_boot_finished = true
	_step_timer.stop()
	_sub_hdd_timer.stop()
	AudioManager.play_hdd_click()
	GameState.reboot_to_menu()
