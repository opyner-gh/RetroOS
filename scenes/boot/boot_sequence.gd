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


func _ready() -> void:
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
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
			_on_fast_forward_pressed()
		elif event.keycode == KEY_ESCAPE:
			_on_abort_pressed()


func start_boot_for_os(profile: OSProfile) -> void:
	_profile = profile
	_step_index = 0
	_speed_multiplier = 1.0
	_boot_finished = false

	if not is_node_ready():
		await ready

	bg_rect.color = profile.boot_bg_color
	bios_header_label.text = profile.bios_header
	bios_header_label.add_theme_color_override("font_color", profile.boot_text_color)
	if profile.release_year.to_int() < 1992:
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

	var wait_time := maxf(0.03, (raw_delay * BOOT_PACE_SCALE) / _speed_multiplier)

	# If waiting on a longer disk-intensive step, trigger secondary HDD head movement midway
	if wait_time >= 0.85 and (sfx_key == "hdd_burst" or sfx_key == "hdd_click"):
		_sub_hdd_timer.start(wait_time * 0.52)

	_step_timer.start(wait_time)


func _on_sub_hdd_tick() -> void:
	if not _boot_finished and is_visible_in_tree():
		AudioManager.play_hdd_click(0.07)


func _on_fast_forward_pressed() -> void:
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
