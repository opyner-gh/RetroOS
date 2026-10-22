class_name MainMenu
extends Control
## Main Menu / Wikipedia-Inspired Interactive Digital Computing Museum & Codex (`MainMenu`).
## Designed for 1280x720+ resolution with a hideable computer selection sidebar,
## encyclopedic historical articles, period-correct usage case dossiers, structured
## Wikipedia-style technical specification infoboxes, and historical/generated image slots.

const OSProfile = preload("res://data/os_profile.gd")
const ExhibitCodex = preload("res://data/exhibit_codex.gd")
const PlateRenderer = preload("res://scenes/menu/exhibit_plate_renderer.gd")

@onready var background_rect: ColorRect = $Background
@onready var header_panel: PanelContainer = $MarginContainer/MainVBox/HeaderPanel
@onready var sidebar_toggle_btn: Button = $MarginContainer/MainVBox/HeaderPanel/HeaderMargin/HeaderHBox/SidebarToggleBtn
@onready var header_title_label: Label = $MarginContainer/MainVBox/HeaderPanel/HeaderMargin/HeaderHBox/HeaderVBox/TitleLabel
@onready var header_subtitle_label: Label = $MarginContainer/MainVBox/HeaderPanel/HeaderMargin/HeaderHBox/HeaderVBox/SubtitleLabel
@onready var search_input: LineEdit = $MarginContainer/MainVBox/HeaderPanel/HeaderMargin/HeaderHBox/SearchInput
@onready var wiki_theme_btn: Button = $MarginContainer/MainVBox/HeaderPanel/HeaderMargin/HeaderHBox/WikiThemeBtn
@onready var top_boot_btn: Button = $MarginContainer/MainVBox/HeaderPanel/HeaderMargin/HeaderHBox/TopBootBtn

@onready var left_selector_panel: PanelContainer = $MarginContainer/MainVBox/ContentHBox/LeftSelectorPanel
@onready var selector_vbox: VBoxContainer = $MarginContainer/MainVBox/ContentHBox/LeftSelectorPanel/SelectorMargin/SelectorVBox
@onready var selector_header: Label = $MarginContainer/MainVBox/ContentHBox/LeftSelectorPanel/SelectorMargin/SelectorVBox/SelectorHeader
@onready var os_list_vbox: VBoxContainer = $MarginContainer/MainVBox/ContentHBox/LeftSelectorPanel/SelectorMargin/SelectorVBox/OSListScroll/OSListVBox

@onready var right_preview_panel: PanelContainer = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel
@onready var preview_title: Label = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/ArticleBannerHBox/TitleBlockVBox/PreviewTitle
@onready var preview_meta: Label = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/ArticleBannerHBox/TitleBlockVBox/PreviewMeta
@onready var banner_boot_btn: Button = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/ArticleBannerHBox/BannerBootBtn
@onready var section_nav_hbox: HBoxContainer = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/SectionNavHBox
@onready var codex_scroll: ScrollContainer = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll

@onready var preview_desc: RichTextLabel = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/ArticleColumnVBox/DescriptionLabel
@onready var dynamic_sections_vbox: VBoxContainer = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/ArticleColumnVBox/DynamicSectionsVBox

@onready var infobox_panel: PanelContainer = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel
@onready var infobox_header_panel: PanelContainer = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/InfoboxHeaderPanel
@onready var infobox_header_label: Label = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/InfoboxHeaderPanel/InfoboxHeaderLabel
@onready var plate_container: PanelContainer = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/PlateContainer
@onready var plate_caption_label: Label = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/PlateCaptionLabel
@onready var plate_slot_tabs_hbox: HBoxContainer = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/PlateSlotTabsHBox

@onready var preview_arch: Label = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/SpecsPanel/SpecsMargin/SpecsVBox/ArchValue
@onready var preview_hw: Label = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/SpecsPanel/SpecsMargin/SpecsVBox/HardwareValue
@onready var preview_shell: Label = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/SpecsPanel/SpecsMargin/SpecsVBox/ShellValue
@onready var specs_panel: PanelContainer = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/SpecsPanel
@onready var infobox_specs_table_vbox: VBoxContainer = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/SpecsPanel/SpecsMargin/SpecsVBox/InfoboxSpecsTableVBox

@onready var swatch_desktop: ColorRect = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/SwatchRow/SwatchDesktop
@onready var swatch_titlebar: ColorRect = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/SwatchRow/SwatchTitlebar
@onready var swatch_window: ColorRect = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/SwatchRow/SwatchWindow
@onready var swatch_terminal: ColorRect = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/SwatchRow/SwatchTerminal

@onready var test_chime_btn: Button = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/AudioBenchRow/TestChimeBtn
@onready var test_hdd_btn: Button = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/AudioBenchRow/TestHDDBtn
@onready var test_floppy_btn: Button = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/AudioBenchRow/TestFloppyBtn
@onready var boot_button: Button = $MarginContainer/MainVBox/ContentHBox/RightPreviewPanel/PreviewMargin/PreviewVBox/CodexScroll/CodexColumnsHBox/InfoboxPanel/InfoboxMargin/InfoboxVBox/BootButton

var _selected_profile: OSProfile
var _os_buttons: Dictionary = {}
var _active_category: String = "ALL"
var _search_query: String = ""
var _active_section_filter: String = "ALL"
var _active_plate_slot_idx: int = 0
var _sidebar_visible: bool = true
var _wiki_light_mode: bool = false

var _filter_grid: HFlowContainer
var _infobox_plate_renderer: Control
var _gallery_plate_renderers: Array[Control] = []
var _file_dialog: FileDialog
var _pending_import_slot_id: String = "system"


func _ready() -> void:
	_setup_infobox_plate_viewer()
	_setup_image_import_dialog()
	_build_category_filter_bar()
	_build_section_nav_bar()
	_apply_codex_theme()
	_populate_os_selector()

	sidebar_toggle_btn.pressed.connect(_toggle_sidebar)
	wiki_theme_btn.pressed.connect(_toggle_wiki_theme)
	search_input.text_changed.connect(_on_search_text_changed)

	test_chime_btn.pressed.connect(func():
		if _selected_profile:
			AudioManager.play_os_startup_sound(_selected_profile.id)
	)
	test_hdd_btn.pressed.connect(func(): AudioManager.play_hdd_burst())
	test_floppy_btn.pressed.connect(_on_test_removable_media_pressed)
	boot_button.pressed.connect(_on_boot_pressed)
	top_boot_btn.pressed.connect(_on_boot_pressed)
	banner_boot_btn.pressed.connect(_on_boot_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_TAB and not search_input.has_focus():
			_toggle_sidebar()
			get_viewport().set_input_as_handled()
		elif (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER or event.keycode == KEY_SPACE) and not search_input.has_focus():
			_on_boot_pressed()
			get_viewport().set_input_as_handled()


func _toggle_sidebar() -> void:
	AudioManager.play_hdd_click(0.03)
	_sidebar_visible = not _sidebar_visible
	left_selector_panel.visible = _sidebar_visible
	if _sidebar_visible:
		sidebar_toggle_btn.text = "☰ Hide Sidebar [Tab]"
	else:
		sidebar_toggle_btn.text = "☰ Show Catalog (%d) [Tab]" % GameState.available_profiles.size()


func _toggle_wiki_theme() -> void:
	AudioManager.play_hdd_click(0.04)
	_wiki_light_mode = not _wiki_light_mode
	if _wiki_light_mode:
		wiki_theme_btn.text = "🌙 Dark Archive Mode"
	else:
		wiki_theme_btn.text = "📖 Wiki Light Mode"
	_apply_codex_theme()
	if _selected_profile:
		_select_profile_for_preview(_selected_profile)


func _on_search_text_changed(new_text: String) -> void:
	_search_query = new_text.strip_edges().to_lower()
	_populate_os_selector()


func _setup_infobox_plate_viewer() -> void:
	_infobox_plate_renderer = PlateRenderer.new()
	_infobox_plate_renderer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_infobox_plate_renderer.custom_minimum_size = Vector2(332, 180)
	plate_container.add_child(_infobox_plate_renderer)

	var slot_defs := [
		{"idx": 0, "label": "🖥 System"},
		{"idx": 1, "label": "🔬 Hardware"},
		{"idx": 2, "label": "🪟 Software"}
	]
	for sd in slot_defs:
		var btn := Button.new()
		btn.text = str(sd["label"])
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.focus_mode = Control.FOCUS_NONE
		btn.add_theme_font_size_override("font_size", 11)
		var idx := int(sd["idx"])
		btn.pressed.connect(func():
			AudioManager.play_hdd_click(0.03)
			_active_plate_slot_idx = idx
			_update_infobox_plate()
		)
		plate_slot_tabs_hbox.add_child(btn)

	var attach_btn := Button.new()
	attach_btn.text = "📂 Image"
	attach_btn.tooltip_text = "Attach or replace historical/generated image for the active slot"
	attach_btn.focus_mode = Control.FOCUS_NONE
	attach_btn.add_theme_font_size_override("font_size", 11)
	attach_btn.pressed.connect(func():
		if not _selected_profile:
			return
		var slots := _selected_profile.exhibit_images
		if _active_plate_slot_idx < slots.size():
			_open_image_import_for_slot(str(slots[_active_plate_slot_idx].get("slot_id", "system")))
	)
	plate_slot_tabs_hbox.add_child(attach_btn)


func _setup_image_import_dialog() -> void:
	_file_dialog = FileDialog.new()
	_file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	_file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	_file_dialog.title = "Select Historical or Generated Exhibit Image (.png, .jpg, .webp)"
	_file_dialog.filters = PackedStringArray([
		"*.png, *.jpg, *.jpeg, *.webp ; Image Files"
	])
	_file_dialog.size = Vector2i(760, 480)
	_file_dialog.file_selected.connect(_on_import_file_selected)
	add_child(_file_dialog)


func _open_image_import_for_slot(slot_id: String) -> void:
	_pending_import_slot_id = slot_id
	_file_dialog.popup_centered()


func _on_import_file_selected(file_path: String) -> void:
	if not _selected_profile:
		return
	var tex := ExhibitCodex.import_exhibit_image_from_file(_selected_profile.id, _pending_import_slot_id, file_path)
	if tex != null:
		AudioManager.play_hdd_burst()
		_update_infobox_plate()
		for gr in _gallery_plate_renderers:
			if is_instance_valid(gr):
				gr.refresh_texture()


func _build_category_filter_bar() -> void:
	_filter_grid = HFlowContainer.new()
	_filter_grid.add_theme_constant_override("h_separation", 4)
	_filter_grid.add_theme_constant_override("v_separation", 4)
	selector_vbox.add_child(_filter_grid)
	selector_vbox.move_child(_filter_grid, 1)

	var categories := [
		{"key": "ALL", "label": "All (17)"},
		{"key": "PC & OS/2", "label": "PC & OS/2"},
		{"key": "UNIX & Alt-OS", "label": "UNIX / BeOS / NeXT"},
		{"key": "Mac & Home Classics", "label": "Mac / Amiga / IIe"},
	]

	for cat in categories:
		var c_btn := Button.new()
		c_btn.text = str(cat["label"])
		c_btn.focus_mode = Control.FOCUS_NONE
		c_btn.add_theme_font_size_override("font_size", 10)
		var cat_key := str(cat["key"])
		c_btn.pressed.connect(func():
			AudioManager.play_hdd_click(0.04)
			_active_category = cat_key
			_populate_os_selector()
		)
		_filter_grid.add_child(c_btn)


func _build_section_nav_bar() -> void:
	for child in section_nav_hbox.get_children():
		child.queue_free()

	var tabs := [
		{"key": "ALL", "label": "📜 Full Encyclopedia Article"},
		{"key": "HISTORY", "label": "🏛️ 1. History & Engineering"},
		{"key": "USAGE", "label": "💼 2. Period Usage Cases"},
		{"key": "GALLERY", "label": "🖼️ 3. Media & Image Archive"},
		{"key": "MANIFEST", "label": "📟 4. BIOS & Shell Manifest"},
	]

	for tab in tabs:
		var btn := Button.new()
		btn.text = str(tab["label"])
		btn.focus_mode = Control.FOCUS_NONE
		btn.add_theme_font_size_override("font_size", 11)
		var tab_key := str(tab["key"])
		btn.pressed.connect(func():
			AudioManager.play_hdd_click(0.03)
			_active_section_filter = tab_key
			if _selected_profile:
				_rebuild_codex_article(_selected_profile)
				codex_scroll.scroll_vertical = 0
		)
		section_nav_hbox.add_child(btn)


func _apply_codex_theme() -> void:
	var header_sb := StyleBoxFlat.new()
	var left_sb := StyleBoxFlat.new()
	var right_sb := StyleBoxFlat.new()
	var infobox_sb := StyleBoxFlat.new()
	var specs_sb := StyleBoxFlat.new()

	if _wiki_light_mode:
		# Classic Wikipedia Parchment / Light Encyclopedia Mode
		background_rect.color = Color("eaecf0")
		header_sb.bg_color = Color("f8f9fa")
		header_sb.border_color = Color("a2a9b1")
		header_sb.set_border_width_all(1)
		header_title_label.add_theme_color_override("font_color", Color("101418"))
		header_subtitle_label.add_theme_color_override("font_color", Color("54595d"))

		left_sb.bg_color = Color("f8f9fa")
		left_sb.border_color = Color("a2a9b1")
		left_sb.set_border_width_all(1)
		selector_header.add_theme_color_override("font_color", Color("202122"))

		right_sb.bg_color = Color("ffffff")
		right_sb.border_color = Color("a2a9b1")
		right_sb.set_border_width_all(1)
		preview_title.add_theme_color_override("font_color", Color("101418"))
		preview_meta.add_theme_color_override("font_color", Color("3366cc"))
		preview_desc.add_theme_color_override("default_color", Color("202122"))

		infobox_sb.bg_color = Color("f8f9fa")
		infobox_sb.border_color = Color("a2a9b1")
		infobox_sb.set_border_width_all(1)
		plate_caption_label.add_theme_color_override("font_color", Color("54595d"))

		specs_sb.bg_color = Color("f0f2f5")
		specs_sb.border_color = Color("c8ccd1")
		specs_sb.set_border_width_all(1)
	else:
		# Dark Archival Museum Mode
		background_rect.color = Color("0d1117")
		header_sb.bg_color = Color("161b22")
		header_sb.border_color = Color("30363d")
		header_sb.set_border_width_all(1)
		header_title_label.add_theme_color_override("font_color", Color("56d364"))
		header_subtitle_label.add_theme_color_override("font_color", Color("8b949e"))

		left_sb.bg_color = Color("131820")
		left_sb.border_color = Color("2b3642")
		left_sb.set_border_width_all(1)
		selector_header.add_theme_color_override("font_color", Color("f2cc60"))

		right_sb.bg_color = Color("0f141b")
		right_sb.border_color = Color("2b3642")
		right_sb.set_border_width_all(1)
		preview_title.add_theme_color_override("font_color", Color("f0f6fc"))
		preview_meta.add_theme_color_override("font_color", Color("58a6ff"))
		preview_desc.add_theme_color_override("default_color", Color("c9d1d9"))

		infobox_sb.bg_color = Color("161c24")
		infobox_sb.border_color = Color("344252")
		infobox_sb.set_border_width_all(1)
		plate_caption_label.add_theme_color_override("font_color", Color("9ec1db"))

		specs_sb.bg_color = Color("10151c")
		specs_sb.border_color = Color("263240")
		specs_sb.set_border_width_all(1)

	header_panel.add_theme_stylebox_override("panel", header_sb)
	left_selector_panel.add_theme_stylebox_override("panel", left_sb)
	right_preview_panel.add_theme_stylebox_override("panel", right_sb)
	infobox_panel.add_theme_stylebox_override("panel", infobox_sb)
	specs_panel.add_theme_stylebox_override("panel", specs_sb)

	if is_instance_valid(top_boot_btn):
		_style_boot_button(top_boot_btn, true)
	if is_instance_valid(banner_boot_btn):
		_style_boot_button(banner_boot_btn, false)
	if is_instance_valid(boot_button):
		_style_boot_button(boot_button, false)


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
		if not _search_query.is_empty():
			var haystack := (
				p.display_name + " " + p.release_year + " " + p.vendor + " "
				+ p.architecture_summary + " " + p.hardware_profile + " " + p.exhibit_subtitle
			).to_lower()
			if not haystack.contains(_search_query):
				continue

		shown_count += 1
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(0, 38)
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.text = " [%02d] %s • %s" % [i + 1, p.release_year, p.display_name]
		btn.clip_text = true
		btn.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		btn.tooltip_text = "[%02d] %s (%s)\n%s\n%s\n\n⚡ Click again or press ENTER to boot live system!" % [
			i + 1, p.display_name, p.release_year, p.vendor, p.hardware_profile
		]
		btn.add_theme_font_size_override("font_size", 12)
		btn.pressed.connect(func():
			AudioManager.play_hdd_click(0.05)
			if _selected_profile and _selected_profile.id == p.id:
				_on_boot_pressed()
			else:
				_select_profile_for_preview(p)
		)
		os_list_vbox.add_child(btn)
		_os_buttons[p.id] = btn

	selector_header.text = "EXHIBIT CATALOG (%d SHOWN)" % shown_count

	var expansion_label := Label.new()
	expansion_label.text = "\n [+] Drop .tres in res://data/profiles/\n     or images in res://assets/exhibits/"
	expansion_label.add_theme_font_size_override("font_size", 10)
	expansion_label.add_theme_color_override("font_color", Color("6e8494"))
	os_list_vbox.add_child(expansion_label)

	if not profiles.is_empty():
		var initial := GameState.current_profile if GameState.current_profile else profiles[0]
		_select_profile_for_preview(initial)


func _select_profile_for_preview(profile: OSProfile) -> void:
	_selected_profile = profile
	GameState.current_profile = profile

	# Style sidebar buttons
	for os_id in _os_buttons.keys():
		var btn: Button = _os_buttons[os_id]
		var style := StyleBoxFlat.new()
		if os_id == profile.id:
			style.bg_color = Color("dce8f8") if _wiki_light_mode else Color("1b3a4b")
			style.border_color = Color("3366cc") if _wiki_light_mode else Color("4ea8de")
			style.set_border_width_all(2)
			btn.add_theme_color_override("font_color", Color("101418") if _wiki_light_mode else Color("ffffff"))
		else:
			style.bg_color = Color("ffffff") if _wiki_light_mode else Color("11161d")
			style.border_color = Color("c8ccd1") if _wiki_light_mode else Color("2b3642")
			style.set_border_width_all(1)
			btn.add_theme_color_override("font_color", Color("202122") if _wiki_light_mode else Color("c9d1d9"))
		style.set_content_margin_all(6)
		btn.add_theme_stylebox_override("normal", style)
		btn.add_theme_stylebox_override("hover", style)
		btn.add_theme_stylebox_override("pressed", style)

	# Article Banner Title & Wikipedia Attribution Line
	preview_title.text = profile.display_name
	preview_meta.text = "From RetroOS Digital Computing Codex  •  %s  •  %s  •  [%s]" % [
		profile.era_classification if not profile.era_classification.is_empty() else ("Released " + profile.release_year),
		profile.vendor,
		profile.category
	]

	# Keep hidden compatibility labels updated
	preview_arch.text = "Architecture : " + profile.architecture_summary
	preview_hw.text = "Hardware     : " + profile.hardware_profile
	preview_shell.text = "Terminal     : " + profile.terminal_title + " (" + profile.terminal_prompt.strip_edges() + ")"

	# Update Right-Hand Wikipedia Infobox
	var ib_header_style := StyleBoxFlat.new()
	ib_header_style.bg_color = profile.titlebar_active_color
	ib_header_style.set_content_margin_all(5)
	infobox_header_panel.add_theme_stylebox_override("panel", ib_header_style)
	infobox_header_label.text = "%s (%s)" % [profile.short_name, profile.release_year]
	infobox_header_label.add_theme_color_override("font_color", profile.titlebar_text_color)

	_update_infobox_plate()
	_rebuild_infobox_specs_table(profile)

	swatch_desktop.color = profile.desktop_bg_color
	swatch_titlebar.color = profile.titlebar_active_color
	swatch_window.color = profile.window_bg_color
	swatch_terminal.color = profile.terminal_bg_color

	if profile.id == "apple_iie":
		test_floppy_btn.text = "💾 Disk II"
	else:
		test_floppy_btn.text = "💾 Floppy"

	top_boot_btn.text = "⚡ BOOT %s [Enter]" % profile.short_name.to_upper()
	banner_boot_btn.text = "⚡ POWER ON & BOOT %s [ENTER]" % profile.short_name.to_upper()
	boot_button.text = "⚡ POWER ON & BOOT %s" % profile.short_name.to_upper()

	_style_boot_button(top_boot_btn, true)
	_style_boot_button(banner_boot_btn, false)
	_style_boot_button(boot_button, false)

	# Rebuild the Wikipedia Article Body & Usage Case Dossiers
	_rebuild_codex_article(profile)


func _update_infobox_plate() -> void:
	if not _selected_profile:
		return
	var slots := _selected_profile.exhibit_images
	if slots.is_empty():
		return
	var idx := clampi(_active_plate_slot_idx, 0, slots.size() - 1)
	var slot_dict: Dictionary = slots[idx]
	_infobox_plate_renderer.setup_plate(_selected_profile, slot_dict)
	plate_caption_label.text = str(slot_dict.get("title", ""))


func _rebuild_infobox_specs_table(profile: OSProfile) -> void:
	for child in infobox_specs_table_vbox.get_children():
		child.queue_free()

	var row_idx := 0
	for key in profile.technical_specs.keys():
		var val := str(profile.technical_specs[key])
		var row_panel := PanelContainer.new()
		var row_sb := StyleBoxFlat.new()
		if _wiki_light_mode:
			row_sb.bg_color = Color("eaecf0") if (row_idx % 2 == 0) else Color("f8f9fa")
		else:
			row_sb.bg_color = Color("161f29") if (row_idx % 2 == 0) else Color("111720")
		row_sb.set_content_margin_all(4)
		row_panel.add_theme_stylebox_override("panel", row_sb)

		var hbox := HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 6)

		var k_lbl := Label.new()
		k_lbl.custom_minimum_size = Vector2(114, 0)
		k_lbl.text = str(key)
		k_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		k_lbl.add_theme_font_size_override("font_size", 11)
		k_lbl.add_theme_color_override("font_color", Color("202122") if _wiki_light_mode else Color("8ecae6"))
		hbox.add_child(k_lbl)

		var v_lbl := Label.new()
		v_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		v_lbl.text = val
		v_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		v_lbl.add_theme_font_size_override("font_size", 11)
		v_lbl.add_theme_color_override("font_color", Color("101418") if _wiki_light_mode else Color("e6edf3"))
		hbox.add_child(v_lbl)

		row_panel.add_child(hbox)
		infobox_specs_table_vbox.add_child(row_panel)
		row_idx += 1


func _rebuild_codex_article(profile: OSProfile) -> void:
	# 1. Lead Encyclopedic Overview + Subtitle
	var subtitle_col := "#1d4ed8" if _wiki_light_mode else "#79c0ff"
	var lead_bbcode := "[b][color=%s]%s[/color][/b]\n\n%s" % [
		subtitle_col,
		profile.exhibit_subtitle,
		profile.historical_overview if not profile.historical_overview.is_empty() else profile.description
	]
	preview_desc.text = lead_bbcode

	for child in dynamic_sections_vbox.get_children():
		child.queue_free()
	_gallery_plate_renderers.clear()

	# 2. Wikipedia-Style Table of Contents Box (when in Full Article view)
	if _active_section_filter == "ALL":
		dynamic_sections_vbox.add_child(_create_wiki_toc_box(profile))

	# 3. Section 1 & 2: Historical Context & Engineering Innovations
	if _active_section_filter in ["ALL", "HISTORY"]:
		_add_wiki_section_header("1. Historical Context & Origins")
		dynamic_sections_vbox.add_child(_create_article_paragraph(profile.historical_context))

		_add_wiki_section_header("2. Architecture & Engineering Innovations")
		dynamic_sections_vbox.add_child(_create_article_paragraph(profile.engineering_innovations))

	# 4. Section 3: Period-Correct Usage Cases & Real-World Deployment
	if _active_section_filter in ["ALL", "USAGE"]:
		_add_wiki_section_header("3. Period-Correct Usage Cases & Real-World Deployment")
		var uc_intro := _create_article_paragraph(
			"The following archival case studies document how %s was deployed and operated in period-authentic professional, academic, and enthusiast environments during the %s era:" % [
				profile.display_name, profile.release_year
			]
		)
		dynamic_sections_vbox.add_child(uc_intro)

		for i in range(profile.usage_cases.size()):
			var uc: Dictionary = profile.usage_cases[i]
			dynamic_sections_vbox.add_child(_create_usage_case_card(i + 1, uc))

	# 5. Section 4: Cultural Legacy & Archival Notes
	if _active_section_filter in ["ALL", "HISTORY"]:
		_add_wiki_section_header("4. Cultural Legacy & Archival Significance")
		dynamic_sections_vbox.add_child(_create_article_paragraph(profile.cultural_legacy))

	# 6. Section 5: Curatorial Media & Image Archive (Historical / Generated Image Provision)
	if _active_section_filter in ["ALL", "GALLERY"]:
		_add_wiki_section_header("5. Curatorial Media & Image Archive")
		dynamic_sections_vbox.add_child(_create_media_gallery_section(profile))

	# 7. Section 6: Emulated BIOS POST & Interactive Shell Manifest
	if _active_section_filter in ["ALL", "MANIFEST"]:
		_add_wiki_section_header("6. Emulated Firmware, BIOS POST & Terminal Command Manifest")
		dynamic_sections_vbox.add_child(_create_bios_and_shell_manifest(profile))


func _create_wiki_toc_box(profile: OSProfile) -> PanelContainer:
	var panel := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("f8f9fa") if _wiki_light_mode else Color("141b24")
	sb.border_color = Color("a2a9b1") if _wiki_light_mode else Color("2d3b4d")
	sb.set_border_width_all(1)
	sb.set_content_margin_all(10)
	panel.add_theme_stylebox_override("panel", sb)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 3)

	var title := Label.new()
	title.text = "📑 Contents [RetroOS Archival Dossier — %d Usage Cases, %d Media Plates]" % [
		profile.usage_cases.size(), profile.exhibit_images.size()
	]
	title.add_theme_font_size_override("font_size", 12)
	title.add_theme_color_override("font_color", Color("101418") if _wiki_light_mode else Color("f2cc60"))
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(title)

	var toc_lines := PackedStringArray([
		"  1  Historical Context & Origins",
		"  2  Architecture & Engineering Innovations"
	])
	toc_lines.append("  3  Period-Correct Usage Cases & Real-World Deployment")
	for i in range(profile.usage_cases.size()):
		var uc_title := str(profile.usage_cases[i].get("title", "Case Study"))
		toc_lines.append("       3.%d  %s" % [i + 1, uc_title])
	toc_lines.append("  4  Cultural Legacy & Archival Significance")
	toc_lines.append("  5  Curatorial Media & Image Archive (System / Hardware / Software)")
	toc_lines.append("  6  Emulated Firmware, BIOS POST & Terminal Command Manifest")

	var toc_lbl := Label.new()
	toc_lbl.text = "\n".join(toc_lines)
	toc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	toc_lbl.add_theme_font_size_override("font_size", 11)
	toc_lbl.add_theme_color_override("font_color", Color("3366cc") if _wiki_light_mode else Color("79c0ff"))
	vbox.add_child(toc_lbl)

	panel.add_child(vbox)
	return panel


func _add_wiki_section_header(heading_text: String) -> void:
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 3)

	var lbl := Label.new()
	lbl.text = heading_text
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lbl.add_theme_font_size_override("font_size", 16)
	lbl.add_theme_color_override("font_color", Color("101418") if _wiki_light_mode else Color("f0f6fc"))
	vbox.add_child(lbl)

	var sep := HSeparator.new()
	vbox.add_child(sep)
	dynamic_sections_vbox.add_child(vbox)


func _create_article_paragraph(body_text: String) -> Label:
	var lbl := Label.new()
	lbl.text = body_text
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lbl.add_theme_font_size_override("font_size", 13)
	lbl.add_theme_color_override("font_color", Color("202122") if _wiki_light_mode else Color("c9d1d9"))
	return lbl


func _create_usage_case_card(index: int, uc: Dictionary) -> PanelContainer:
	var card := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("f8f9fa") if _wiki_light_mode else Color("141d28")
	sb.border_color = Color("3366cc") if _wiki_light_mode else Color("3b82f6")
	sb.border_width_left = 4
	sb.border_width_top = 1
	sb.border_width_right = 1
	sb.border_width_bottom = 1
	sb.set_content_margin_all(10)
	card.add_theme_stylebox_override("panel", sb)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 5)

	var title_lbl := Label.new()
	title_lbl.text = "Case 3.%d: %s" % [index, str(uc.get("title", ""))]
	title_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_lbl.add_theme_font_size_override("font_size", 14)
	title_lbl.add_theme_color_override("font_color", Color("101418") if _wiki_light_mode else Color("f2cc60"))
	vbox.add_child(title_lbl)

	var role_lbl := Label.new()
	role_lbl.text = "👤 Operator / Setting : " + str(uc.get("role", ""))
	role_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	role_lbl.add_theme_font_size_override("font_size", 12)
	role_lbl.add_theme_color_override("font_color", Color("3366cc") if _wiki_light_mode else Color("79c0ff"))
	vbox.add_child(role_lbl)

	var sw_lbl := Label.new()
	sw_lbl.text = "💿 Period Software    : " + str(uc.get("software", ""))
	sw_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sw_lbl.add_theme_font_size_override("font_size", 12)
	sw_lbl.add_theme_color_override("font_color", Color("1f6f43") if _wiki_light_mode else Color("56d364"))
	vbox.add_child(sw_lbl)

	var scen_lbl := Label.new()
	scen_lbl.text = str(uc.get("scenario", ""))
	scen_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	scen_lbl.add_theme_font_size_override("font_size", 12)
	scen_lbl.add_theme_color_override("font_color", Color("202122") if _wiki_light_mode else Color("d0d7de"))
	vbox.add_child(scen_lbl)

	card.add_child(vbox)
	return card


func _create_media_gallery_section(profile: OSProfile) -> VBoxContainer:
	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 8)

	var note_lbl := Label.new()
	note_lbl.text = (
		"Historical photographs, hardware schematics, or AI-generated exhibit plates can be placed in "
		+ "'res://assets/exhibits/%s/' (system.png, hardware.png, software.png) or attached live below:" % profile.id
	)
	note_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note_lbl.add_theme_font_size_override("font_size", 12)
	note_lbl.add_theme_color_override("font_color", Color("54595d") if _wiki_light_mode else Color("8b949e"))
	outer.add_child(note_lbl)

	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 10)
	flow.add_theme_constant_override("v_separation", 10)

	for i in range(profile.exhibit_images.size()):
		var slot_dict: Dictionary = profile.exhibit_images[i]
		var slot_id := str(slot_dict.get("slot_id", "system"))

		var card := PanelContainer.new()
		card.custom_minimum_size = Vector2(250, 0)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color("f8f9fa") if _wiki_light_mode else Color("141b23")
		sb.border_color = Color("c8ccd1") if _wiki_light_mode else Color("2f3d4c")
		sb.set_border_width_all(1)
		sb.set_content_margin_all(8)
		card.add_theme_stylebox_override("panel", sb)

		var cv := VBoxContainer.new()
		cv.add_theme_constant_override("separation", 6)

		var plate := PlateRenderer.new()
		plate.custom_minimum_size = Vector2(234, 138)
		plate.setup_plate(profile, slot_dict)
		cv.add_child(plate)
		_gallery_plate_renderers.append(plate)

		var fig_lbl := Label.new()
		fig_lbl.text = str(slot_dict.get("title", ""))
		fig_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		fig_lbl.add_theme_font_size_override("font_size", 11)
		fig_lbl.add_theme_color_override("font_color", Color("101418") if _wiki_light_mode else Color("f0f6fc"))
		cv.add_child(fig_lbl)

		var cap_lbl := Label.new()
		cap_lbl.text = str(slot_dict.get("caption", ""))
		cap_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		cap_lbl.add_theme_font_size_override("font_size", 11)
		cap_lbl.add_theme_color_override("font_color", Color("54595d") if _wiki_light_mode else Color("8b949e"))
		cv.add_child(cap_lbl)

		var path_lbl := Label.new()
		path_lbl.text = "Slot Path: " + str(slot_dict.get("asset_path", ""))
		path_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		path_lbl.add_theme_font_size_override("font_size", 10)
		path_lbl.add_theme_color_override("font_color", Color("3366cc") if _wiki_light_mode else Color("58a6ff"))
		cv.add_child(path_lbl)

		var btn_row := HBoxContainer.new()
		var focus_btn := Button.new()
		focus_btn.text = "🔍 View in Infobox"
		focus_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		focus_btn.focus_mode = Control.FOCUS_NONE
		focus_btn.add_theme_font_size_override("font_size", 10)
		var slot_index := i
		focus_btn.pressed.connect(func():
			AudioManager.play_hdd_click(0.03)
			_active_plate_slot_idx = slot_index
			_update_infobox_plate()
		)
		btn_row.add_child(focus_btn)

		var imp_btn := Button.new()
		imp_btn.text = "📂 Attach Image..."
		imp_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		imp_btn.focus_mode = Control.FOCUS_NONE
		imp_btn.add_theme_font_size_override("font_size", 10)
		imp_btn.pressed.connect(func():
			_open_image_import_for_slot(slot_id)
		)
		btn_row.add_child(imp_btn)

		cv.add_child(btn_row)
		card.add_child(cv)
		flow.add_child(card)

	outer.add_child(flow)
	return outer


func _create_bios_and_shell_manifest(profile: OSProfile) -> PanelContainer:
	var panel := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("10151c")
	sb.border_color = Color("303e4f")
	sb.set_border_width_all(1)
	sb.set_content_margin_all(10)
	panel.add_theme_stylebox_override("panel", sb)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)

	var bios_lbl := Label.new()
	bios_lbl.text = "📟 Firmware / ROM Header:\n" + profile.bios_header
	bios_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	bios_lbl.add_theme_font_size_override("font_size", 12)
	bios_lbl.add_theme_color_override("font_color", Color("80ed99"))
	vbox.add_child(bios_lbl)

	var cmd_keys := PackedStringArray()
	for k in profile.terminal_commands.keys():
		cmd_keys.append(str(k))

	var cmd_lbl := Label.new()
	cmd_lbl.text = (
		"⌨️ Interactive Shell (%s) — Supported Exhibit Commands:\n" % profile.terminal_title
		+ "   • OS-Specific : " + ", ".join(cmd_keys) + "\n"
		+ "   • Universal   : help, neofetch, clear, date, whoami, floppy, cdrom, reboot, exit\n"
		+ "   • Boot Sequence Stages : %d period-authentic POST & kernel log events" % profile.boot_logs.size()
	)
	cmd_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cmd_lbl.add_theme_font_size_override("font_size", 12)
	cmd_lbl.add_theme_color_override("font_color", Color("c9d1d9"))
	vbox.add_child(cmd_lbl)

	var inline_boot_btn := Button.new()
	inline_boot_btn.text = "⚡ LAUNCH EMULATION & BOOT %s [ENTER]" % profile.short_name.to_upper()
	inline_boot_btn.custom_minimum_size = Vector2(0, 42)
	inline_boot_btn.focus_mode = Control.FOCUS_NONE
	inline_boot_btn.pressed.connect(_on_boot_pressed)
	_style_boot_button(inline_boot_btn, false)
	vbox.add_child(inline_boot_btn)

	panel.add_child(vbox)
	return panel


func _style_boot_button(btn: Button, compact: bool = false) -> void:
	var normal_sb := StyleBoxFlat.new()
	normal_sb.bg_color = Color("155e39") if not _wiki_light_mode else Color("1b5e20")
	normal_sb.border_color = Color("38b000") if not _wiki_light_mode else Color("2e7d32")
	normal_sb.set_border_width_all(2)
	normal_sb.set_corner_radius_all(4)
	normal_sb.set_content_margin_all(6 if compact else 8)

	var hover_sb := StyleBoxFlat.new()
	hover_sb.bg_color = Color("1e7e4c") if not _wiki_light_mode else Color("2e7d32")
	hover_sb.border_color = Color("70e000") if not _wiki_light_mode else Color("4caf50")
	hover_sb.set_border_width_all(2)
	hover_sb.set_corner_radius_all(4)
	hover_sb.set_content_margin_all(6 if compact else 8)

	var pressed_sb := StyleBoxFlat.new()
	pressed_sb.bg_color = Color("0d3d24")
	pressed_sb.border_color = Color("238636")
	pressed_sb.set_border_width_all(2)
	pressed_sb.set_corner_radius_all(4)
	pressed_sb.set_content_margin_all(6 if compact else 8)

	btn.add_theme_stylebox_override("normal", normal_sb)
	btn.add_theme_stylebox_override("hover", hover_sb)
	btn.add_theme_stylebox_override("pressed", pressed_sb)
	btn.add_theme_color_override("font_color", Color("ffffff"))
	btn.add_theme_color_override("font_hover_color", Color("d1fae5"))
	btn.add_theme_color_override("font_pressed_color", Color("a7f3d0"))


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
