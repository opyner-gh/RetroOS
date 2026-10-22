class_name DesktopEnvironment
extends Control
## Main desktop environment controller (`DesktopEnvironment`).
## Configures the wallpaper, desktop icons, OS-specific panels (GNOME 2 Panels,
## HP-UX CDE Front Panel, Plan 9 `rio` right-click menu, Windows 98 Taskbar & Start Menu,
## or IBM OS/2 WarpCenter), and manages draggable/closable `RetroWindow` instances.

const OSProfile = preload("res://data/os_profile.gd")
const RetroWindow = preload("res://scenes/desktop/components/retro_window.gd")
const WINDOW_SCENE := preload("res://scenes/desktop/components/retro_window.tscn")

@onready var wallpaper_rect: ColorRect = $WallpaperRect
@onready var wallpaper_accent: ColorRect = $WallpaperAccent
@onready var desktop_hint_label: Label = $DesktopHintLabel
@onready var icon_container: VBoxContainer = $DesktopIconMargin/IconContainer
@onready var windows_layer: Control = $WindowsLayer

@onready var top_panel: PanelContainer = $TopPanel
@onready var top_left_box: HBoxContainer = $TopPanel/Margin/HBox/LeftBox
@onready var top_center_box: HBoxContainer = $TopPanel/Margin/HBox/CenterBox
@onready var top_right_box: HBoxContainer = $TopPanel/Margin/HBox/RightBox
@onready var top_clock_label: Label = $TopPanel/Margin/HBox/RightBox/TopClockLabel

@onready var bottom_panel: PanelContainer = $BottomPanel
@onready var bottom_left_box: HBoxContainer = $BottomPanel/Margin/HBox/LeftBox
@onready var taskbar_list_box: HBoxContainer = $BottomPanel/Margin/HBox/TaskbarListBox
@onready var bottom_right_box: HBoxContainer = $BottomPanel/Margin/HBox/RightBox
@onready var bottom_clock_label: Label = $BottomPanel/Margin/HBox/RightBox/BottomClockLabel

@onready var popup_menu: PopupPanel = $OSPopupMenu
@onready var popup_vbox: VBoxContainer = $OSPopupMenu/PopupMargin/PopupVBox

var _profile: OSProfile
var _windows_by_id: Dictionary = {}
var _window_specs_by_id: Dictionary = {}
var _clock_timer: Timer


func _ready() -> void:
	gui_input.connect(_on_desktop_background_gui_input)
	GameState.sr2_os_switched.connect(_on_sr2_os_switched)
	_clock_timer = Timer.new()
	_clock_timer.wait_time = 1.0
	_clock_timer.autostart = true
	_clock_timer.timeout.connect(_update_clocks)
	add_child(_clock_timer)

	if GameState.current_profile:
		load_os_environment(GameState.current_profile)


func _on_sr2_os_switched(_new_sub_os: String) -> void:
	if _profile and _profile.id == "evga_sr2":
		load_os_environment(_profile)


func load_os_environment(profile: OSProfile) -> void:
	_profile = profile
	if _profile and _profile.id == "evga_sr2":
		var OSRegistry = preload("res://data/os_registry.gd")
		OSRegistry.apply_sr2_sub_profile(_profile, GameState.sr2_active_os)

	if not is_node_ready():
		await ready

	# Play unique OS login/startup sound and adjust fan acoustics
	AudioManager.start_fan_hum(profile.fan_base_freq, profile.fan_noise_level)
	AudioManager.play_os_startup_sound(profile.id)

	# Configure wallpaper
	wallpaper_rect.color = profile.desktop_bg_color
	wallpaper_accent.color = profile.desktop_secondary_color
	wallpaper_accent.visible = (profile.chrome_style != "plan9_rio" and profile.chrome_style != "win98_classic")

	# Clear previous windows & icons
	_clear_children(icon_container)
	_clear_children(windows_layer)
	_windows_by_id.clear()
	_window_specs_by_id.clear()

	# Build desktop icons
	_build_desktop_icons(profile)

	# Build initial mock windows
	for spec in profile.default_windows:
		var win_id := str(spec.get("id", ""))
		_window_specs_by_id[win_id] = spec
		_spawn_or_focus_window(spec)

	# Configure OS-specific shell panels (GNOME, CDE, rio, Win98, OS/2 WarpCenter)
	_configure_shell_panels(profile)
	_rebuild_taskbar_buttons()
	_update_clocks()


func _clear_children(container: Node) -> void:
	for child in container.get_children():
		child.queue_free()


# ==============================================================================
# DESKTOP ICONS & WINDOW LIFECYCLE
# ==============================================================================

func _build_desktop_icons(profile: OSProfile) -> void:
	for icon_spec in profile.desktop_icons:
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(86, 66)
		btn.focus_mode = Control.FOCUS_NONE
		var glyph := str(icon_spec.get("glyph", "[APP]"))
		var lbl := str(icon_spec.get("label", "App"))
		btn.text = glyph + "\n" + lbl
		btn.add_theme_font_size_override("font_size", 11)

		var icon_style := StyleBoxFlat.new()
		icon_style.bg_color = Color(0, 0, 0, 0.22)
		icon_style.border_color = Color(1, 1, 1, 0.25)
		icon_style.set_border_width_all(1)
		icon_style.set_corner_radius_all(3)
		btn.add_theme_stylebox_override("normal", icon_style)

		var target_id := str(icon_spec.get("target_window_id", "terminal"))
		btn.pressed.connect(func():
			AudioManager.play_hdd_click()
			open_or_restore_window_by_id(target_id)
		)
		icon_container.add_child(btn)

	# Add a period-appropriate removable drive icon on the desktop
	var floppy_btn := Button.new()
	floppy_btn.custom_minimum_size = Vector2(86, 62)
	floppy_btn.focus_mode = Control.FOCUS_NONE
	if profile.id == "apple_iie":
		floppy_btn.text = "[5.25\" D1]\nSlot 6"
	else:
		floppy_btn.text = "[3.5\" FD]\nDrive A:"
	floppy_btn.add_theme_font_size_override("font_size", 11)
	var f_style := StyleBoxFlat.new()
	f_style.bg_color = Color(0, 0, 0, 0.22)
	f_style.border_color = Color(1, 1, 1, 0.25)
	f_style.set_border_width_all(1)
	f_style.set_corner_radius_all(3)
	floppy_btn.add_theme_stylebox_override("normal", f_style)
	floppy_btn.pressed.connect(func():
		if profile.id == "apple_iie":
			AudioManager.play_disk2_bang()
		else:
			AudioManager.play_floppy_seek()
	)
	icon_container.add_child(floppy_btn)


func open_or_restore_window_by_id(win_id: String) -> void:
	if _windows_by_id.has(win_id) and is_instance_valid(_windows_by_id[win_id]):
		var existing: RetroWindow = _windows_by_id[win_id]
		existing.restore_window()
		_on_window_focused(existing)
		_rebuild_taskbar_buttons()
		return

	if _window_specs_by_id.has(win_id):
		_spawn_or_focus_window(_window_specs_by_id[win_id])
		_rebuild_taskbar_buttons()


func _spawn_or_focus_window(spec: Dictionary) -> RetroWindow:
	var win: RetroWindow = WINDOW_SCENE.instantiate()
	windows_layer.add_child(win)
	win.configure_window(spec, _profile)
	win.window_focused.connect(_on_window_focused)
	win.window_minimized.connect(func(_w): _rebuild_taskbar_buttons())
	win.window_closed.connect(func(closed_win: RetroWindow):
		var target_id := closed_win.window_id
		if _windows_by_id.has(target_id):
			_windows_by_id.erase(target_id)
		closed_win.queue_free()
		_rebuild_taskbar_buttons()
	)

	var win_id := str(spec.get("id", "win_" + str(win.get_instance_id())))
	_windows_by_id[win_id] = win
	_on_window_focused(win)
	return win


func _on_window_focused(focused_win: RetroWindow) -> void:
	for win_id in _windows_by_id.keys():
		var w: RetroWindow = _windows_by_id[win_id]
		if is_instance_valid(w):
			w.set_window_active(w == focused_win)
	_rebuild_taskbar_buttons()


# ==============================================================================
# OS-SPECIFIC SHELL LAYOUTS (GNOME 2, CDE, PLAN 9 RIO, WIN98, OS/2 WARPCENTER)
# ==============================================================================

func _configure_shell_panels(profile: OSProfile) -> void:
	_clear_children(top_left_box)
	_clear_children(top_center_box)
	_clear_children(bottom_left_box)

	var p_style := StyleBoxFlat.new()
	p_style.bg_color = profile.panel_bg_color
	p_style.border_color = profile.window_border_color
	p_style.set_border_width_all(1)
	p_style.set_content_margin_all(3)
	top_panel.add_theme_stylebox_override("panel", p_style)
	bottom_panel.add_theme_stylebox_override("panel", p_style)

	top_clock_label.add_theme_color_override("font_color", profile.panel_text_color)
	bottom_clock_label.add_theme_color_override("font_color", profile.panel_text_color)

	desktop_hint_label.visible = false

	match profile.chrome_style:
		"gnome_human":
			# Ubuntu 7.04: Top GNOME Menu Bar + Bottom Window List & Workspace Switcher
			top_panel.visible = true
			bottom_panel.visible = true
			top_clock_label.visible = true
			bottom_clock_label.visible = false

			_add_panel_button(top_left_box, "🟠 Applications", func(): _show_os_menu(Vector2(8, 30)))
			_add_panel_button(top_left_box, "Places", func(): open_or_restore_window_by_id("about"))
			_add_panel_button(top_left_box, "System", func(): open_or_restore_window_by_id("sysmon"))
			_add_panel_button(top_center_box, "Terminal", func(): open_or_restore_window_by_id("terminal"))
			_add_panel_button(bottom_left_box, "[ Show Desktop ]", _minimize_all_windows)

		"motif_cde":
			# HP-UX CDE: Bottom Centered Motif Front Panel
			top_panel.visible = false
			bottom_panel.visible = true
			bottom_clock_label.visible = true

			_add_panel_button(bottom_left_box, "[ dtterm ]", func(): open_or_restore_window_by_id("terminal"))
			_add_panel_button(bottom_left_box, "[ SAM Admin ]", func(): open_or_restore_window_by_id("sam"))
			_add_panel_button(bottom_left_box, "[ dtpad ]", func(): open_or_restore_window_by_id("dtpad"))
			_add_panel_button(bottom_left_box, "[ One | Two | Three | Four ]", func(): AudioManager.play_hdd_click())
			_add_panel_button(bottom_left_box, "[ Exit CDE ]", func(): GameState.reboot_to_menu())

		"plan9_rio":
			# Plan 9 rio: No desktop panels; pure grey workspace with right-click context menu
			top_panel.visible = false
			bottom_panel.visible = false
			desktop_hint_label.visible = true
			desktop_hint_label.text = "Plan 9 'rio' — Right-click anywhere on the grey desktop for menu [New / Unhide / Reboot]"

		"os2_pmshell":
			# IBM OS/2 Warp 4: Top-docked WarpCenter Bar
			top_panel.visible = true
			bottom_panel.visible = true
			top_clock_label.visible = true
			bottom_clock_label.visible = false

			_add_panel_button(top_left_box, "💠 OS/2 Warp", func(): _show_os_menu(Vector2(8, 30)))
			_add_panel_button(top_left_box, "Window List", func(): _restore_all_windows())
			_add_panel_button(top_center_box, "Drive C: 1,842 MB Free (HPFS)", func(): AudioManager.play_hdd_burst())
			_add_panel_button(top_center_box, "OS/2 Window", func(): open_or_restore_window_by_id("terminal"))
			_add_panel_button(bottom_left_box, "[ WPS Objects ]", func(): open_or_restore_window_by_id("wps_sys"))

		"win7_aero":
			# Windows 7 Superbar: Bottom dark glass taskbar with Start Orb
			top_panel.visible = false
			bottom_panel.visible = true
			bottom_clock_label.visible = true

			var win7_start := _add_panel_button(
				bottom_left_box,
				" 🪟 Start ",
				func(): _show_os_menu(Vector2(6, size.y - 270))
			)
			win7_start.custom_minimum_size = Vector2(80, 26)
			var start_style := StyleBoxFlat.new()
			start_style.bg_color = Color("1e40af")
			start_style.border_color = Color("60a5fa")
			start_style.set_border_width_all(1)
			start_style.set_corner_radius_all(4)
			win7_start.add_theme_stylebox_override("normal", start_style)

			_add_panel_button(bottom_left_box, "[cmd.exe]", func(): open_or_restore_window_by_id("terminal"))
			_add_panel_button(bottom_left_box, "[FirePro S400 24-Wall]", func(): open_or_restore_window_by_id("eyefinity"))
			_add_panel_button(bottom_left_box, "[Multi-Boot]", func(): open_or_restore_window_by_id("switcher"))

			_add_panel_button(bottom_right_box, "🔒 S400 Genlock: 24/24 Synced Displays @ 60Hz", func():
				AudioManager.play_hdd_click()
				open_or_restore_window_by_id("eyefinity")
			)

		"solaris_cde":
			# Oracle Solaris 11: Top Menu Bar + Bottom Window Switcher
			top_panel.visible = true
			bottom_panel.visible = true
			top_clock_label.visible = true
			bottom_clock_label.visible = false

			_add_panel_button(top_left_box, "☀️ Applications", func(): _show_os_menu(Vector2(8, 30)))
			_add_panel_button(top_left_box, "Places", func(): open_or_restore_window_by_id("zfs"))
			_add_panel_button(top_left_box, "System", func(): open_or_restore_window_by_id("dtrace"))
			_add_panel_button(top_center_box, "ksh93 Terminal", func(): open_or_restore_window_by_id("terminal"))
			_add_panel_button(bottom_left_box, "[ Multi-Boot Switcher ]", func(): open_or_restore_window_by_id("switcher"))
			_add_panel_button(bottom_right_box, "ZFS datapool: ONLINE (5.8TB RAIDZ2)", func(): open_or_restore_window_by_id("zfs"))

		"winxp_luna":
			# Windows XP Pro SP2 (Alienware Area-51 Predator): Luna Blue Taskbar + Green Start Button
			top_panel.visible = false
			bottom_panel.visible = true
			bottom_clock_label.visible = true

			var xp_start := _add_panel_button(
				bottom_left_box,
				"🟢 start",
				func(): _show_os_menu(Vector2(6, size.y - 240))
			)
			xp_start.custom_minimum_size = Vector2(82, 24)
			var start_style := StyleBoxFlat.new()
			start_style.bg_color = Color("3c9e38")
			start_style.border_color = Color("246b22")
			start_style.set_border_width_all(1)
			start_style.corner_radius_top_right = 8
			start_style.corner_radius_bottom_right = 8
			xp_start.add_theme_stylebox_override("normal", start_style)
			xp_start.add_theme_stylebox_override("hover", start_style)
			xp_start.add_theme_color_override("font_color", Color("ffffff"))

			_add_panel_button(bottom_left_box, "[👽 AlienAdrenaline]", func(): open_or_restore_window_by_id("alien_bench"))
			_add_panel_button(bottom_left_box, "[cmd.exe]", func(): open_or_restore_window_by_id("terminal"))

		"sgi_4dwm":
			# SGI IRIX 6.5 (Indigo Magic / 4Dwm): Top SGI Toolchest Bar + Bottom Desks Overview
			top_panel.visible = true
			bottom_panel.visible = true
			top_clock_label.visible = true
			bottom_clock_label.visible = false

			_add_panel_button(top_left_box, "◆ Toolchest: Desktop", func(): _show_os_menu(Vector2(8, 30)))
			_add_panel_button(top_left_box, "Selected", func(): open_or_restore_window_by_id("showcase"))
			_add_panel_button(top_left_box, "System", func(): open_or_restore_window_by_id("grosview"))
			_add_panel_button(top_center_box, "winterm", func(): open_or_restore_window_by_id("terminal"))
			_add_panel_button(bottom_left_box, "[ Desks: Desk 1 (VFX) | Desk 2 (Maya) ]", func(): AudioManager.play_hdd_click())

		"beos_yellowtab":
			# BeOS R5 Pro: Top Deskbar (Blue Feather Menu) + Bottom Team/Window Bar
			top_panel.visible = true
			bottom_panel.visible = true
			top_clock_label.visible = true
			bottom_clock_label.visible = false

			_add_panel_button(top_left_box, "🪶 BeOS Deskbar", func(): _show_os_menu(Vector2(8, 30)))
			_add_panel_button(top_left_box, "Tracker", func(): open_or_restore_window_by_id("tracker"))
			_add_panel_button(top_left_box, "Pulse SMP", func(): open_or_restore_window_by_id("pulse"))
			_add_panel_button(top_center_box, "Terminal", func(): open_or_restore_window_by_id("terminal"))
			_add_panel_button(bottom_left_box, "[ Teams ]", _restore_all_windows)

		"nextstep_black":
			# NeXTSTEP 3.3 / WindowMaker: Top Workspace Menu + Bottom Dock Strip
			top_panel.visible = true
			bottom_panel.visible = true
			top_clock_label.visible = true
			bottom_clock_label.visible = false

			_add_panel_button(top_left_box, "⬛ Workspace", func(): _show_os_menu(Vector2(8, 30)))
			_add_panel_button(top_left_box, "File", func(): _restore_all_windows())
			_add_panel_button(top_left_box, "Windows", func(): open_or_restore_window_by_id("terminal"))
			_add_panel_button(bottom_left_box, "[ NeXT Dock ]", _restore_all_windows)

		"mac_platinum":
			# Classic Macintosh System 7.5.3: Top Apple Menu Bar + Bottom Control Strip
			top_panel.visible = true
			bottom_panel.visible = true
			top_clock_label.visible = true
			bottom_clock_label.visible = false

			_add_panel_button(top_left_box, "", func(): _show_os_menu(Vector2(8, 30)))
			_add_panel_button(top_left_box, "File", func(): open_or_restore_window_by_id("quadra_hd"))
			_add_panel_button(top_left_box, "Edit", func(): AudioManager.play_hdd_click())
			_add_panel_button(top_left_box, "View", func(): _restore_all_windows())
			_add_panel_button(top_left_box, "Special", func(): open_or_restore_window_by_id("about_mac"))
			_add_panel_button(bottom_left_box, "[ Control Strip ]", func(): open_or_restore_window_by_id("terminal"))

		"aqua_pinstripe":
			# 1999 Power Mac G4 Mac OS X 10.2 Aqua: Top Menu Bar + Bottom Aqua Dock
			top_panel.visible = true
			bottom_panel.visible = true
			top_clock_label.visible = true
			bottom_clock_label.visible = false

			_add_panel_button(top_left_box, "", func(): _show_os_menu(Vector2(8, 30)))
			_add_panel_button(top_left_box, "Finder", func(): open_or_restore_window_by_id("sysprof"))
			_add_panel_button(top_left_box, "File", func(): _restore_all_windows())
			_add_panel_button(top_left_box, "Window", func(): open_or_restore_window_by_id("terminal"))
			_add_panel_button(bottom_left_box, "[ Aqua Dock: Finder | Terminal | iTunes ]", _restore_all_windows)

		"amiga_workbench":
			# Commodore AmigaOS 3.1: Top Workbench Screen Titlebar with Chip/Fast RAM counter
			top_panel.visible = true
			bottom_panel.visible = true
			top_clock_label.visible = true
			bottom_clock_label.visible = false

			_add_panel_button(top_left_box, "Amiga Workbench", func(): _show_os_menu(Vector2(8, 30)))
			_add_panel_button(top_center_box, "1,842,160 graphics mem   14,912,400 other mem", func(): open_or_restore_window_by_id("sysinfo_amiga"))
			_add_panel_button(bottom_left_box, "[ AmigaShell ]", func(): open_or_restore_window_by_id("terminal"))

		"apple2_green":
			# Apple //e Green Phosphor Bar
			top_panel.visible = true
			bottom_panel.visible = true
			top_clock_label.visible = true
			bottom_clock_label.visible = false

			_add_panel_button(top_left_box, "[ " + profile.short_name.to_upper() + " MENU ]", func(): _show_os_menu(Vector2(8, 30)))
			_add_panel_button(top_center_box, profile.architecture_summary, func(): open_or_restore_window_by_id("terminal"))
			_add_panel_button(bottom_left_box, "[ CLI / MONITOR ]", func(): open_or_restore_window_by_id("terminal"))

		_:
			# Windows 98 SE: Classic Bottom Taskbar with Start Button
			top_panel.visible = false
			bottom_panel.visible = true
			bottom_clock_label.visible = true

			var start_btn := _add_panel_button(
				bottom_left_box,
				"⊞ Start",
				func(): _show_os_menu(Vector2(6, size.y - 220))
			)
			start_btn.custom_minimum_size = Vector2(74, 24)
			_add_panel_button(bottom_left_box, "[C:\\]", func(): open_or_restore_window_by_id("terminal"))


func _add_panel_button(parent: Node, label_text: String, callback: Callable) -> Button:
	var btn := Button.new()
	btn.text = label_text
	btn.focus_mode = Control.FOCUS_NONE
	btn.add_theme_font_size_override("font_size", 12)
	btn.pressed.connect(func():
		AudioManager.play_hdd_click(0.04)
		callback.call()
	)
	parent.add_child(btn)
	return btn


func _rebuild_taskbar_buttons() -> void:
	if not is_node_ready():
		return
	_clear_children(taskbar_list_box)

	for win_id in _windows_by_id.keys():
		var win: RetroWindow = _windows_by_id[win_id]
		if not is_instance_valid(win):
			continue
		var btn := Button.new()
		btn.focus_mode = Control.FOCUS_NONE
		btn.add_theme_font_size_override("font_size", 12)
		var state_prefix := "▪ " if win.visible and win.is_active_window else ("_ " if not win.visible else "  ")
		btn.text = state_prefix + win.window_title
		btn.custom_minimum_size = Vector2(140, 22)
		btn.pressed.connect(func():
			AudioManager.play_hdd_click(0.04)
			if not win.visible:
				win.restore_window()
			elif win.is_active_window:
				win.visible = false
			else:
				win.restore_window()
			_rebuild_taskbar_buttons()
		)
		taskbar_list_box.add_child(btn)


func _minimize_all_windows() -> void:
	for win_id in _windows_by_id.keys():
		var w: RetroWindow = _windows_by_id[win_id]
		if is_instance_valid(w):
			w.visible = false
	_rebuild_taskbar_buttons()


func _restore_all_windows() -> void:
	for win_id in _windows_by_id.keys():
		var w: RetroWindow = _windows_by_id[win_id]
		if is_instance_valid(w):
			w.restore_window()
	_rebuild_taskbar_buttons()


# ==============================================================================
# POPUP START MENU / GNOME MENU / PLAN 9 RIO RIGHT-CLICK MENU
# ==============================================================================

func _on_desktop_background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		_show_os_menu(get_global_mouse_position(), true)


func _show_os_menu(target_pos: Vector2, is_global: bool = false) -> void:
	AudioManager.play_hdd_click(0.05)
	_clear_children(popup_vbox)

	var header := Label.new()
	header.text = " " + (_profile.short_name if _profile else "System Menu")
	header.add_theme_font_size_override("font_size", 13)
	header.add_theme_color_override("font_color", Color("ffd080"))
	popup_vbox.add_child(header)

	var sep1 := HSeparator.new()
	popup_vbox.add_child(sep1)

	for win_id in _window_specs_by_id.keys():
		var spec: Dictionary = _window_specs_by_id[win_id]
		var item_btn := Button.new()
		item_btn.text = "Open: " + str(spec.get("title", win_id))
		item_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_btn.focus_mode = Control.FOCUS_NONE
		item_btn.pressed.connect(func():
			popup_menu.hide()
			open_or_restore_window_by_id(win_id)
		)
		popup_vbox.add_child(item_btn)

	var floppy_item := Button.new()
	floppy_item.text = "Seek Floppy Drive A: (/dev/fd0)"
	floppy_item.alignment = HORIZONTAL_ALIGNMENT_LEFT
	floppy_item.focus_mode = Control.FOCUS_NONE
	floppy_item.pressed.connect(func():
		popup_menu.hide()
		AudioManager.play_floppy_seek()
	)
	popup_vbox.add_child(floppy_item)

	var chime_item := Button.new()
	chime_item.text = "Replay OS Login Sound"
	chime_item.alignment = HORIZONTAL_ALIGNMENT_LEFT
	chime_item.focus_mode = Control.FOCUS_NONE
	chime_item.pressed.connect(func():
		popup_menu.hide()
		if _profile:
			AudioManager.play_os_startup_sound(_profile.id)
	)
	popup_vbox.add_child(chime_item)

	if _profile and _profile.id == "evga_sr2":
		var sep_sr2 := HSeparator.new()
		popup_vbox.add_child(sep_sr2)

		var b_w7 := Button.new()
		b_w7.text = "🪟 Boot Windows 7 Ultimate SP1"
		b_w7.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b_w7.focus_mode = Control.FOCUS_NONE
		b_w7.pressed.connect(func():
			popup_menu.hide()
			AudioManager.play_hdd_burst()
			GameState.set_sr2_active_os("win7")
		)
		popup_vbox.add_child(b_w7)

		var b_lion := Button.new()
		b_lion.text = "🍏 Boot Mac OS X 10.7 Lion"
		b_lion.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b_lion.focus_mode = Control.FOCUS_NONE
		b_lion.pressed.connect(func():
			popup_menu.hide()
			AudioManager.play_hdd_burst()
			GameState.set_sr2_active_os("lion")
		)
		popup_vbox.add_child(b_lion)

		var b_sol := Button.new()
		b_sol.text = "☀️ Boot Oracle Solaris 11"
		b_sol.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b_sol.focus_mode = Control.FOCUS_NONE
		b_sol.pressed.connect(func():
			popup_menu.hide()
			AudioManager.play_hdd_burst()
			GameState.set_sr2_active_os("solaris")
		)
		popup_vbox.add_child(b_sol)

		var b_bbs := Button.new()
		b_bbs.text = "📟 Reboot to BIOS BBS Selector"
		b_bbs.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b_bbs.focus_mode = Control.FOCUS_NONE
		b_bbs.pressed.connect(func():
			popup_menu.hide()
			AudioManager.play_hdd_click()
			GameState.select_and_boot_os("evga_sr2")
		)
		popup_vbox.add_child(b_bbs)

	var sep2 := HSeparator.new()
	popup_vbox.add_child(sep2)

	var reboot_item := Button.new()
	reboot_item.text = "Shut Down / Reboot to OS Selector..."
	reboot_item.alignment = HORIZONTAL_ALIGNMENT_LEFT
	reboot_item.focus_mode = Control.FOCUS_NONE
	reboot_item.pressed.connect(func():
		popup_menu.hide()
		AudioManager.play_hdd_burst()
		GameState.reboot_to_menu()
	)
	popup_vbox.add_child(reboot_item)

	var screen_pos := target_pos if is_global else (get_global_transform() * target_pos)
	popup_menu.position = Vector2i(int(screen_pos.x), int(screen_pos.y))
	popup_menu.popup()


func _update_clocks() -> void:
	var dt := Time.get_datetime_dict_from_system()
	var time_str := "%02d:%02d:%02d" % [dt.get("hour", 0), dt.get("minute", 0), dt.get("second", 0)]
	top_clock_label.text = time_str
	bottom_clock_label.text = time_str

