class_name RetroOSProfile
extends Resource
## Data resource defining a complete retro operating system profile in RetroOS.
## New operating systems can be added either in `OSRegistry` or as `.tres` files
## placed in `res://data/profiles/`.

@export_group("Identity & Metadata")
@export var id: String = "custom_os"
@export var category: String = "Workstation"
@export var display_name: String = "Custom Retro OS"
@export var short_name: String = "Custom OS"
@export var release_year: String = "1999"
@export var vendor: String = "Generic Corp."
@export var architecture_summary: String = "x86 / Generic Kernel"
@export var hardware_profile: String = "Generic x86 Workstation • 64MB RAM"
@export_multiline var description: String = "A retro operating system profile."

@export_group("BIOS & Boot Sequence")
@export_multiline var bios_header: String = "RETRO-BIOS v1.0 (C) 1995-2007"
@export var boot_bg_color: Color = Color("050507")
@export var boot_text_color: Color = Color("c8c8c8")
## Array of Dictionaries: { "text": String, "delay": float, "sfx": String, "color": String }
## Supported sfx keys: "", "beep", "floppy", "hdd_click", "hdd_burst", "fan_spinup"
@export var boot_logs: Array[Dictionary] = []

@export_group("Desktop Theme & Chrome")
## Supported styles: "gnome_human", "motif_cde", "plan9_rio", "win98_classic", "os2_pmshell"
@export var chrome_style: String = "win98_classic"
@export var desktop_bg_color: Color = Color("008080")
@export var desktop_secondary_color: Color = Color("005555")
@export var panel_bg_color: Color = Color("c0c0c0")
@export var panel_text_color: Color = Color("111111")
@export var window_bg_color: Color = Color("d4d0c8")
@export var window_text_color: Color = Color("111111")
@export var window_border_color: Color = Color("404040")
@export var titlebar_active_color: Color = Color("000080")
@export var titlebar_active_gradient_end: Color = Color("1084d0")
@export var titlebar_inactive_color: Color = Color("808080")
@export var titlebar_text_color: Color = Color("ffffff")
@export var accent_color: Color = Color("000080")

@export_group("Terminal Configuration")
@export var terminal_title: String = "Terminal"
@export var terminal_bg_color: Color = Color("000000")
@export var terminal_fg_color: Color = Color("c0c0c0")
@export var terminal_prompt: String = "> "
@export_multiline var terminal_welcome_banner: String = "RetroOS Terminal Ready.\nType 'help' for available commands."
## Dictionary mapping command strings (lowercase) to multi-line response text.
@export var terminal_commands: Dictionary = {}

@export_group("Desktop Layout & Windows")
## Array of Dictionaries describing initial windows:
## { "id": String, "title": String, "type": "terminal"|"text"|"monitor"|"files"|"about",
##   "pos": Vector2, "size": Vector2, "content": String }
@export var default_windows: Array[Dictionary] = []
## Array of Dictionaries describing desktop/panel launchers:
## { "id": String, "label": String, "glyph": String, "target_window_id": String }
@export var desktop_icons: Array[Dictionary] = []

@export_group("Hardware Audio Profile")
@export var startup_sound_path: String = ""
@export var fan_base_freq: float = 115.0
@export var fan_noise_level: float = 0.25
@export var hdd_seek_interval_range: Vector2 = Vector2(2.8, 7.5)

