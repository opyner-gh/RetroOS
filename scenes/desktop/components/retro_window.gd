class_name RetroOSWindow
extends PanelContainer
## Reusable draggable, focusable, minimizable, and closable retro OS window (`RetroWindow`).
## Dynamically styles its frame, titlebar, and caption buttons to match the active `OSProfile`:
## - GNOME 2.18 "Human" (Ubuntu 7.04)
## - Motif / CDE 2.1 (HP-UX 11i)
## - Rob Pike's `rio` (Plan 9 from Bell Labs)
## - Win32 Explorer Classic (Windows 98 SE)
## - Presentation Manager / Workplace Shell (IBM OS/2 Warp 4)

signal window_focused(window: PanelContainer)
signal window_closed(window: PanelContainer)
signal window_minimized(window: PanelContainer)

const OSProfile = preload("res://data/os_profile.gd")
const TERMINAL_SCENE := preload("res://scenes/desktop/components/retro_terminal.tscn")

@onready var title_bar: PanelContainer = $OuterVBox/TitleBar
@onready var left_menu_btn: Button = $OuterVBox/TitleBar/TitleHBox/LeftMenuButton
@onready var title_label: Label = $OuterVBox/TitleBar/TitleHBox/TitleLabel
@onready var minimize_btn: Button = $OuterVBox/TitleBar/TitleHBox/MinimizeButton
@onready var maximize_btn: Button = $OuterVBox/TitleBar/TitleHBox/MaximizeButton
@onready var close_btn: Button = $OuterVBox/TitleBar/TitleHBox/CloseButton
@onready var body_panel: PanelContainer = $OuterVBox/BodyPanel
@onready var content_holder: Control = $OuterVBox/BodyPanel/ContentMargin/ContentHolder

var window_id: String = ""
var window_title: String = "Window"
var window_type: String = "text"
var is_active_window: bool = true
var is_maximized: bool = false
var is_shaded: bool = false

var _profile: OSProfile
var _dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO
var _saved_rect: Rect2 = Rect2(100, 100, 460, 300)
var _content_label: RichTextLabel = null
var _base_content_text: String = ""
var _monitor_timer: Timer = null
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()
	title_bar.gui_input.connect(_on_title_bar_gui_input)
	gui_input.connect(_on_window_gui_input)
	minimize_btn.pressed.connect(_on_minimize_pressed)
	maximize_btn.pressed.connect(_on_maximize_pressed)
	close_btn.pressed.connect(_on_close_pressed)
	left_menu_btn.pressed.connect(_on_left_menu_pressed)


func configure_window(spec: Dictionary, profile: OSProfile) -> void:
	_profile = profile
	window_id = str(spec.get("id", "win_" + str(get_instance_id())))
	window_title = str(spec.get("title", "Window"))
	window_type = str(spec.get("type", "text"))
	_base_content_text = str(spec.get("content", ""))

	if not is_node_ready():
		await ready

	position = spec.get("pos", Vector2(120, 90))
	size = spec.get("size", Vector2(460, 300))
	if profile and profile.aspect_ratio == "4:3":
		var max_right := 952.0
		var parent_ctrl := get_parent_control()
		if parent_ctrl and parent_ctrl.size.x > 0:
			max_right = maxf(240.0, parent_ctrl.size.x - 8.0)
		if position.x + size.x > max_right:
			position.x = maxf(10.0, max_right - size.x)
	custom_minimum_size = Vector2(240, 140)
	_saved_rect = Rect2(position, size)

	title_label.text = window_title
	_apply_chrome_style(profile, true)
	_populate_body_content(window_type, _base_content_text, profile)


func set_window_active(active: bool) -> void:
	is_active_window = active
	if _profile and is_node_ready():
		_apply_chrome_style(_profile, active)


func restore_window() -> void:
	visible = true
	move_to_front()
	window_focused.emit(self)


func _populate_body_content(wtype: String, text_content: String, profile: OSProfile) -> void:
	for child in content_holder.get_children():
		child.queue_free()

	if wtype == "terminal":
		var term := TERMINAL_SCENE.instantiate()
		content_holder.add_child(term)
		term.setup_for_os(profile)
		term.terminal_exit_requested.connect(_on_close_pressed)
		term.system_reboot_requested.connect(func(): GameState.reboot_to_menu())
		return

	# Non-terminal mock window (System Monitor, File Browser, Notepad/Editor, About)
	var inner_panel := PanelContainer.new()
	inner_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	var inner_box := StyleBoxFlat.new()
	if wtype == "text" or wtype == "files":
		if profile.chrome_style == "plan9_rio":
			inner_box.bg_color = Color("ffffea")
		elif profile.window_bg_color.get_luminance() < 0.35 or profile.chrome_style == "amiga_workbench":
			inner_box.bg_color = profile.window_bg_color.lightened(0.04)
		else:
			inner_box.bg_color = Color("ffffff")
		inner_box.border_color = profile.window_border_color.darkened(0.25)
	else:
		inner_box.bg_color = profile.window_bg_color.lightened(0.06)
		inner_box.border_color = profile.window_border_color
	inner_box.set_border_width_all(1)
	inner_box.set_content_margin_all(10)
	inner_panel.add_theme_stylebox_override("panel", inner_box)
	content_holder.add_child(inner_panel)

	if text_content.contains("EVGA CLASSIFIED SR-2 MULTI-OS BOOT MANAGER"):
		var main_vb := VBoxContainer.new()
		main_vb.set_anchors_preset(Control.PRESET_FULL_RECT)
		main_vb.add_theme_constant_override("separation", 6)
		inner_panel.add_child(main_vb)

		var rtl := RichTextLabel.new()
		rtl.size_flags_vertical = Control.SIZE_EXPAND_FILL
		rtl.selection_enabled = true
		rtl.add_theme_font_size_override("normal_font_size", 12)
		rtl.add_theme_color_override("default_color", profile.window_text_color)
		rtl.text = text_content
		main_vb.add_child(rtl)
		_content_label = rtl

		var btn_grid := GridContainer.new()
		btn_grid.columns = 2
		btn_grid.add_theme_constant_override("h_separation", 6)
		btn_grid.add_theme_constant_override("v_separation", 6)
		main_vb.add_child(btn_grid)

		var b_w7 := Button.new()
		b_w7.text = "🪟 Boot Windows 7"
		b_w7.focus_mode = Control.FOCUS_NONE
		b_w7.pressed.connect(func():
			AudioManager.play_hdd_burst()
			GameState.set_sr2_active_os("win7")
		)
		btn_grid.add_child(b_w7)

		var b_lion := Button.new()
		b_lion.text = "🍏 Boot OS X Lion"
		b_lion.focus_mode = Control.FOCUS_NONE
		b_lion.pressed.connect(func():
			AudioManager.play_hdd_burst()
			GameState.set_sr2_active_os("lion")
		)
		btn_grid.add_child(b_lion)

		var b_sol := Button.new()
		b_sol.text = "☀️ Boot Solaris 11"
		b_sol.focus_mode = Control.FOCUS_NONE
		b_sol.pressed.connect(func():
			AudioManager.play_hdd_burst()
			GameState.set_sr2_active_os("solaris")
		)
		btn_grid.add_child(b_sol)

		var b_bbs := Button.new()
		b_bbs.text = "📟 Reboot to BIOS BBS"
		b_bbs.focus_mode = Control.FOCUS_NONE
		b_bbs.pressed.connect(func():
			AudioManager.play_hdd_click()
			GameState.select_and_boot_os("evga_sr2")
		)
		btn_grid.add_child(b_bbs)
		return

	var rtl := RichTextLabel.new()
	rtl.set_anchors_preset(Control.PRESET_FULL_RECT)
	rtl.selection_enabled = true
	rtl.add_theme_font_size_override("normal_font_size", 13)
	rtl.add_theme_color_override("default_color", profile.window_text_color)
	rtl.text = text_content
	inner_panel.add_child(rtl)
	_content_label = rtl

	if wtype == "monitor":
		_monitor_timer = Timer.new()
		_monitor_timer.wait_time = 1.6
		_monitor_timer.autostart = true
		_monitor_timer.timeout.connect(_update_live_monitor_metrics)
		add_child(_monitor_timer)


func _update_live_monitor_metrics() -> void:
	if not is_visible_in_tree() or not _content_label or not _profile:
		return
	var cpu_pct := _rng.randi_range(4, 29)
	var bars := int(round(float(cpu_pct) / 5.0))
	var meter := "[" + "|".repeat(bars) + ".".repeat(20 - bars) + "] " + ("%2d%%" % cpu_pct)
	_content_label.text = _base_content_text + "\n\nLive Telemetry : " + meter


func _apply_chrome_style(profile: OSProfile, active: bool) -> void:
	var outer_style := StyleBoxFlat.new()
	outer_style.bg_color = profile.window_bg_color
	var tb_style := StyleBoxFlat.new()
	tb_style.bg_color = profile.titlebar_active_color if active else profile.titlebar_inactive_color
	tb_style.set_content_margin_all(4)
	tb_style.content_margin_left = 8
	tb_style.content_margin_right = 6

	var body_style := StyleBoxFlat.new()
	body_style.bg_color = profile.window_bg_color
	body_style.set_content_margin_all(4)

	match profile.chrome_style:
		"gnome_human":
			outer_style.border_color = Color("4a2e1b") if active else Color("7a726a")
			outer_style.set_border_width_all(2)
			outer_style.corner_radius_top_left = 6
			outer_style.corner_radius_top_right = 6
			tb_style.corner_radius_top_left = 5
			tb_style.corner_radius_top_right = 5
			left_menu_btn.visible = false
			minimize_btn.text = "_"
			maximize_btn.text = "□"
			close_btn.text = "✕"

		"ubuntu_ambiance":
			outer_style.border_color = Color("3c3b37") if active else Color("4d4b47")
			outer_style.set_border_width_all(2)
			outer_style.corner_radius_top_left = 6
			outer_style.corner_radius_top_right = 6
			tb_style.corner_radius_top_left = 5
			tb_style.corner_radius_top_right = 5
			tb_style.bg_color = Color("3c3b37") if active else Color("2a2825")
			left_menu_btn.visible = false
			close_btn.text = "●"
			minimize_btn.text = "–"
			maximize_btn.text = "+"
			close_btn.add_theme_color_override("font_color", Color("df5320"))

		"motif_cde":
			outer_style.border_color = Color("d8e0e8") if active else Color("9098a0")
			outer_style.set_border_width_all(4)
			left_menu_btn.visible = true
			left_menu_btn.text = "—"
			minimize_btn.text = "▪"
			maximize_btn.text = "□"
			close_btn.text = "✕"

		"plan9_rio":
			outer_style.border_color = Color("55aaaa") if active else Color("9eeeee")
			outer_style.set_border_width_all(4)
			tb_style.bg_color = Color("55aaaa") if active else Color("bbeeee")
			tb_style.set_content_margin_all(2)
			tb_style.content_margin_left = 6
			left_menu_btn.visible = false
			minimize_btn.text = "hide"
			maximize_btn.text = "sweep"
			close_btn.text = "del"

		"os2_pmshell":
			outer_style.border_color = Color("d8d8e4")
			outer_style.set_border_width_all(3)
			left_menu_btn.visible = true
			left_menu_btn.text = "▣"
			minimize_btn.text = "▾"
			maximize_btn.text = "▴"
			close_btn.text = "✕"

		"win7_aero":
			outer_style.border_color = Color("2a4e7c") if active else Color("162840")
			outer_style.set_border_width_all(2)
			outer_style.corner_radius_top_left = 7
			outer_style.corner_radius_top_right = 7
			tb_style.corner_radius_top_left = 6
			tb_style.corner_radius_top_right = 6
			tb_style.bg_color = Color("143b66") if active else Color("0c1a2e")
			left_menu_btn.visible = true
			left_menu_btn.text = "🪟"
			minimize_btn.text = "–"
			maximize_btn.text = "□"
			close_btn.text = "✕"

		"winxp_luna":
			outer_style.border_color = Color("0046d5") if active else Color("5c76b8")
			outer_style.set_border_width_all(3)
			outer_style.corner_radius_top_left = 7
			outer_style.corner_radius_top_right = 7
			tb_style.corner_radius_top_left = 6
			tb_style.corner_radius_top_right = 6
			left_menu_btn.visible = true
			left_menu_btn.text = "👽"
			minimize_btn.text = "_"
			maximize_btn.text = "□"
			close_btn.text = "✕"

		"sgi_4dwm":
			outer_style.border_color = Color("dce2f2") if active else Color("8a92a6")
			outer_style.set_border_width_all(4)
			left_menu_btn.visible = true
			left_menu_btn.text = "—"
			minimize_btn.text = "▪"
			maximize_btn.text = "□"
			close_btn.text = "✕"

		"beos_yellowtab":
			outer_style.border_color = Color("555555")
			outer_style.set_border_width_all(2)
			tb_style.bg_color = Color("ffcc00") if active else Color("cccccc")
			left_menu_btn.visible = true
			left_menu_btn.text = "□"
			minimize_btn.text = "—"
			maximize_btn.text = "◰"
			close_btn.text = "✕"

		"nextstep_black":
			outer_style.border_color = Color("111111")
			outer_style.set_border_width_all(2)
			tb_style.bg_color = Color("0d0d0d") if active else Color("555555")
			left_menu_btn.visible = true
			left_menu_btn.text = "◰"
			minimize_btn.text = "▪"
			maximize_btn.text = "□"
			close_btn.text = "✕"

		"mac_platinum":
			outer_style.border_color = Color("222222")
			outer_style.set_border_width_all(2)
			tb_style.bg_color = Color("cccccc") if active else Color("e8e8e8")
			left_menu_btn.visible = true
			left_menu_btn.text = "□"
			minimize_btn.text = "⊟"
			maximize_btn.text = "◰"
			close_btn.text = "✕"

		"aqua_pinstripe":
			outer_style.border_color = Color("7a869a")
			outer_style.set_border_width_all(2)
			outer_style.corner_radius_top_left = 7
			outer_style.corner_radius_top_right = 7
			tb_style.corner_radius_top_left = 6
			tb_style.corner_radius_top_right = 6
			left_menu_btn.visible = true
			left_menu_btn.text = "●"
			minimize_btn.text = "—"
			maximize_btn.text = "+"
			close_btn.text = "✕"

		"amiga_workbench":
			outer_style.border_color = Color("ffffff")
			outer_style.set_border_width_all(2)
			tb_style.bg_color = Color("3b67a2") if active else Color("7a7a7a")
			left_menu_btn.visible = true
			left_menu_btn.text = "□"
			minimize_btn.text = "▾"
			maximize_btn.text = "◰"
			close_btn.text = "✕"

		"apple2_green":
			outer_style.border_color = Color("33ff55") if active else Color("187a28")
			outer_style.set_border_width_all(2)
			left_menu_btn.visible = false
			minimize_btn.text = "_"
			maximize_btn.text = "□"
			close_btn.text = "X"

		"datapoint_green":
			outer_style.border_color = Color("33ff55") if active else Color("145322")
			outer_style.set_border_width_all(2)
			tb_style.bg_color = Color("0e3816") if active else Color("061a0a")
			left_menu_btn.visible = false
			minimize_btn.text = "_"
			maximize_btn.text = "□"
			close_btn.text = "X"

		"pdp7_teletype":
			outer_style.border_color = Color("bdae8c") if active else Color("6e6552")
			outer_style.set_border_width_all(2)
			outer_style.bg_color = Color("f5eed7")
			tb_style.bg_color = Color("383227") if active else Color("221f18")
			body_style.bg_color = Color("f8f4e6")
			left_menu_btn.visible = true
			left_menu_btn.text = "📠"
			minimize_btn.text = "_"
			maximize_btn.text = "□"
			close_btn.text = "X"

		_: # "win98_classic"
			outer_style.border_color = Color("dfdfdf")
			outer_style.set_border_width_all(2)
			left_menu_btn.visible = true
			left_menu_btn.text = "■"
			minimize_btn.text = "_"
			maximize_btn.text = "□"
			close_btn.text = "X"

	add_theme_stylebox_override("panel", outer_style)
	title_bar.add_theme_stylebox_override("panel", tb_style)
	body_panel.add_theme_stylebox_override("panel", body_style)
	title_label.add_theme_color_override("font_color", profile.titlebar_text_color)

	var title_hbox: HBoxContainer = $OuterVBox/TitleBar/TitleHBox
	if profile.chrome_style == "ubuntu_ambiance":
		title_hbox.move_child(close_btn, 0)
		title_hbox.move_child(minimize_btn, 1)
		title_hbox.move_child(maximize_btn, 2)
		title_hbox.move_child(title_label, 3)
	else:
		title_hbox.move_child(left_menu_btn, 0)
		title_hbox.move_child(title_label, 1)
		title_hbox.move_child(minimize_btn, 2)
		title_hbox.move_child(maximize_btn, 3)
		title_hbox.move_child(close_btn, 4)


# ==============================================================================
# DRAGGING, FOCUS, AND WINDOW CONTROLS
# ==============================================================================

func _on_window_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		move_to_front()
		window_focused.emit(self)


func _on_title_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				move_to_front()
				window_focused.emit(self)
				if event.double_click:
					_toggle_shade()
					return
				if not is_maximized:
					_dragging = true
					_drag_offset = get_global_mouse_position() - global_position
			else:
				_dragging = false
	elif event is InputEventMouseMotion and _dragging and not is_maximized:
		var target_pos := get_global_mouse_position() - _drag_offset
		var parent_ctrl := get_parent_control()
		if parent_ctrl:
			var parent_rect := parent_ctrl.get_global_rect()
			target_pos.x = clampf(target_pos.x, parent_rect.position.x - size.x + 80.0, parent_rect.end.x - 80.0)
			target_pos.y = clampf(target_pos.y, parent_rect.position.y, parent_rect.end.y - 64.0)
		else:
			var vp_size := get_viewport_rect().size
			target_pos.x = clampf(target_pos.x, -size.x + 80.0, vp_size.x - 80.0)
			target_pos.y = clampf(target_pos.y, 0.0, vp_size.y - 64.0)
		global_position = target_pos


func _toggle_shade() -> void:
	AudioManager.play_hdd_click(0.05)
	is_shaded = not is_shaded
	body_panel.visible = not is_shaded
	if is_shaded:
		_saved_rect.size = size
		custom_minimum_size = Vector2(240, 30)
		size = Vector2(size.x, 30)
	else:
		custom_minimum_size = Vector2(240, 140)
		size = _saved_rect.size


func _on_left_menu_pressed() -> void:
	_toggle_shade()


func _on_minimize_pressed() -> void:
	AudioManager.play_hdd_click(0.05)
	visible = false
	window_minimized.emit(self)


func _on_maximize_pressed() -> void:
	AudioManager.play_hdd_click(0.05)
	if is_shaded:
		_toggle_shade()
	is_maximized = not is_maximized
	if is_maximized:
		_saved_rect = Rect2(position, size)
		var parent_ctrl := get_parent_control()
		var area_size := parent_ctrl.size if parent_ctrl else get_viewport_rect().size
		position = Vector2(4, 32)
		size = Vector2(area_size.x - 8, area_size.y - 72)
	else:
		position = _saved_rect.position
		size = _saved_rect.size


func _on_close_pressed() -> void:
	AudioManager.play_hdd_click(0.06)
	visible = false
	window_closed.emit(self)

