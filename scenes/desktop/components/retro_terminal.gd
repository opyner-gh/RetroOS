class_name RetroOSTerminal
extends PanelContainer
## Interactive fake retro terminal emulator component (`RetroTerminal`).
## Adapts its prompt, color scheme, welcome banner, and command set to the active `OSProfile`.

const OSProfile = preload("res://data/os_profile.gd")

signal terminal_exit_requested()
signal system_reboot_requested()

@onready var background_rect: ColorRect = $BackgroundRect
@onready var output_label: RichTextLabel = $MarginContainer/VBoxContainer/OutputScroll/OutputLabel
@onready var prompt_label: Label = $MarginContainer/VBoxContainer/InputRow/PromptLabel
@onready var command_input: LineEdit = $MarginContainer/VBoxContainer/InputRow/CommandInput

var _profile: OSProfile
var _history: Array[String] = []
var _history_index: int = -1


func _ready() -> void:
	command_input.text_submitted.connect(_on_command_submitted)
	command_input.gui_input.connect(_on_input_gui_event)
	gui_input.connect(_on_terminal_clicked)


func setup_for_os(profile: OSProfile) -> void:
	_profile = profile
	if not is_node_ready():
		await ready

	background_rect.color = profile.terminal_bg_color
	output_label.add_theme_color_override("default_color", profile.terminal_fg_color)
	prompt_label.text = profile.terminal_prompt
	prompt_label.add_theme_color_override("font_color", profile.terminal_fg_color)

	command_input.add_theme_color_override("font_color", profile.terminal_fg_color)
	command_input.add_theme_color_override("caret_color", profile.terminal_fg_color)

	output_label.clear()
	append_line(profile.terminal_welcome_banner)
	append_line("")
	focus_input()


func focus_input() -> void:
	if is_inside_tree() and command_input:
		command_input.grab_focus()


func append_line(text: String) -> void:
	if output_label.get_total_character_count() > 0:
		output_label.append_text("\n" + text)
	else:
		output_label.append_text(text)


func _on_terminal_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		focus_input()


func _on_input_gui_event(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_UP:
			_navigate_history(-1)
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_DOWN:
			_navigate_history(1)
			get_viewport().set_input_as_handled()


func _navigate_history(direction: int) -> void:
	if _history.is_empty():
		return
	_history_index = clampi(_history_index + direction, 0, _history.size())
	if _history_index < _history.size():
		command_input.text = _history[_history_index]
		command_input.caret_column = command_input.text.length()
	else:
		command_input.clear()


func _on_command_submitted(raw_cmd: String) -> void:
	var trimmed := raw_cmd.strip_edges()
	var prompt_str := _profile.terminal_prompt if _profile else "> "
	append_line(prompt_str + trimmed)
	command_input.clear()

	if trimmed.is_empty():
		if _profile and _profile.id == "dec_pdp7":
			AudioManager.play_teletype_clatter()
		else:
			AudioManager.play_hdd_click(0.04)
		return

	_history.append(trimmed)
	_history_index = _history.size()
	if _profile and _profile.id == "dec_pdp7":
		AudioManager.play_teletype_clatter()
	else:
		AudioManager.play_hdd_click()

	_execute_command(trimmed)


func _execute_command(cmd: String) -> void:
	var lower := cmd.to_lower()

	# Universal clear commands (including Applesoft BASIC 'HOME')
	if lower == "clear" or lower == "cls" or lower == "home":
		output_label.clear()
		return

	# Close terminal window
	if lower == "exit" or lower == "logout":
		terminal_exit_requested.emit()
		return

	# Reboot back to KVM OS selector
	if lower == "reboot" or lower == "shutdown" or lower == "halt":
		append_line("Broadcast message from root: The system is going down for reboot NOW!")
		AudioManager.play_hdd_burst()
		system_reboot_requested.emit()
		return

	# Trigger floppy / optical / Disk II seek from terminal
	if lower == "floppy" or lower == "a:" or lower == "dir a:" or lower == "mount /dev/fd0":
		if _profile and _profile.id == "apple_iie":
			AudioManager.play_disk2_bang()
			append_line("SLOT 6 DRIVE 1: SHUGART SA-390 TRACK-00 RECALIBRATION COMPLETE.")
		else:
			AudioManager.play_floppy_seek()
			append_line("Accessing 3.5\" 1.44MB Floppy Drive (fd0 / A:)... Not ready reading drive A: Abort, Retry, Fail?")
		return

	if lower == "cdrom" or lower == "eject" or lower == "d:" or lower == "dir d:":
		AudioManager.play_optical_seek()
		append_line("ATAPI/SCSI CD-ROM: Laser focus seek and sled homing complete. Medium present.")
		return

	# Datapoint DOS interactive date entry support
	if _profile and _profile.id == "datapoint_2200":
		if lower.begins_with("date ") or (lower.contains("/") and lower.replace("/", "").is_valid_int()):
			var date_str := ""
			if lower.begins_with("date "):
				date_str = cmd.substr(5).strip_edges()
			else:
				date_str = cmd.strip_edges()
			if date_str.is_empty():
				date_str = "10/22/72"
			append_line("DATE SET: " + date_str)
			append_line("DOS READY.")
			return

	# DEC PDP-7 & Research Unix interactive commands
	if _profile and _profile.id == "dec_pdp7":
		if lower.begins_with("rm ") or lower == "rm":
			# Radical economy of keystrokes: success yields absolute silence!
			return

		if lower.begins_with("cp ") or lower == "cp":
			return

		if lower.begins_with("mv ") or lower == "mv":
			return

		if lower == "bell":
			AudioManager.play_teletype_bell()
			return

		if lower.begins_with("ed ") or lower == "ed":
			AudioManager.play_teletype_clatter()
			append_line("?")
			return

		if lower == "space" or lower == "spacetravel":
			AudioManager.play_teletype_clatter()
			append_line("INITIALIZING DEC TYPE 340 CRT DISPLAY VECTORS...")
			append_line("CELESTIAL ORBITAL TABLES LOADED: [SOL, MERCURY, VENUS, EARTH, MARS]")
			append_line("SOLVING KEPLER'S EQUATIONS ACROSS 18-BIT ACCUMULATOR...")
			append_line("SPACE TRAVEL SIMULATION ACTIVE ON DEC 340 SCOPE.")
			return

	# EVGA SR-2 specific boot switching & BBS commands
	if _profile and _profile.id == "evga_sr2":
		if lower == "switch-win7":
			AudioManager.play_hdd_burst()
			GameState.set_sr2_active_os("win7")
			append_line("Switching active boot SSD to Port 0: Windows 7 Ultimate SP1 (x64)...")
			append_line("Desktop environment reloaded.")
			return

		if lower == "switch-lion":
			AudioManager.play_hdd_burst()
			GameState.set_sr2_active_os("lion")
			append_line("Switching active boot SSD to Port 1: Mac OS X 10.7 Lion (x86_64 Hackintosh)...")
			append_line("Desktop environment reloaded.")
			return

		if lower == "switch-solaris":
			AudioManager.play_hdd_burst()
			GameState.set_sr2_active_os("solaris")
			append_line("Switching active boot SSD to Port 2: Oracle Solaris 11 (11/11 x86)...")
			append_line("Desktop environment reloaded.")
			return

		if lower == "bbs":
			AudioManager.play_hdd_click()
			append_line("Initiating soft reboot into EVGA Classified SR-2 BIOS BBS menu...")
			GameState.select_and_boot_os("evga_sr2")
			return

	# Check OS-specific command dictionary
	if _profile and _profile.terminal_commands.has(lower):
		if lower == "pr#6":
			AudioManager.play_disk2_bang()
		append_line(str(_profile.terminal_commands[lower]))
		return

	# Universal help command listing OS-specific + global commands
	if lower == "help" or lower == "?" or lower == "man":
		var os_cmds := PackedStringArray()
		if _profile:
			for k in _profile.terminal_commands.keys():
				os_cmds.append(str(k))
		append_line("OS Commands      : " + ", ".join(os_cmds))
		if _profile and _profile.id == "evga_sr2":
			append_line("SR-2 Commands    : switch-win7, switch-lion, switch-solaris, bbs")
		append_line("System Commands  : help, clear/cls, neofetch, date, whoami, floppy, reboot, exit")
		return

	# Universal neofetch / sysinfo
	if lower == "neofetch" or lower == "sysinfo":
		if _profile:
			append_line("==========================================================")
			append_line("  OS      : " + _profile.display_name + " (" + _profile.release_year + ")")
			append_line("  Vendor  : " + _profile.vendor)
			append_line("  Kernel  : " + _profile.architecture_summary)
			append_line("  Machine : " + _profile.hardware_profile)
			append_line("  Shell   : " + _profile.terminal_title)
			append_line("==========================================================")
		return

	if lower == "date" or lower == "time":
		append_line(Time.get_datetime_string_from_system(false, true))
		return

	if lower == "whoami":
		if _profile:
			match _profile.id:
				"dec_pdp7":
					append_line("ken")
				"datapoint_2200":
					append_line("OPERATOR 1 (LOCAL CONSOLE)")
				"ubuntu_704":
					append_line("user")
				"ubuntu_1004":
					append_line("alex")
				"hpux_cde":
					append_line("root")
				"plan9":
					append_line("glenda")
				"win98_se":
					append_line("C:\\WINDOWS\\USER")
				"os2_warp":
					append_line("WARP_ADMIN")
				"winxp_alienware":
					append_line("area51-predator\\Area51")
				"sgi_irix":
					append_line("vfx")
				"evga_sr2":
					if GameState.sr2_active_os == "lion":
						append_line("admin")
					elif GameState.sr2_active_os == "solaris":
						append_line("root")
					else:
						append_line("SR-2-SUPERRECORD\\OverclockAdmin")
				_:
					append_line("operator")
		return

	if lower.begins_with("echo "):
		append_line(cmd.substr(5))
		return

	if lower.begins_with("sudo "):
		append_line("[sudo] password for user: ********\nPermission granted. Executing: " + cmd.substr(5))
		_execute_command(cmd.substr(5).strip_edges())
		return

	# Period-accurate "command not found" message per OS family
	if _profile:
		match _profile.id:
			"win98_se":
				append_line("Bad command or file name")
			"winxp_alienware":
				append_line("'" + cmd.split(" ")[0] + "' is not recognized as an internal or external command,\noperable program or batch file.")
			"os2_warp":
				append_line("SYS1041: The name " + cmd.split(" ")[0] + " is not recognized as an\ninternal or external command, operable program or batch file.")
			"plan9":
				append_line("rc: " + cmd.split(" ")[0] + ": './" + cmd.split(" ")[0] + "' does not exist")
			"hpux_cde", "solaris_8", "sco_openserver":
				append_line("sh: " + cmd.split(" ")[0] + ":  not found.")
			"sgi_irix", "freebsd_411", "nextstep_33", "macosx_g4":
				append_line("tcsh: " + cmd.split(" ")[0] + ": Command not found.")
			"mac_sys75":
				append_line("### MPW Shell - Command \"" + cmd.split(" ")[0] + "\" was not found.")
			"amiga_os31":
				append_line(cmd.split(" ")[0] + ": Unknown command")
			"apple_iie":
				append_line("?SYNTAX ERROR")
			"datapoint_2200":
				append_line("ERROR: UNKNOWN COMMAND OR FILE")
			"dec_pdp7":
				AudioManager.play_teletype_clatter()
				append_line("?")
			"evga_sr2":
				if GameState.sr2_active_os == "lion":
					append_line("-bash: " + cmd.split(" ")[0] + ": command not found")
				elif GameState.sr2_active_os == "solaris":
					append_line("ksh93: " + cmd.split(" ")[0] + ": not found [No such file or directory]")
				else:
					append_line("'" + cmd.split(" ")[0] + "' is not recognized as an internal or external command,\noperable program or batch file.")
			_:
				append_line("bash: " + cmd.split(" ")[0] + ": command not found")
	else:
		append_line("Unknown command: " + cmd)

