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
signal sr2_os_switched(new_sub_os: String)

var available_profiles: Array[OSProfile] = []
var current_profile: OSProfile = null
var current_phase: SimPhase = SimPhase.MAIN_MENU
var crt_enabled: bool = false
var sr2_active_os: String = "win7" # "win7", "lion", "solaris"


func _ready() -> void:
	available_profiles = OSRegistry.get_all_profiles()
	if not available_profiles.is_empty():
		current_profile = available_profiles[0]


func set_crt_enabled(enabled: bool) -> void:
	if crt_enabled != enabled:
		crt_enabled = enabled
		crt_toggled.emit(crt_enabled)


func set_sr2_active_os(new_sub_os: String) -> void:
	sr2_active_os = new_sub_os
	if current_profile and current_profile.id == "evga_sr2":
		OSRegistry.apply_sr2_sub_profile(current_profile, sr2_active_os)
	sr2_os_switched.emit(new_sub_os)


func get_sr2_os_title() -> String:
	match sr2_active_os:
		"lion":
			return "Mac OS X 10.7 Lion"
		"solaris":
			return "Oracle Solaris 11"
		_:
			return "Windows 7 Ultimate"


func select_and_boot_os(os_id: String) -> void:
	current_profile = OSRegistry.get_profile_by_id(os_id)
	if current_profile and current_profile.id == "evga_sr2":
		OSRegistry.apply_sr2_sub_profile(current_profile, sr2_active_os)
	set_crt_enabled(current_profile.has_crt if current_profile else false)
	current_phase = SimPhase.BOOT_SEQUENCE
	os_selected.emit(current_profile)
	phase_changed.emit(current_phase)


func finish_boot_to_desktop() -> void:
	current_phase = SimPhase.DESKTOP
	boot_completed.emit(current_profile)
	phase_changed.emit(current_phase)


func reboot_to_menu() -> void:
	set_crt_enabled(false)
	current_phase = SimPhase.MAIN_MENU
	system_reboot_requested.emit()
	phase_changed.emit(current_phase)


func toggle_crt_effect() -> void:
	set_crt_enabled(not crt_enabled)

