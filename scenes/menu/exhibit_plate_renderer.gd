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

	if os_id == "datapoint_2200":
		_draw_datapoint_chassis(rect, cx, cy, font)
		_draw_plate_footer(rect, font, "EXHIBIT PLATE I // DATAPOINT 2200 (1972)", Color("8ecae6"), Color("2b4560"), "ARCHIVAL VECTOR PLATE", Color("3a86ff"))
		return

	if os_id == "ubuntu_1004":
		_draw_alexnet_chassis(rect, cx, cy, font)
		_draw_plate_footer(rect, font, "EXHIBIT PLATE I // ALEXNET DUAL-GTX 580 WORKSTATION (2012)", Color("ffaa5e"), Color("77216f"), "AI ZERO-POINT RIG", Color("dd4814"))
		return

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

	if os_id == "datapoint_2200":
		_draw_datapoint_motherboard(rect, pcb, font)
		return

	if os_id == "ubuntu_1004":
		_draw_alexnet_motherboard(rect, pcb, font)
		return

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
	if _profile.id == "datapoint_2200":
		_draw_datapoint_software_plate(rect, ThemeDB.fallback_font)
		return

	if _profile.id == "ubuntu_1004":
		_draw_ubuntu_1004_software_plate(rect, ThemeDB.fallback_font)
		return

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


func _draw_plate_footer(
	rect: Rect2,
	font: Font,
	caption_text: String,
	text_col: Color,
	border_col: Color,
	badge_label: String,
	badge_col: Color
) -> void:
	draw_string(
		font,
		Vector2(10, rect.size.y - 8),
		caption_text,
		HORIZONTAL_ALIGNMENT_LEFT,
		rect.size.x - 20,
		10,
		text_col
	)
	draw_rect(rect, border_col, false, 1.5)
	_draw_plate_badge(badge_label, badge_col)


func _draw_datapoint_chassis(rect: Rect2, cx: float, cy: float, font: Font) -> void:
	# Main All-in-One Console in IBM Selectric Typewriter Footprint
	var base_rect := Rect2(cx - 120, cy - 20, 168, 76)
	var base_col := Color("d4cdbe")
	draw_rect(base_rect, base_col, true)
	draw_rect(base_rect, Color("5c5344"), false, 1.5)

	# Sloped keyboard section in front
	var kb_rect := Rect2(cx - 116, cy + 18, 160, 34)
	draw_rect(kb_rect, Color("29241f"), true)
	draw_rect(kb_rect, Color("4d4439"), false, 1.0)

	# Individual keycaps
	var key_col := Color("ded9cd")
	for r in range(3):
		for c in range(13):
			var k_pos := Vector2(kb_rect.position.x + 8 + c * 9, kb_rect.position.y + 5 + r * 7)
			draw_rect(Rect2(k_pos, Vector2(7, 5)), key_col, true)
	# Space bar
	draw_rect(Rect2(kb_rect.position.x + 36, kb_rect.position.y + 26, 68, 5), key_col, true)
	# Numeric keypad block on right
	for nr in range(3):
		for nc in range(3):
			var nk_pos := Vector2(kb_rect.position.x + 130 + nc * 8, kb_rect.position.y + 5 + nr * 7)
			draw_rect(Rect2(nk_pos, Vector2(6, 5)), Color("c4bcae"), true)

	# Integrated 7-inch Curved Green CRT Display
	var crt_bezel := Rect2(cx - 114, cy - 64, 104, 72)
	draw_rect(crt_bezel, Color("26221d"), true)
	draw_rect(crt_bezel, Color("4a4237"), false, 1.5)
	var crt_scr := crt_bezel.grow(-7)
	draw_rect(crt_scr, Color("041007"), true)
	draw_rect(crt_scr, Color("1f4a24"), false, 1.0)

	# 12-line mode green phosphor text lines
	var p31_col := Color("33ff55")
	draw_string(font, crt_scr.position + Vector2(4, 11), "DATAPOINT 2200 ROM", HORIZONTAL_ALIGNMENT_LEFT, crt_scr.size.x - 8, 7, p31_col)
	draw_string(font, crt_scr.position + Vector2(4, 21), "DATAPOINT DOS 2.1", HORIZONTAL_ALIGNMENT_LEFT, crt_scr.size.x - 8, 7, p31_col)
	draw_string(font, crt_scr.position + Vector2(4, 31), "DATE: 10/22/72", HORIZONTAL_ALIGNMENT_LEFT, crt_scr.size.x - 8, 7, Color("80ff80"))
	draw_string(font, crt_scr.position + Vector2(4, 43), ": CATALOG", HORIZONTAL_ALIGNMENT_LEFT, crt_scr.size.x - 8, 7, p31_col)
	draw_string(font, crt_scr.position + Vector2(4, 53), ": _", HORIZONTAL_ALIGNMENT_LEFT, crt_scr.size.x - 8, 7, p31_col)

	# Twin Built-in Philips Digital Cassette Decks (Drive A & Drive B)
	var tape_bay := Rect2(cx - 4, cy - 62, 48, 52)
	draw_rect(tape_bay, Color("1c1916"), true)
	draw_rect(tape_bay, Color("3a342d"), false, 1.0)
	# Drive A (top cassette)
	draw_rect(Rect2(tape_bay.position.x + 4, tape_bay.position.y + 4, 40, 18), Color("2d2823"), true)
	draw_circle(Vector2(tape_bay.position.x + 14, tape_bay.position.y + 13), 5.0, Color("dcdcdc"))
	draw_circle(Vector2(tape_bay.position.x + 14, tape_bay.position.y + 13), 2.0, Color("111111"))
	draw_circle(Vector2(tape_bay.position.x + 34, tape_bay.position.y + 13), 5.0, Color("dcdcdc"))
	draw_circle(Vector2(tape_bay.position.x + 34, tape_bay.position.y + 13), 2.0, Color("111111"))
	# Drive B (bottom cassette)
	draw_rect(Rect2(tape_bay.position.x + 4, tape_bay.position.y + 26, 40, 18), Color("2d2823"), true)
	draw_circle(Vector2(tape_bay.position.x + 14, tape_bay.position.y + 35), 5.0, Color("dcdcdc"))
	draw_circle(Vector2(tape_bay.position.x + 14, tape_bay.position.y + 35), 2.0, Color("111111"))
	draw_circle(Vector2(tape_bay.position.x + 34, tape_bay.position.y + 35), 5.0, Color("dcdcdc"))
	draw_circle(Vector2(tape_bay.position.x + 34, tape_bay.position.y + 35), 2.0, Color("111111"))
	# Cassette Transport Buttons
	draw_rect(Rect2(tape_bay.position.x + 4, tape_bay.position.y + 46, 11, 4), Color("e0e0e0"), true)
	draw_rect(Rect2(tape_bay.position.x + 18, tape_bay.position.y + 46, 11, 4), Color("e0e0e0"), true)
	draw_rect(Rect2(tape_bay.position.x + 32, tape_bay.position.y + 46, 11, 4), Color("e0e0e0"), true)

	# Datapoint Logo Badge
	draw_rect(Rect2(cx - 4, cy - 8, 48, 9), Color("151515"), true)
	draw_string(font, Vector2(cx - 2, cy - 1), "DATAPOINT", HORIZONTAL_ALIGNMENT_CENTER, 46, 7, Color("e0a96d"))

	# External Diablo Series 30 2.5MB Cartridge Hard Disk Unit (Right)
	var diablo_rect := Rect2(cx + 56, cy - 54, 68, 110)
	draw_rect(diablo_rect, Color("c2bcac"), true)
	draw_rect(diablo_rect, Color("584e40"), false, 1.5)
	# Top-loading cartridge access hatch & latch
	draw_rect(Rect2(diablo_rect.position.x + 6, diablo_rect.position.y + 6, 56, 26), Color("2a2520"), true)
	draw_rect(Rect2(diablo_rect.position.x + 18, diablo_rect.position.y + 16, 32, 6), Color("dcdcdc"), true)
	# Ventilation louvers
	for l in range(4):
		draw_rect(Rect2(diablo_rect.position.x + 8, diablo_rect.position.y + 42 + l * 8, 52, 4), Color("1a1714"), true)
	# Status indicator lamps
	draw_circle(Vector2(diablo_rect.position.x + 16, diablo_rect.position.y + 84), 3.0, Color("38b000")) # READY
	draw_circle(Vector2(diablo_rect.position.x + 34, diablo_rect.position.y + 84), 3.0, Color("d90429")) # READ/WRITE
	draw_circle(Vector2(diablo_rect.position.x + 52, diablo_rect.position.y + 84), 3.0, Color("fca311")) # FAULT
	draw_string(font, Vector2(diablo_rect.position.x + 4, diablo_rect.position.y + 102), "DIABLO 2.5MB", HORIZONTAL_ALIGNMENT_CENTER, 60, 7, Color("222222"))


func _draw_datapoint_motherboard(rect: Rect2, pcb: Rect2, font: Font) -> void:
	# Discrete MSI TTL Circuit Board (~100 7400-series ICs)
	draw_rect(rect, Color("0a1e12"), true)
	_draw_blueprint_grid(rect, Color(0.16, 0.44, 0.28, 0.22), 14.0)

	draw_rect(pcb, Color("142c19"), true)
	draw_rect(pcb, Color("2d6a4f"), false, 1.5)

	# 4 Rows of 6 DIP ICs representing discrete MSI processor logic
	for row in range(4):
		var y_pos := pcb.position.y + 12 + row * 22
		for col in range(6):
			var x_pos := pcb.position.x + 14 + col * 32
			var ic_rect := Rect2(x_pos, y_pos, 22, 14)
			# Solder pins on both sides
			for pin in range(4):
				var px := x_pos + 2 + pin * 5
				draw_line(Vector2(px, y_pos - 3), Vector2(px, y_pos), Color("cccccc"), 1.0)
				draw_line(Vector2(px, y_pos + 14), Vector2(px, y_pos + 17), Color("cccccc"), 1.0)
			# Black ceramic IC body
			draw_rect(ic_rect, Color("1a1a1a"), true)
			draw_rect(ic_rect, Color("333333"), false, 0.8)
			# IC notch & label
			draw_circle(Vector2(x_pos + 2, y_pos + 7), 1.5, Color("444444"))

	# Recirculating MOS Shift Registers / Intel 1101/1103 DRAM Bank (Right Side)
	var mem_bay := Rect2(pcb.end.x - 72, pcb.position.y + 10, 58, 88)
	draw_rect(mem_bay, Color("0f2014"), true)
	draw_rect(mem_bay, Color("52b788"), false, 1.0)
	draw_string(font, Vector2(mem_bay.position.x + 4, mem_bay.position.y + 12), "16KB RAM", HORIZONTAL_ALIGNMENT_LEFT, 50, 8, Color("95d5b2"))
	for m in range(4):
		draw_rect(Rect2(mem_bay.position.x + 6, mem_bay.position.y + 18 + m * 16, 46, 10), Color("2b2d42"), true)

	# Gold/Copper Parallel Bus Traces
	draw_line(Vector2(pcb.position.x + 10, pcb.end.y - 28), Vector2(pcb.end.x - 80, pcb.end.y - 28), Color("e0a96d"), 2.0)
	draw_line(Vector2(pcb.position.x + 10, pcb.end.y - 22), Vector2(pcb.end.x - 80, pcb.end.y - 22), Color("e0a96d"), 2.0)

	# Connectors for Tape Decks and Diablo Disk Interface
	draw_rect(Rect2(pcb.position.x + 14, pcb.end.y - 14, 60, 8), Color("dcdcdc"), true)
	draw_string(font, Vector2(pcb.position.x + 16, pcb.end.y - 7), "TAPE I/O", HORIZONTAL_ALIGNMENT_LEFT, 56, 7, Color("111111"))

	draw_rect(Rect2(pcb.position.x + 84, pcb.end.y - 14, 80, 8), Color("dcdcdc"), true)
	draw_string(font, Vector2(pcb.position.x + 86, pcb.end.y - 7), "DIABLO DISK I/O", HORIZONTAL_ALIGNMENT_LEFT, 76, 7, Color("111111"))

	_draw_plate_footer(
		rect,
		font,
		"EXHIBIT PLATE II // CTC 8-BIT DISCRETE MSI TTL CPU (~100 ICs • X86 ROOT)",
		Color("95d5b2"),
		Color("2d6a4f"),
		"ARCHITECTURE SCHEMATIC",
		Color("2d6a4f")
	)


func _draw_datapoint_software_plate(rect: Rect2, font: Font) -> void:
	# Authentic 12-Line x 80-Column P31 Green Phosphor Terminal Screen
	draw_rect(rect, Color("030904"), true)

	# Curved CRT Screen vignette
	var scr := rect.grow(-10)
	draw_rect(scr, Color("041207"), true)
	draw_rect(scr, Color("1f5c2c"), false, 1.5)

	# Luminous P31 Green Text
	var p31 := Color("33ff55")
	var highlight := Color("80ff80")
	var lines := [
		{"t": "DATAPOINT 2200 BOOTSTRAP ROM REV 2.4", "c": p31},
		{"t": "LOADING DOS.SYS FROM DIABLO DISK 0...", "c": Color("20c20e")},
		{"t": "DATAPOINT DOS VERSION 2.1  COPYRIGHT (C) 1972 CTC", "c": p31},
		{"t": "PLEASE ENTER CURRENT DATE (MM/DD/YY): 10/22/72", "c": highlight},
		{"t": "DATE SET: 10/22/72", "c": p31},
		{"t": "DOS READY.", "c": p31},
		{"t": ": CATALOG", "c": highlight},
		{"t": "DOS.SYS    ASM.CMD    EDIT.CMD    DATABUS.CMD    LEDGER.DAT", "c": p31},
		{"t": "TOTAL BLOCKS: 1024   FREE: 677   BAD: 0", "c": p31},
		{"t": ": _", "c": p31}
	]

	for idx in range(lines.size()):
		var line_dict: Dictionary = lines[idx]
		var y := scr.position.y + 16 + idx * 14
		draw_string(font, Vector2(scr.position.x + 12, y), str(line_dict["t"]), HORIZONTAL_ALIGNMENT_LEFT, scr.size.x - 24, 10, line_dict["c"])

	# Scanline raster effect
	var sy := scr.position.y
	while sy < scr.end.y:
		draw_line(Vector2(scr.position.x, sy), Vector2(scr.end.x, sy), Color(0.1, 0.4, 0.15, 0.12), 1.0)
		sy += 3.0

	draw_rect(rect, Color("20c20e"), false, 1.5)
	_draw_plate_badge("12x80 CRT SHELL", Color("1b6e28"))


func _draw_alexnet_chassis(rect: Rect2, cx: float, cy: float, font: Font) -> void:
	# Widescreen 24" 16:9 LCD Monitor on the Left
	var mon_rect := Rect2(cx - 134, cy - 54, 150, 96)
	var mon_bezel := Color("1e1e24")
	draw_rect(mon_rect, mon_bezel, true)
	draw_rect(mon_rect, mon_bezel.lightened(0.2), false, 1.5)
	# Monitor stand and base
	draw_rect(Rect2(mon_rect.position.x + 58, mon_rect.end.y, 34, 14), Color("121216"), true)
	draw_rect(Rect2(mon_rect.position.x + 38, mon_rect.end.y + 12, 74, 5), Color("121216"), true)

	# Screen contents: Ubuntu 10.04 Ambiance aubergine desktop
	var scr := mon_rect.grow(-6)
	draw_rect(scr, Color("2c001e"), true)
	draw_rect(Rect2(scr.position.x, scr.position.y + scr.size.y * 0.45, scr.size.x, scr.size.y * 0.55), Color("77216f", 0.5), true)
	# GNOME 2.30 Panels
	draw_rect(Rect2(scr.position.x, scr.position.y, scr.size.x, 7), Color("1c191a"), true)
	draw_rect(Rect2(scr.position.x, scr.end.y - 7, scr.size.x, 7), Color("1c191a"), true)
	# Mini Ambiance window on screen
	var w_mini := Rect2(scr.position.x + 12, scr.position.y + 12, 78, 48)
	draw_rect(w_mini, Color("edeceb"), true)
	draw_rect(Rect2(w_mini.position, Vector2(w_mini.size.x, 8)), Color("3c3b37"), true)
	# Mini top-left window dots
	draw_circle(w_mini.position + Vector2(4, 4), 1.5, Color("df5320"))
	draw_circle(w_mini.position + Vector2(9, 4), 1.5, Color("888888"))

	# High-Airflow ATX Full-Tower Case on the Right (AlexNet Rig)
	var tw_rect := Rect2(cx + 26, cy - 68, 92, 132)
	draw_rect(tw_rect, Color("141418"), true)
	draw_rect(tw_rect, Color("2e2e36"), false, 1.5)

	# Front mesh intake with dual 140mm cooling fans glowing green
	draw_rect(Rect2(tw_rect.position.x + 4, tw_rect.position.y + 12, 16, 108), Color("0b0b0e"), true)
	draw_circle(Vector2(tw_rect.position.x + 12, tw_rect.position.y + 40), 6.5, Color("76b900", 0.45))
	draw_circle(Vector2(tw_rect.position.x + 12, tw_rect.position.y + 86), 6.5, Color("76b900", 0.45))

	# Acrylic side viewing window
	var win_rect := Rect2(tw_rect.position.x + 24, tw_rect.position.y + 12, 62, 108)
	draw_rect(win_rect, Color("08080c"), true)
	draw_rect(win_rect, Color("3a3a44"), false, 1.0)

	# CPU Tower Cooler (top chamber)
	var cooler_rect := Rect2(win_rect.position.x + 8, win_rect.position.y + 8, 28, 24)
	draw_rect(cooler_rect, Color("a0a4a8"), true)
	for f in range(4):
		draw_line(Vector2(cooler_rect.position.x + 4 + f * 6, cooler_rect.position.y), Vector2(cooler_rect.position.x + 4 + f * 6, cooler_rect.end.y), Color("505356"), 1.0)

	# 2x Dual-Slot NVIDIA GeForce GTX 580 Graphics Cards (Fermi 3GB)
	for g in range(2):
		var gpu_r := Rect2(win_rect.position.x + 6, win_rect.position.y + 38 + g * 22, 52, 16)
		draw_rect(gpu_r, Color("202024"), true)
		draw_rect(gpu_r, Color("383842"), false, 1.0)
		# Green GeForce side logo & silver blower fan
		draw_rect(Rect2(gpu_r.position.x + 2, gpu_r.position.y + 3, 22, 3), Color("76b900"), true)
		draw_circle(Vector2(gpu_r.end.x - 10, gpu_r.position.y + 8), 5.5, Color("dcdcdc"))
		draw_circle(Vector2(gpu_r.end.x - 10, gpu_r.position.y + 8), 2.0, Color("111111"))

	# SLI Bridge linking the dual GTX 580 cards
	draw_rect(Rect2(win_rect.position.x + 10, win_rect.position.y + 48, 6, 18), Color("76b900"), true)

	# Heavy 1200W Power Supply at Bottom
	draw_rect(Rect2(win_rect.position.x + 6, win_rect.end.y - 20, 52, 16), Color("16161a"), true)
	draw_rect(Rect2(win_rect.position.x + 8, win_rect.end.y - 16, 20, 8), Color("333333"), true)
	draw_string(font, Vector2(win_rect.position.x + 10, win_rect.end.y - 9), "1200W", HORIZONTAL_ALIGNMENT_LEFT, 24, 6, Color("ffaa5e"))


func _draw_alexnet_motherboard(rect: Rect2, pcb: Rect2, font: Font) -> void:
	# Intel X79 Enthusiast Motherboard Substrate
	draw_rect(rect, Color("08080c"), true)
	_draw_blueprint_grid(rect, Color(0.25, 0.20, 0.35, 0.18), 14.0)

	draw_rect(pcb, Color("121118"), true)
	draw_rect(pcb, Color("4a225d"), false, 1.5)

	# LGA 2011 CPU Socket (Intel Core i7-3930K 6-Core)
	var cpu_r := Rect2(pcb.position.x + 72, pcb.position.y + 16, 54, 54)
	draw_rect(cpu_r, Color("25252c"), true)
	draw_rect(cpu_r, Color("e0a96d"), false, 1.5)
	draw_rect(cpu_r.grow(-8), Color("8d99ae"), true)
	draw_string(font, cpu_r.position + Vector2(6, 26), "i7-3930K", HORIZONTAL_ALIGNMENT_CENTER, 42, 8, Color("111111"))
	draw_string(font, cpu_r.position + Vector2(6, 38), "6C / 12T", HORIZONTAL_ALIGNMENT_CENTER, 42, 7, Color("333333"))

	# 8x DDR3 Quad-Channel DIMM Slots (4 on Left, 4 on Right of CPU)
	for side in range(2):
		var base_x := pcb.position.x + 14 if side == 0 else pcb.position.x + 138
		for d in range(4):
			var dimm_r := Rect2(base_x + d * 11, pcb.position.y + 14, 8, 58)
			draw_rect(dimm_r, Color("1a1a24") if d % 2 == 0 else Color("2a4478"), true)
			draw_rect(dimm_r, Color("4ea8de"), false, 0.8)

	# 2x Full-Length Dual-Slot PCIe 2.0 x16 Slots with Dual GTX 580s
	for g in range(2):
		var slot_y := pcb.position.y + 86 + g * 28
		# PCIe Slot
		draw_rect(Rect2(pcb.position.x + 14, slot_y, 160, 6), Color("22222a"), true)
		# GTX 580 Card representation
		var card_r := Rect2(pcb.position.x + 14, slot_y + 4, 156, 18)
		draw_rect(card_r, Color("1e1e24"), true)
		draw_rect(card_r, Color("76b900"), false, 1.2)
		draw_string(font, card_r.position + Vector2(8, 12), "GPU %d: NVIDIA GEFORCE GTX 580 (512 CUDA CORES • 3GB GDDR5)" % g, HORIZONTAL_ALIGNMENT_LEFT, 148, 7, Color("a8e063"))

	# High-speed Peer-to-Peer DMA Bridge between both GPUs
	draw_line(Vector2(pcb.position.x + 28, pcb.position.y + 96), Vector2(pcb.position.x + 28, pcb.position.y + 124), Color("76b900"), 3.0)
	draw_string(font, Vector2(pcb.position.x + 34, pcb.position.y + 114), "PEER-TO-PEER PCIE DMA (MODEL SPLIT)", HORIZONTAL_ALIGNMENT_LEFT, 130, 6, Color("76b900"))

	# Intel X79 Chipset Heatsink
	var x79_r := Rect2(pcb.end.x - 52, pcb.end.y - 42, 38, 32)
	draw_rect(x79_r, Color("2c2c36"), true)
	draw_rect(x79_r, Color("dd4814"), false, 1.2)
	draw_string(font, x79_r.position + Vector2(4, 18), "X79 PCH", HORIZONTAL_ALIGNMENT_CENTER, 30, 7, Color("ffaa5e"))

	_draw_plate_footer(
		rect,
		font,
		"EXHIBIT PLATE II // INTEL X79 + DUAL NVIDIA GTX 580 FERMI (6GB GDDR5 TOTAL)",
		Color("a8e063"),
		Color("386616"),
		"AI HARDWARE ZERO-POINT",
		Color("76b900")
	)


func _draw_ubuntu_1004_software_plate(rect: Rect2, font: Font) -> void:
	# Ubuntu 10.04 Lucid Lynx Ambiance Aubergine Gradient Desktop
	draw_rect(rect, Color("2c001e"), true)
	draw_rect(Rect2(0, rect.size.y * 0.40, rect.size.x, rect.size.y * 0.60), Color("77216f", 0.45), true)

	# GNOME 2.30 Panels: Top (Applications/Places/System) + Bottom (Window List)
	draw_rect(Rect2(0, 0, rect.size.x, 16), Color("1b181c"), true)
	draw_string(font, Vector2(8, 12), "Applications   Places   System", HORIZONTAL_ALIGNMENT_LEFT, 160, 8, Color("dfdbd2"))
	draw_string(font, Vector2(rect.size.x - 70, 12), "14:22   alex", HORIZONTAL_ALIGNMENT_RIGHT, 62, 8, Color("dfdbd2"))

	draw_rect(Rect2(0, rect.size.y - 18, rect.size.x, 18), Color("1b181c"), true)
	draw_string(font, Vector2(8, rect.size.y - 5), "[AlexNet Training Monitor]   [alex@alexnet-node0: ~/cuda-convnet]", HORIZONTAL_ALIGNMENT_LEFT, 260, 8, Color("9e9890"))

	# Primary Application Window: Ambiance Theme with LEFT-ALIGNED WINDOW BUTTONS!
	var w1 := Rect2(18, 26, rect.size.x * 0.54, rect.size.y * 0.56)
	draw_rect(w1, Color("edeceb"), true)
	draw_rect(w1, Color("3c3b37"), false, 1.5)

	# Dark charcoal Ambiance titlebar
	var tb_r := Rect2(w1.position, Vector2(w1.size.x, 16))
	draw_rect(tb_r, Color("3c3b37"), true)
	# Iconic Left-Aligned Ambiance Window Controls (close, minimize, maximize)
	draw_circle(tb_r.position + Vector2(8, 8), 3.5, Color("df5320")) # Close (Orange)
	draw_circle(tb_r.position + Vector2(18, 8), 3.5, Color("6e6d67")) # Minimize
	draw_circle(tb_r.position + Vector2(28, 8), 3.5, Color("6e6d67")) # Maximize
	draw_string(font, tb_r.position + Vector2(38, 12), "AlexNet 2012 Training Monitor", HORIZONTAL_ALIGNMENT_LEFT, w1.size.x - 44, 8, Color.WHITE)

	# Training Stats inside window
	var stats := [
		"ILSVRC 2012 ImageNet Benchmark",
		"Epoch: 84/90  •  Batch: 1200/1280",
		"Step Time: 452ms (2,240 img/sec)",
		"GPU 0: 98% Util (2884MB / 82°C)",
		"GPU 1: 99% Util (2912MB / 84°C)",
		"Top-5 Error: 15.3% (RECORD WIN)"
	]
	for s_idx in range(stats.size()):
		var col := Color("dd4814") if s_idx == 5 else Color("222222")
		draw_string(font, w1.position + Vector2(10, 32 + s_idx * 13), stats[s_idx], HORIZONTAL_ALIGNMENT_LEFT, w1.size.x - 20, 8, col)

	# Overlapping Terminal Window (Bottom-Right)
	var w2 := Rect2(rect.size.x * 0.34, rect.size.y * 0.36, rect.size.x * 0.60, rect.size.y * 0.48)
	draw_rect(w2, Color("1a0a1e"), true)
	draw_rect(w2, Color("3c3b37"), false, 1.5)
	var tb2_r := Rect2(w2.position, Vector2(w2.size.x, 16))
	draw_rect(tb2_r, Color("3c3b37"), true)
	draw_circle(tb2_r.position + Vector2(8, 8), 3.5, Color("df5320"))
	draw_circle(tb2_r.position + Vector2(18, 8), 3.5, Color("6e6d67"))
	draw_circle(tb2_r.position + Vector2(28, 8), 3.5, Color("6e6d67"))
	draw_string(font, tb2_r.position + Vector2(38, 12), "alex@alexnet-node0: ~/cuda-convnet", HORIZONTAL_ALIGNMENT_LEFT, w2.size.x - 44, 8, Color.WHITE)

	# Terminal shell text
	draw_string(font, w2.position + Vector2(8, 30), "alex@alexnet-node0:~$ python convdata.py", HORIZONTAL_ALIGNMENT_LEFT, w2.size.x - 16, 8, Color("dd4814"))
	draw_string(font, w2.position + Vector2(8, 44), "Dual Fermi model parallelism active across GPUs 0 & 1.", HORIZONTAL_ALIGNMENT_LEFT, w2.size.x - 16, 8, Color("dfdbd2"))
	draw_string(font, w2.position + Vector2(8, 58), "Training loss: 1.412  Top-5 error: 15.3% (Shattering 26.2%)", HORIZONTAL_ALIGNMENT_LEFT, w2.size.x - 16, 8, Color("76b900"))
	draw_string(font, w2.position + Vector2(8, 72), "Impending move to Unity noted. Final GNOME 2 LTS active.", HORIZONTAL_ALIGNMENT_LEFT, w2.size.x - 16, 8, Color("9e9890"))

	draw_rect(rect, Color("dd4814"), false, 1.5)
	_draw_plate_badge("AI PARADIGM SHIFT (2012)", Color("dd4814"))

