class_name RetroOSExhibitCodex
extends RefCounted
## Central coordinator for RetroOS Museum Exhibit & Codex Packages.
## Populates historical context, engineering innovations, period usage cases,
## structured Wikipedia-style Infobox specifications, and image gallery slots
## for all built-in and custom OSProfile resources.

const OSProfile = preload("res://data/os_profile.gd")
const CodexModern = preload("res://data/exhibit_codex_modern.gd")
const CodexClassic = preload("res://data/exhibit_codex_classic.gd")


static func enrich_profile(p: OSProfile) -> void:
	if CodexModern.populate(p):
		return
	if CodexClassic.populate(p):
		return

	# Fallback generator for any future custom .tres profile dropped into res://data/profiles/
	if p.exhibit_subtitle.is_empty():
		p.exhibit_subtitle = "%s (%s) — %s" % [p.display_name, p.release_year, p.vendor]
	if p.era_classification.is_empty():
		p.era_classification = "%s Computing Era (%s)" % [p.category, p.release_year]
	if p.historical_overview.is_empty():
		p.historical_overview = p.description
	if p.historical_context.is_empty():
		p.historical_context = (
			"%s was developed by %s and released in %s. " % [p.display_name, p.vendor, p.release_year]
			+ "It operated on %s hardware with the %s architecture." % [p.hardware_profile, p.architecture_summary]
		)
	if p.engineering_innovations.is_empty():
		p.engineering_innovations = (
			"• System Architecture: %s\n" % p.architecture_summary
			+ "• Hardware Platform: %s\n" % p.hardware_profile
			+ "• Interactive Shell: %s (%s)" % [p.terminal_title, p.terminal_prompt.strip_edges()]
		)
	if p.cultural_legacy.is_empty():
		p.cultural_legacy = (
			"Preserved in the RetroOS Digital Computing Codex as a representative system of the %s era." % p.release_year
		)
	if p.technical_specs.is_empty():
		p.technical_specs = {
			"Manufacturer / Vendor": p.vendor,
			"Release Date": p.release_year,
			"System Model": p.hardware_profile,
			"Architecture": p.architecture_summary,
			"Operating System": p.display_name,
			"Window Chrome": p.chrome_style,
			"Default Shell": p.terminal_title + " (" + p.terminal_prompt.strip_edges() + ")"
		}
	if p.usage_cases.is_empty():
		p.usage_cases = [
			{
				"title": "Standard Workstation & Interactive Shell Operation (%s)" % p.release_year,
				"role": "System Operator & Administrator",
				"software": p.terminal_title,
				"scenario": p.description
			}
		]
	if p.exhibit_images.is_empty():
		p.exhibit_images = [
			{
				"slot_id": "system",
				"title": "Fig 1. %s Workstation & Display" % p.short_name,
				"caption": p.hardware_profile,
				"asset_path": "res://assets/exhibits/%s/system.png" % p.id,
				"plate_type": "chassis"
			},
			{
				"slot_id": "hardware",
				"title": "Fig 2. %s Internal Architecture" % p.short_name,
				"caption": p.architecture_summary,
				"asset_path": "res://assets/exhibits/%s/hardware.png" % p.id,
				"plate_type": "motherboard"
			},
			{
				"slot_id": "software",
				"title": "Fig 3. %s Desktop & Shell Environment" % p.short_name,
				"caption": p.display_name,
				"asset_path": "res://assets/exhibits/%s/software.png" % p.id,
				"plate_type": "software_ui"
			}
		]


## Resolves a custom historical or generated image texture for a given OS profile and slot_id
## ("system", "hardware", "software"). Checks both `user://exhibits/<os_id>/` (runtime imported)
## and `res://assets/exhibits/<os_id>/` for `.png`, `.jpg`, `.jpeg`, or `.webp` files.
static func load_exhibit_texture(os_id: String, slot_id: String, explicit_path: String = "") -> Texture2D:
	var candidate_paths: Array[String] = []
	var extensions: Array[String] = ["png", "jpg", "jpeg", "webp"]

	for ext in extensions:
		candidate_paths.append("user://exhibits/%s/%s.%s" % [os_id, slot_id, ext])
	if not explicit_path.is_empty():
		candidate_paths.append(explicit_path)
	for ext in extensions:
		candidate_paths.append("res://assets/exhibits/%s/%s.%s" % [os_id, slot_id, ext])

	for path in candidate_paths:
		if path.begins_with("res://") and ResourceLoader.exists(path):
			var tex := ResourceLoader.load(path)
			if tex is Texture2D:
				return tex
		if FileAccess.file_exists(path):
			var img := Image.new()
			var err := img.load(ProjectSettings.globalize_path(path))
			if err == OK and not img.is_empty():
				return ImageTexture.create_from_image(img)
	return null


## Copies/imports an external image file from disk into `res://assets/exhibits/<os_id>/<slot_id>.png`
## (and `user://exhibits/<os_id>/<slot_id>.png`) so users or archivists can attach historical or
## AI-generated images directly from the Codex UI.
static func import_exhibit_image_from_file(os_id: String, slot_id: String, source_global_path: String) -> Texture2D:
	var img := Image.new()
	var err := img.load(source_global_path)
	if err != OK or img.is_empty():
		return null

	# In editor builds, persist to the project res:// tree for version control
	if OS.has_feature("editor"):
		var rel_dir := "res://assets/exhibits/%s" % os_id
		var abs_dir := ProjectSettings.globalize_path(rel_dir)
		DirAccess.make_dir_recursive_absolute(abs_dir)
		var dest_path := abs_dir.path_join("%s.png" % slot_id)
		img.save_png(dest_path)

	# In all environments, persist to writable user:// directory
	var user_dir := ProjectSettings.globalize_path("user://exhibits/%s" % os_id)
	DirAccess.make_dir_recursive_absolute(user_dir)
	var user_dest := user_dir.path_join("%s.png" % slot_id)
	var save_err := img.save_png(user_dest)
	if save_err != OK:
		push_warning("Failed to save exhibit image to: %s" % user_dest)

	return ImageTexture.create_from_image(img)

