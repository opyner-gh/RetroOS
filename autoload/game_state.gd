extends Node
## Global state singleton (Autoload: `GameState`) managing OS selection,
## simulation lifecycle transitions, and display preferences.

const OSProfile = preload("res://data/os_profile.gd")
const OSRegistry = preload("res://data/os_registry.gd")

enum SimPhase {
	MAIN_MENU,
	BOOT_SEQUENCE,
	DESKTOP,
}

signal phase_changed(new_phase: SimPhase)
signal os_selected(profile: OSProfile)
signal boot_completed(profile: OSProfile)
signal system_reboot_requested()
signal crt_toggled(enabled: bool)

var available_profiles: Array[OSProfile] = []
var current_profile: OSProfile = null
var current_phase: SimPhase = SimPhase.MAIN_MENU
var crt_enabled: bool = true


func _ready() -> void:
	available_profiles = OSRegistry.get_all_profiles()
	if not available_profiles.is_empty():
		current_profile = available_profiles[0]


func select_and_boot_os(os_id: String) -> void:
	current_profile = OSRegistry.get_profile_by_id(os_id)
	current_phase = SimPhase.BOOT_SEQUENCE
	os_selected.emit(current_profile)
	phase_changed.emit(current_phase)


func finish_boot_to_desktop() -> void:
	current_phase = SimPhase.DESKTOP
	boot_completed.emit(current_profile)
	phase_changed.emit(current_phase)


func reboot_to_menu() -> void:
	current_phase = SimPhase.MAIN_MENU
	system_reboot_requested.emit()
	phase_changed.emit(current_phase)


func toggle_crt_effect() -> void:
	crt_enabled = not crt_enabled
	crt_toggled.emit(crt_enabled)

