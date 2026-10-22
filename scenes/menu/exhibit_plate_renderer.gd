class_name ExhibitPlateRenderer
extends Control
## Renders either an imported/external historical/generated image (`Texture2D`) for a given
## OS exhibit slot, OR a bespoke procedural Museum Archival Vector Plate (`chassis`,
## `motherboard`, or `software_ui`) when no external image file is present on disk.

const OSProfile = preload("res://data/os_profile.gd")
const ExhibitCodex = preload("res://data/exhibit_codex.gd")

var _profile: OSProfile
var _slot_id: String = "system"
var _plate_type: String = "chassis"
var _asset_path: String = ""
var _external_texture: Texture2D = null


func setup_plate(profile: OSProfile, slot_dict: Dictionary) -> void:
	_profile = profile
	_slot_id = str(slot_dict.get("slot_id", "system"))
	_plate_type = str(slot_dict.get("plate_type", "chassis"))
	_asset_path = str(slot_dict.get("asset_path", ""))
	refresh_texture()


func refresh_texture() -> void:
	if _profile:
		_external_texture = ExhibitCodex.load_exhibit_texture(_profile.id, _slot_id, _asset_path)
	else:
		_external_texture = null
	queue_redraw()


func has_external_image() -> bool:
	return _external_texture != null


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	if rect.size.x < 10 or rect.size.y < 10:
		return

	# If an external historical or generated image exists in res://assets/exhibits/<id>/, render it
	if _external_texture != null:
		draw_rect(rect, Color("0d1117"), true)
		var tex_size := _external_texture.get_size()
		if tex_size.x > 0 and tex_size.y > 0:
			var scale_x := (rect.size.x - 8.0) / tex_size.x
			var scale_y := (rect.size.y - 8.0) / tex_size.y
			var sc := minf(scale_x, scale_y)
			var draw_sz := tex_size * sc
			var draw_pos := (rect.size - draw_sz) * 0.5
			draw_texture_rect(_external_texture, Rect2(draw_pos, draw_sz), false)
		draw_rect(rect, Color("3b4c5e"), false, 1.5)
		_draw_plate_badge("CUSTOM ARCHIVAL IMAGE", Color("2ea043"))
		return

	if _profile == null:
		draw_rect(rect, Color("10151c"), true)
		return

	match _plate_type:
		"chassis":
			_draw_chassis_plate(rect)
		"motherboard":
			_draw_motherboard_plate(rect)
		"software_ui":
			_draw_software_plate(rect)
		_:
			_draw_chassis_plate(rect)


func _draw_chassis_plate(rect: Rect2) -> void:
	# Technical blueprint background with subtle engineering grid
	draw_rect(rect, Color("0d1622"), true)
	_draw_blueprint_grid(rect, Color(0.18, 0.32, 0.48, 0.22), 18.0)

	var cx := rect.size.x * 0.5
	var cy := rect.size.y * 0.54
	var os_id := _profile.id
	var font := ThemeDB.fallback_font

	# Monitor (left/center) + System Unit (right or underneath depending on form factor)
	var is_horizontal_desktop := os_id in ["os2_warp", "amiga_os31", "nextstep_33", "apple_iie"]

	if is_horizontal_desktop:
		# Horizontal desktop / pizza-box / Apple IIe under the CRT monitor
		var base_rect := Rect2(cx - 95, cy + 20, 190, 38)
		var base_col := Color("d8d2c5")
		if os_id == "nextstep_33":
			base_col = Color("1e1e22")
			base_rect = Rect2(cx - 100, cy + 24, 200, 26)
		elif os_id == "apple_iie":
			base_col = Color("d5ceb8")
			base_rect = Rect2(cx - 105, cy + 16, 150, 42)

		draw_rect(base_rect, base_col, true)
		draw_rect(base_rect, base_col.lightened(0.25), false, 1.5)

		# Drive bays / details on horizontal chassis
		if os_id == "nextstep_33":
			# NeXTstation black slab + rainbow logo
			draw_rect(Rect2(base_rect.position.x + 135, base_rect.position.y + 8, 48, 5), Color("0a0a0c"), true)
			draw_rect(Rect2(base_rect.position.x + 16, base_rect.position.y + 7, 12, 12), Color("e03c28"), true)
			draw_rect(Rect2(base_rect.position.x + 22, base_rect.position.y + 7, 6, 6), Color("45b848"), true)
		elif os_id == "apple_iie":
			# Apple //e keyboard stripes + DuoDisk on right
			draw_rect(Rect2(base_rect.position.x + 12, base_rect.position.y + 22, 126, 15), Color("38342c"), true)
			var disk_rect := Rect2(base_rect.end.x + 6, cy + 14, 58, 44)
			draw_rect(disk_rect, Color("cfc7b0"), true)
			draw_rect(disk_rect, Color("8a8270"), false, 1.5)
			draw_rect(Rect2(disk_rect.position.x + 8, disk_rect.position.y + 10, 42, 6), Color("222222"), true)
			draw_rect(Rect2(disk_rect.position.x + 8, disk_rect.position.y + 28, 42, 6), Color("222222"), true)
			draw_rect(Rect2(disk_rect.position.x + 4, disk_rect.position.y + 11, 3, 3), Color("ef233c"), true)
		else:
			# Amiga 3000 / IBM 300PL drive slots
			draw_rect(Rect2(base_rect.position.x + 125, base_rect.position.y + 10, 50, 7), Color("4a4a4a"), true)
			draw_rect(Rect2(base_rect.position.x + 14, base_rect.position.y + 10, 28, 8), _profile.accent_color, true)

		# CRT Monitor resting above horizontal unit
		var mon_rect := Rect2(cx - 72, cy - 68, 144, 84)
		var mon_col := Color("222226") if os_id == "nextstep_33" else Color("dfd9cc")
		draw_rect(mon_rect, mon_col, true)
		draw_rect(mon_rect, mon_col.lightened(0.2), false, 1.5)
		var scr_rect := mon_rect.grow(-9)
		var scr_col := Color("071f0c") if os_id == "apple_iie" else _profile.desktop_bg_color
		draw_rect(scr_rect, scr_col, true)
		# Mini window inside monitor
		draw_rect(Rect2(scr_rect.position.x + 12, scr_rect.position.y + 10, 78, 44), _profile.window_bg_color, true)
		draw_rect(Rect2(scr_rect.position.x + 12, scr_rect.position.y + 10, 78, 9), _profile.titlebar_active_color, true)
	else:
		# Monitor on Left + Tower / Deskside Workstation on Right
		var mon_rect := Rect2(cx - 122, cy - 48, 132, 92)
		var mon_bezel := Color("d8d4c8")
		if os_id in ["ubuntu_704", "winxp_alienware"]:
			mon_bezel = Color("2b3036")
		elif os_id == "macosx_g4":
			mon_bezel = Color("7c858e")
		draw_rect(mon_rect, mon_bezel, true)
		draw_rect(mon_rect, mon_bezel.lightened(0.25), false, 1.5)
		# Monitor Stand
		draw_rect(Rect2(mon_rect.position.x + 46, mon_rect.end.y, 40, 12), mon_bezel.darkened(0.2), true)
		draw_rect(Rect2(mon_rect.position.x + 28, mon_rect.end.y + 10, 76, 6), mon_bezel.darkened(0.3), true)

		# Screen contents
		var scr := mon_rect.grow(-8)
		draw_rect(scr, _profile.desktop_bg_color, true)
		draw_rect(Rect2(scr.position.x + 10, scr.position.y + 10, 72, 46), _profile.window_bg_color, true)
		draw_rect(Rect2(scr.position.x + 10, scr.position.y + 10, 72, 9), _profile.titlebar_active_color, true)

		# Tower Chassis on Right
		var tw_rect := Rect2(cx + 26, cy - 66, 78, 124)
		var tw_col := Color("d6d1c4")
		if os_id == "sgi_irix":
			tw_col = Color("264b78") # SGI Octane2 Blue Skins
		elif os_id == "winxp_alienware":
			tw_col = Color("1f3a2e") # Alienware Predator Cyborg Green/Dark
		elif os_id == "macosx_g4":
			tw_col = Color("636b73") # Power Mac G4 Graphite/Silver
		elif os_id == "hpux_cde":
			tw_col = Color("343a40") # HP Visualize Dark Quartz
		elif os_id == "solaris_8":
			tw_col = Color("cfc9be") # Sun Ultra 60 with Purple Accent
		elif os_id == "ubuntu_704":
			tw_col = Color("3a3f45") # Dell OptiPlex BTX Charcoal

		draw_rect(tw_rect, tw_col, true)
		draw_rect(tw_rect, tw_col.lightened(0.3), false, 1.5)

		# System-specific industrial design accents on the tower
		if os_id == "sgi_irix":
			# SGI Octane2 front X-facets & light bar
			draw_line(tw_rect.position + Vector2(8, 12), tw_rect.end - Vector2(8, 12), Color("4ea8de"), 2.5)
			draw_line(Vector2(tw_rect.end.x - 8, tw_rect.position.y + 12), Vector2(tw_rect.position.x + 8, tw_rect.end.y - 12), Color("4ea8de"), 2.5)
			draw_rect(Rect2(tw_rect.position.x + 14, tw_rect.position.y + 8, 50, 5), Color("80ed99"), true)
		elif os_id == "winxp_alienware":
			# Alienware Predator grills & glowing alien badge
			for g in range(5):
				draw_rect(Rect2(tw_rect.position.x + 12, tw_rect.position.y + 58 + g * 10, 54, 4), Color("0b130e"), true)
			draw_circle(tw_rect.position + Vector2(39, 30), 8.0, Color("52b788"))
		elif os_id == "macosx_g4":
			# Power Mac G4 top/bottom handles & circular badge
			draw_rect(Rect2(tw_rect.position.x - 4, tw_rect.position.y - 8, 86, 8), Color("adb5bd"), false, 2.0)
			draw_rect(Rect2(tw_rect.position.x - 4, tw_rect.end.y, 86, 8), Color("adb5bd"), false, 2.0)
			draw_circle(tw_rect.position + Vector2(39, 64), 12.0, Color("adb5bd"))
		elif os_id == "solaris_8":
			# Sun Ultra 60 purple wave panel
			draw_rect(Rect2(tw_rect.position.x + 6, tw_rect.position.y + 10, 26, 104), Color("5a4478"), true)
		else:
			# Optical & 3.5" bays + power LED
			draw_rect(Rect2(tw_rect.position.x + 10, tw_rect.position.y + 14, 58, 12), tw_col.darkened(0.28), true)
			draw_rect(Rect2(tw_rect.position.x + 10, tw_rect.position.y + 30, 58, 12), tw_col.darkened(0.28), true)
			draw_rect(Rect2(tw_rect.position.x + 16, tw_rect.position.y + 48, 38, 7), tw_col.darkened(0.35), true)
			draw_circle(tw_rect.position + Vector2(20, 74), 3.5, Color("38b000"))

	# Dimension callout line at bottom
	draw_string(
		font,
		Vector2(10, rect.size.y - 8),
		"EXHIBIT PLATE I // %s (%s)" % [_profile.short_name.to_upper(), _profile.release_year],
		HORIZONTAL_ALIGNMENT_LEFT,
		rect.size.x - 20,
		10,
		Color("8ecae6")
	)
	draw_rect(rect, Color("2b4560"), false, 1.5)
	_draw_plate_badge("ARCHIVAL VECTOR PLATE", Color("3a86ff"))


func _draw_motherboard_plate(rect: Rect2) -> void:
	# PCB Substrate & Schematic view
	draw_rect(rect, Color("0b1f17"), true)
	_draw_blueprint_grid(rect, Color(0.15, 0.45, 0.30, 0.20), 14.0)

	var pcb := rect.grow(-18)
	pcb.position.y += 6
	pcb.size.y -= 12
	draw_rect(pcb, Color("133829"), true)
	draw_rect(pcb, Color("2d6a4f"), false, 1.5)

	var font := ThemeDB.fallback_font
	var os_id := _profile.id
	var is_dual_cpu := os_id in ["sgi_irix", "freebsd_411", "beos_r5", "redhat_62", "solaris_8", "sco_openserver"]

	# Draw CPU socket(s)
	if is_dual_cpu:
		for idx in range(2):
			var cpu_r := Rect2(pcb.position.x + 16 + idx * 62, pcb.position.y + 14, 52, 52)
			draw_rect(cpu_r, Color("4a3b69") if os_id == "solaris_8" else Color("2b2d42"), true)
			draw_rect(cpu_r, Color("e0a96d"), false, 1.5)
			draw_rect(cpu_r.grow(-10), Color("8d99ae"), true)
			draw_string(font, cpu_r.position + Vector2(6, 30), "CPU %d" % idx, HORIZONTAL_ALIGNMENT_LEFT, 44, 9, Color("111111"))
	else:
		var cpu_r := Rect2(pcb.position.x + 22, pcb.position.y + 14, 62, 56)
		draw_rect(cpu_r, Color("2b2d42"), true)
		draw_rect(cpu_r, Color("e0a96d"), false, 2.0)
		draw_rect(cpu_r.grow(-11), Color("adb5bd"), true)
		draw_string(font, cpu_r.position + Vector2(10, 32), "CPU/FPU", HORIZONTAL_ALIGNMENT_LEFT, 48, 9, Color("111111"))

	# Co-processor / Northbridge / Crossbar ASIC
	var asic_r := Rect2(pcb.position.x + 145, pcb.position.y + 20, 48, 42)
	draw_rect(asic_r, Color("1b263b"), true)
	draw_rect(asic_r, Color("74c69d"), false, 1.2)
	draw_string(font, asic_r.position + Vector2(5, 25), "CHIPSET", HORIZONTAL_ALIGNMENT_LEFT, 42, 8, Color("95d5b2"))

	# RAM DIMM/SIMM Slots on the right
	for r_idx in range(4):
		var dimm := Rect2(pcb.end.x - 74, pcb.position.y + 14 + r_idx * 13, 60, 8)
		draw_rect(dimm, Color("081c15"), true)
		draw_rect(dimm, Color("52b788"), false, 1.0)

	# Expansion Bus Slots (PCI / NuBus / Zorro / SGI XIO / Apple II Slots)
	for s_idx in range(3):
		var slot_r := Rect2(pcb.position.x + 18, pcb.end.y - 42 + s_idx * 11, 130, 6)
		draw_rect(slot_r, Color("d8d4c8") if s_idx < 2 else Color("212529"), true)

	# Copper bus traces connecting CPU -> ASIC -> RAM
	draw_line(Vector2(pcb.position.x + 84, pcb.position.y + 40), Vector2(asic_r.position.x, pcb.position.y + 40), Color("f4a261"), 2.0)
	draw_line(Vector2(asic_r.end.x, pcb.position.y + 38), Vector2(pcb.end.x - 74, pcb.position.y + 38), Color("f4a261"), 2.0)

	draw_string(
		font,
		Vector2(10, rect.size.y - 8),
		"EXHIBIT PLATE II // %s" % _profile.architecture_summary.left(42),
		HORIZONTAL_ALIGNMENT_LEFT,
		rect.size.x - 20,
		10,
		Color("95d5b2")
	)
	draw_rect(rect, Color("2d6a4f"), false, 1.5)
	_draw_plate_badge("ARCHITECTURE SCHEMATIC", Color("2d6a4f"))


func _draw_software_plate(rect: Rect2) -> void:
	# Simulated live CRT frame of the operating system's desktop & terminal
	draw_rect(rect, _profile.desktop_bg_color, true)

	# Secondary gradient/accent band
	draw_rect(Rect2(0, rect.size.y * 0.65, rect.size.x, rect.size.y * 0.35), Color(_profile.desktop_secondary_color, 0.45), true)

	# Top or Bottom OS Panel bar
	if _profile.chrome_style in ["gnome_human", "os2_pmshell", "mac_classic", "macosx_aqua", "amiga_workbench", "redhat_e16", "beos_yellowtab"]:
		draw_rect(Rect2(0, 0, rect.size.x, 16), _profile.panel_bg_color, true)
	if _profile.chrome_style in ["win98_classic", "winxp_luna", "motif_cde", "solaris_cde", "gnome_human", "macosx_aqua", "sco_panorama"]:
		draw_rect(Rect2(0, rect.size.y - 20, rect.size.x, 20), _profile.panel_bg_color, true)

	# Mock Primary Application Window
	var w1 := Rect2(20, 26, rect.size.x * 0.56, rect.size.y * 0.54)
	draw_rect(w1, _profile.window_bg_color, true)
	draw_rect(w1, _profile.window_border_color, false, 1.5)
	var tb_w := w1.size.x * 0.55 if _profile.chrome_style == "beos_yellowtab" else w1.size.x
	draw_rect(Rect2(w1.position, Vector2(tb_w, 14)), _profile.titlebar_active_color, true)

	# Mock Terminal Window overlapping bottom-right
	var w2 := Rect2(rect.size.x * 0.32, rect.size.y * 0.34, rect.size.x * 0.60, rect.size.y * 0.50)
	draw_rect(w2, _profile.terminal_bg_color, true)
	draw_rect(w2, _profile.window_border_color, false, 1.5)
	draw_rect(Rect2(w2.position, Vector2(w2.size.x, 14)), _profile.titlebar_active_color, true)

	var font := ThemeDB.fallback_font
	draw_string(
		font,
		w2.position + Vector2(6, 28),
		_profile.terminal_prompt.strip_edges() + " uname -a",
		HORIZONTAL_ALIGNMENT_LEFT,
		w2.size.x - 12,
		10,
		_profile.terminal_fg_color
	)
	draw_string(
		font,
		w2.position + Vector2(6, 42),
		_profile.short_name + " (" + _profile.release_year + ") Ready.",
		HORIZONTAL_ALIGNMENT_LEFT,
		w2.size.x - 12,
		10,
		_profile.terminal_fg_color
	)

	draw_rect(rect, Color("4ea8de"), false, 1.5)
	_draw_plate_badge("UI & SHELL ENVIRONMENT", Color("7209b7"))


func _draw_blueprint_grid(rect: Rect2, col: Color, step: float) -> void:
	var x := step
	while x < rect.size.x:
		draw_line(Vector2(x, 0), Vector2(x, rect.size.y), col, 1.0)
		x += step
	var y := step
	while y < rect.size.y:
		draw_line(Vector2(0, y), Vector2(rect.size.x, y), col, 1.0)
		y += step


func _draw_plate_badge(label_text: String, bg_col: Color) -> void:
	var font := ThemeDB.fallback_font
	var badge_w := float(label_text.length() * 6 + 14)
	var badge_rect := Rect2(size.x - badge_w - 6, 6, badge_w, 16)
	draw_rect(badge_rect, Color(bg_col, 0.88), true)
	draw_string(font, badge_rect.position + Vector2(6, 12), label_text, HORIZONTAL_ALIGNMENT_LEFT, badge_w - 8, 9, Color.WHITE)

