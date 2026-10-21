class_name MainMenu
extends Control
## Main Menu / Multi-System KVM Boot Manager (`MainMenu`).
## Dynamically populates the list of 17 selectable operating systems and classic computers
## from `GameState.available_profiles` sorted chronologically (newest at top, oldest at bottom) with category filtering.

const OSProfile = preload("res://data/os_profile.gd")

@onready var selector_vbox: VBoxContainer = $MarginContainer/MainVBox/ContentHBox/LeftSelectorPanel/SelectorMargin/SelectorVBox
@onready var selector_header: Label = $MarginContainer/MainVBox/ContentHBox/LeftSelectorPanel/SelectorMargin/SelectorVBox/SelectorHeader
@onready var os_list_vbox: VBoxContainer = $MarginContainer/MainVBox/ContentHBox/LeftSelectorPanel/SelectorMargin/SelectorVBox/OSListScroll/OSListVBox
@onready var preview_title: Label = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/PreviewTitle
@onready var preview_meta: Label = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/PreviewMeta
@onready var preview_arch: Label = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/SpecsPanel/SpecsMargin/SpecsVBox/ArchValue
@onready var preview_hw: Label = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/SpecsPanel/SpecsMargin/SpecsVBox/HardwareValue
@onready var preview_shell: Label = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/SpecsPanel/SpecsMargin/SpecsVBox/ShellValue
@onready var preview_desc: RichTextLabel = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/DescriptionLabel

@onready var swatch_desktop: ColorRect = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/SwatchRow/SwatchDesktop
@onready var swatch_titlebar: ColorRect = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/SwatchRow/SwatchTitlebar
@onready var swatch_window: ColorRect = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/SwatchRow/SwatchWindow
@onready var swatch_terminal: ColorRect = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/SwatchRow/SwatchTerminal

@onready var test_chime_btn: Button = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/AudioBenchRow/TestChimeBtn
@onready var test_hdd_btn: Button = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/AudioBenchRow/TestHDDBtn
@onready var test_floppy_btn: Button = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/AudioBenchRow/TestFloppyBtn
@onready var boot_button: Button = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/BootButton

var _selected_profile: OSProfile
var _os_buttons: Dictionary = {}
var _active_category: String = "ALL"
var _filter_grid: HFlowContainer


func _ready() -> void:
	_build_category_filter_bar()
	_populate_os_selector()

	test_chime_btn.pressed.connect(func():
		if _selected_profile:
			AudioManager.play_os_startup_sound(_selected_profile.id)
	)
	test_hdd_btn.pressed.connect(func(): AudioManager.play_hdd_burst())
	test_floppy_btn.pressed.connect(_on_test_removable_media_pressed)
	boot_button.pressed.connect(_on_boot_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		_on_boot_pressed()


func _build_category_filter_bar() -> void:
	_filter_grid = HFlowContainer.new()
	_filter_grid.add_theme_constant_override("h_separation", 4)
	_filter_grid.add_theme_constant_override("v_separation", 4)
	selector_vbox.add_child(_filter_grid)
	selector_vbox.move_child(_filter_grid, 1)

	var categories := [
		{"key": "ALL", "label": "All Computers (%d)" % GameState.available_profiles.size()},
		{"key": "PC & OS/2", "label": "PC & OS/2"},
		{"key": "UNIX & Alt-OS", "label": "UNIX / BeOS / NeXT"},
		{"key": "Mac & Home Classics", "label": "Mac / Amiga / Apple //e"},
	]

	for cat in categories:
		var c_btn := Button.new()
		c_btn.text = str(cat["label"])
		c_btn.focus_mode = Control.FOCUS_NONE
		c_btn.add_theme_font_size_override("font_size", 11)
		var cat_key := str(cat["key"])
		c_btn.pressed.connect(func():
			AudioManager.play_hdd_click(0.04)
			_active_category = cat_key
			_populate_os_selector()
		)
		_filter_grid.add_child(c_btn)


func _populate_os_selector() -> void:
	for child in os_list_vbox.get_children():
		child.queue_free()
	_os_buttons.clear()

	var profiles := GameState.available_profiles
	var shown_count := 0

	for i in range(profiles.size()):
		var p := profiles[i]
		if _active_category != "ALL" and p.category != _active_category:
			continue
		shown_count += 1
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(0, 40)
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.text = " [%02d] %s (%s)" % [i + 1, p.display_name, p.release_year]
		btn.clip_text = true
		btn.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		btn.tooltip_text = "[%02d] %s (%s)\n%s\n%s" % [i + 1, p.display_name, p.release_year, p.vendor, p.hardware_profile]
		btn.add_theme_font_size_override("font_size", 13)
		btn.pressed.connect(func():
			AudioManager.play_hdd_click(0.05)
			_select_profile_for_preview(p)
		)
		os_list_vbox.add_child(btn)
		_os_buttons[p.id] = btn

	selector_header.text = "WORKSTATION ROSTER (%d SHOWN)" % shown_count

	# Add an expansion slot indicator showing how new OS profiles are discovered
	var expansion_label := Label.new()
	expansion_label.text = "\n  [ + ] Expansion Bay: Drop .tres into res://data/profiles/\n        or register in data/catalog_*.gd"
	expansion_label.add_theme_font_size_override("font_size", 11)
	expansion_label.add_theme_color_override("font_color", Color("6e8494"))
	os_list_vbox.add_child(expansion_label)

	if not profiles.is_empty():
		var initial := GameState.current_profile if GameState.current_profile else profiles[0]
		_select_profile_for_preview(initial)


func _select_profile_for_preview(profile: OSProfile) -> void:
	_selected_profile = profile
	GameState.current_profile = profile

	# Highlight active button in list
	for os_id in _os_buttons.keys():
		var btn: Button = _os_buttons[os_id]
		var style := StyleBoxFlat.new()
		if os_id == profile.id:
			style.bg_color = Color("1b3a4b")
			style.border_color = Color("4ea8de")
			style.set_border_width_all(2)
		else:
			style.bg_color = Color("11161d")
			style.border_color = Color("2b3642")
			style.set_border_width_all(1)
		style.set_content_margin_all(7)
		btn.add_theme_stylebox_override("normal", style)
		btn.add_theme_stylebox_override("hover", style)
		btn.add_theme_stylebox_override("pressed", style)

	preview_title.text = profile.display_name
	preview_meta.text = "[%s]  •  %s  •  Released %s" % [profile.category, profile.vendor, profile.release_year]
	preview_arch.text = "Architecture : " + profile.architecture_summary
	preview_hw.text = "Hardware     : " + profile.hardware_profile
	preview_shell.text = "Terminal     : " + profile.terminal_title + " (" + profile.terminal_prompt.strip_edges() + ")"
	preview_desc.text = profile.description

	swatch_desktop.color = profile.desktop_bg_color
	swatch_titlebar.color = profile.titlebar_active_color
	swatch_window.color = profile.window_bg_color
	swatch_terminal.color = profile.terminal_bg_color

	if profile.id == "apple_iie":
		test_floppy_btn.text = "💾 Test Disk II"
	else:
		test_floppy_btn.text = "💾 Test Floppy"

	boot_button.text = "⚡ POWER ON & BOOT " + profile.short_name.to_upper()


func _on_test_removable_media_pressed() -> void:
	if not _selected_profile:
		AudioManager.play_floppy_seek()
		return
	if _selected_profile.id == "apple_iie":
		AudioManager.play_disk2_bang()
	else:
		AudioManager.play_floppy_seek()


func _on_boot_pressed() -> void:
	if not _selected_profile:
		return
	AudioManager.play_post_beep()
	GameState.select_and_boot_os(_selected_profile.id)
