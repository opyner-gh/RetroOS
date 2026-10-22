class_name MainController
extends Control
## Root scene controller (`MainController`).
## Manages scene transitions between `MainMenu`, `BootSequence`, and `DesktopEnvironment`,
## drives the physical workstation chassis bezel (Power/HDD/Floppy activity LEDs & hardware toggles),
## and controls the CRT scanline shader overlay and 4:3 / 16:9 aspect ratio display framing.

const MENU_SCENE := preload("res://scenes/menu/main_menu.tscn")
const BOOT_SCENE := preload("res://scenes/boot/boot_sequence.tscn")
const DESKTOP_SCENE := preload("res://scenes/desktop/desktop_environment.tscn")

@onready var stage_container: Control = $StageContainer
@onready var display_frame: Control = $StageContainer/DisplayFrame
@onready var left_pillarbox: ColorRect = $StageContainer/LeftPillarbox
@onready var right_pillarbox: ColorRect = $StageContainer/RightPillarbox
@onready var hdd_led_rect: ColorRect = $ChassisBezel/BezelMargin/BezelHBox/HDDLedRect
@onready var fdd_led_rect: ColorRect = $ChassisBezel/BezelMargin/BezelHBox/FDDLedRect
@onready var active_os_label: Label = $ChassisBezel/BezelMargin/BezelHBox/ActiveOSLabel
@onready var fan_toggle_btn: Button = $ChassisBezel/BezelMargin/BezelHBox/FanToggleBtn
@onready var hdd_toggle_btn: Button = $ChassisBezel/BezelMargin/BezelHBox/HDDToggleBtn
@onready var floppy_seek_btn: Button = $ChassisBezel/BezelMargin/BezelHBox/FloppySeekBtn
@onready var crt_toggle_btn: Button = $ChassisBezel/BezelMargin/BezelHBox/CRTToggleBtn
@onready var kvm_switch_btn: Button = $ChassisBezel/BezelMargin/BezelHBox/KVMSwitchBtn
@onready var crt_rect: ColorRect = $CRTLayer/CRTOverlayRect

var _active_scene_node: Node = null


func _ready() -> void:
	GameState.phase_changed.connect(_on_phase_changed)
	GameState.crt_toggled.connect(_on_crt_toggled)
	AudioManager.disk_activity_pulsed.connect(_on_disk_activity_pulsed)

	fan_toggle_btn.pressed.connect(_on_fan_toggle_pressed)
	hdd_toggle_btn.pressed.connect(_on_hdd_toggle_pressed)
	floppy_seek_btn.pressed.connect(func(): AudioManager.play_floppy_seek())
	crt_toggle_btn.pressed.connect(func(): GameState.toggle_crt_effect())
	kvm_switch_btn.pressed.connect(func(): GameState.reboot_to_menu())

	_on_crt_toggled(GameState.crt_enabled)
	_switch_to_phase(GameState.SimPhase.MAIN_MENU)

	if OS.has_environment("RETROOS_CAPTURE_SCREENSHOT") or OS.get_cmdline_user_args().has("--capture-screenshot"):
		_auto_capture_and_quit()


func _auto_capture_and_quit() -> void:
	for i in range(20):
		await get_tree().process_frame
	var img := get_viewport().get_texture().get_image()
	if img:
		img.save_png("res://screenshot_main_menu.png")
		print("Auto-captured screenshot: res://screenshot_main_menu.png (%dx%d)" % [img.get_width(), img.get_height()])
	get_tree().quit(0)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F12:
			GameState.reboot_to_menu()
		elif event.keycode == KEY_F2:
			GameState.toggle_crt_effect()


func _on_phase_changed(new_phase: GameState.SimPhase) -> void:
	_switch_to_phase(new_phase)


func _update_display_frame_layout(aspect_ratio: String) -> void:
	var is_4_3 := (aspect_ratio == "4:3")
	if is_4_3:
		# 4:3 Display: 960x720 centered within 1280x720 (160px black bars on left and right)
		display_frame.anchor_left = 0.0
		display_frame.anchor_right = 1.0
		display_frame.anchor_top = 0.0
		display_frame.anchor_bottom = 1.0
		display_frame.offset_left = 160.0
		display_frame.offset_right = -160.0
		display_frame.offset_top = 0.0
		display_frame.offset_bottom = 0.0
		left_pillarbox.visible = true
		right_pillarbox.visible = true
		_update_crt_bounds(Vector4(160.0 / 1280.0, 0.0, 960.0 / 1280.0, 688.0 / 720.0))
	else:
		# 16:9 Display: Full 1280x720 width (no black bars)
		display_frame.anchor_left = 0.0
		display_frame.anchor_right = 1.0
		display_frame.anchor_top = 0.0
		display_frame.anchor_bottom = 1.0
		display_frame.offset_left = 0.0
		display_frame.offset_right = 0.0
		display_frame.offset_top = 0.0
		display_frame.offset_bottom = 0.0
		left_pillarbox.visible = false
		right_pillarbox.visible = false
		_update_crt_bounds(Vector4(0.0, 0.0, 1.0, 688.0 / 720.0))


func _update_crt_bounds(bounds: Vector4) -> void:
	var mat := crt_rect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("display_bounds", bounds)


func _switch_to_phase(phase: GameState.SimPhase) -> void:
	if is_instance_valid(_active_scene_node):
		_active_scene_node.queue_free()
		_active_scene_node = null

	match phase:
		GameState.SimPhase.MAIN_MENU:
			_update_display_frame_layout("16:9")
			_active_scene_node = MENU_SCENE.instantiate()
			active_os_label.text = "KVM: OS SELECTOR"
			kvm_switch_btn.disabled = true

		GameState.SimPhase.BOOT_SEQUENCE:
			var ratio := GameState.current_profile.aspect_ratio if GameState.current_profile else "16:9"
			_update_display_frame_layout(ratio)
			_active_scene_node = BOOT_SCENE.instantiate()
			var os_name := GameState.current_profile.short_name if GameState.current_profile else "BIOS"
			active_os_label.text = "POST / BOOT: " + os_name
			kvm_switch_btn.disabled = false

		GameState.SimPhase.DESKTOP:
			var ratio := GameState.current_profile.aspect_ratio if GameState.current_profile else "16:9"
			_update_display_frame_layout(ratio)
			_active_scene_node = DESKTOP_SCENE.instantiate()
			var os_name := GameState.current_profile.short_name if GameState.current_profile else "OS"
			active_os_label.text = "ONLINE: " + os_name
			kvm_switch_btn.disabled = false

	if _active_scene_node:
		display_frame.add_child(_active_scene_node)


func _on_disk_activity_pulsed(is_floppy: bool) -> void:
	if is_floppy:
		fdd_led_rect.color = Color("33ff55")
		var tw := create_tween()
		tw.tween_property(fdd_led_rect, "color", Color("14331a"), 0.42)
	else:
		hdd_led_rect.color = Color("ff8811")
		var tw := create_tween()
		tw.tween_property(hdd_led_rect, "color", Color("332010"), 0.12)


func _on_fan_toggle_pressed() -> void:
	AudioManager.set_fan_enabled(not AudioManager.fan_enabled)
	fan_toggle_btn.text = "Fan: ON" if AudioManager.fan_enabled else "Fan: OFF"


func _on_hdd_toggle_pressed() -> void:
	AudioManager.set_hdd_ambient_enabled(not AudioManager.hdd_ambient_enabled)
	hdd_toggle_btn.text = "HDD Chatter: ON" if AudioManager.hdd_ambient_enabled else "HDD Chatter: OFF"


func _on_crt_toggled(enabled: bool) -> void:
	crt_rect.visible = enabled
	crt_toggle_btn.text = "CRT (F2): ON" if enabled else "CRT (F2): OFF"
