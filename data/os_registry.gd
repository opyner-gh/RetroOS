class_name RetroOSRegistry
extends RefCounted
## Central registry for all available Operating System profiles in RetroOS.
## Provides the 20 built-in historical operating systems and automatically discovers
## any additional `.tres` OSProfile resources placed in `res://data/profiles/`.

const OSProfile = preload("res://data/os_profile.gd")
const CatalogUnixBeos = preload("res://data/catalog_unix_beos.gd")
const CatalogMacRetro = preload("res://data/catalog_mac_retro.gd")
const ExhibitCodex = preload("res://data/exhibit_codex.gd")
const CUSTOM_PROFILES_DIR := "res://data/profiles"

static func get_all_profiles() -> Array[OSProfile]:
	var profiles: Array[OSProfile] = [
		_build_datapoint_2200(),
		_build_ubuntu_704(),
		_build_ubuntu_1004(),
		_build_evga_sr2(),
		_build_hpux_cde(),
		_build_plan9(),
		_build_win98_se(),
		_build_os2_warp(),
		_build_winxp_alienware(),
		_build_sgi_irix(),
	]
	profiles.append_array(CatalogUnixBeos.get_profiles())
	profiles.append_array(CatalogMacRetro.get_profiles())

	# Discover any drop-in OSProfile .tres resources for easy future expansion
	if DirAccess.dir_exists_absolute(CUSTOM_PROFILES_DIR):
		var dir := DirAccess.open(CUSTOM_PROFILES_DIR)
		if dir:
			dir.list_dir_begin()
			var file_name := dir.get_next()
			while file_name != "":
				if not dir.current_is_dir() and file_name.ends_with(".tres"):
					var full_path := CUSTOM_PROFILES_DIR.path_join(file_name)
					var res := ResourceLoader.load(full_path)
					if res is OSProfile:
						profiles.append(res)
				file_name = dir.get_next()
			dir.list_dir_end()

	# Populate comprehensive Museum Exhibit & Codex Packages for all systems
	for p in profiles:
		ExhibitCodex.enrich_profile(p)

	# Sort chronological: earliest/oldest at top (ascending), newest/latest at bottom
	profiles.sort_custom(func(a: OSProfile, b: OSProfile) -> bool:
		var year_a := a.release_year.to_int()
		var year_b := b.release_year.to_int()
		if year_a != year_b:
			return year_a < year_b
		return a.display_name < b.display_name
	)

	return profiles


static func get_profile_by_id(os_id: String) -> OSProfile:
	var builder_map: Dictionary = {
		"datapoint_2200": _build_datapoint_2200,
		"ubuntu_704": _build_ubuntu_704,
		"ubuntu_1004": _build_ubuntu_1004,
		"evga_sr2": _build_evga_sr2,
		"hpux_cde": _build_hpux_cde,
		"hpux_11i": _build_hpux_cde,
		"plan9": _build_plan9,
		"plan9_rio": _build_plan9,
		"win98_se": _build_win98_se,
		"os2_warp": _build_os2_warp,
		"os2_warp4": _build_os2_warp,
		"winxp_alienware": _build_winxp_alienware,
		"sgi_irix": _build_sgi_irix,
		"sgi_irix65": _build_sgi_irix,
		"beos_r5": CatalogUnixBeos._build_beos_r5,
		"nextstep_33": CatalogUnixBeos._build_nextstep_33,
		"solaris_8": CatalogUnixBeos._build_solaris_8,
		"redhat_62": CatalogUnixBeos._build_redhat_62,
		"freebsd_411": CatalogUnixBeos._build_freebsd_411,
		"sco_openserver": CatalogUnixBeos._build_sco_openserver,
		"mac_sys75": CatalogMacRetro._build_mac_sys75,
		"macosx_g4": CatalogMacRetro._build_macosx_g4,
		"amiga_os31": CatalogMacRetro._build_amiga_os31,
		"apple_iie": CatalogMacRetro._build_apple_iie,
	}

	var p: OSProfile = null
	if builder_map.has(os_id):
		p = builder_map[os_id].call()
	else:
		# Discover any drop-in OSProfile .tres resources for custom/mod profiles
		if DirAccess.dir_exists_absolute(CUSTOM_PROFILES_DIR):
			var custom_path := CUSTOM_PROFILES_DIR.path_join(os_id + ".tres")
			if FileAccess.file_exists(custom_path):
				var res := ResourceLoader.load(custom_path)
				if res is OSProfile:
					p = res

	if not p:
		p = _build_datapoint_2200()

	ExhibitCodex.enrich_profile(p)
	return p


# ==============================================================================
# 1. UBUNTU 7.04 (FEISTY FAWN) - APRIL 2007
# ==============================================================================
static func _build_ubuntu_704() -> OSProfile:
	var p := OSProfile.new()
	p.id = "ubuntu_704"
	p.category = "UNIX & Alt-OS"
	p.display_name = "Ubuntu 7.04 (Feisty Fawn)"
	p.short_name = "Ubuntu 7.04"
	p.release_year = "2007"
	p.has_crt = false
	p.aspect_ratio = "4:3"
	p.vendor = "Canonical Ltd."
	p.architecture_summary = "i686 • Linux 2.6.20-15-generic • GNOME 2.18.1 (Human Theme)"
	p.hardware_profile = "Dell OptiPlex GX620 • Intel Core 2 Duo E6400 @ 2.13GHz • 1024MB DDR2"
	p.description = (
		"The golden era of warm brown desktop Linux. Features GNOME 2.18 with the signature "
		+ "'Human' clearlooks-glossy theme, Compiz desktop effects readiness, HAL/udev hardware "
		+ "discovery, and African percussion login acoustics."
	)

	p.bios_header = (
		"PhoenixBIOS 4.0 Release 6.0                     Copyright 1985-2006 Phoenix Technologies Ltd.\n"
		+ "Dell System OptiPlex GX620 Series               BIOS version A11 (11/30/2006)"
	)
	p.boot_bg_color = Color("060504")
	p.boot_text_color = Color("d8d4cc")
	p.boot_logs = [
		{"text": "CPU = Intel(R) Core(TM)2 CPU 6400 @ 2.13GHz", "delay": 0.95, "sfx": "fan_spinup", "color": "#e0e0e0"},
		{"text": "1024M System RAM Passed  (DDR2-667 Dual Channel Interleaved)", "delay": 1.35, "sfx": "beep", "color": "#e0e0e0"},
		{"text": "Primary SATA 0: WDC WD1600JS-75NCB3 160.0GB Ultra DMA Mode 5", "delay": 1.10, "sfx": "hdd_click", "color": "#b8b8b8"},
		{"text": "Floppy Disk Controller: TEAC FD-235HF 1.44MB 3.5\"", "delay": 1.55, "sfx": "floppy", "color": "#b8b8b8"},
		{"text": "", "delay": 0.45, "sfx": "", "color": ""},
		{"text": "GRUB Loading stage1.5.", "delay": 1.15, "sfx": "hdd_click", "color": "#ffffff"},
		{"text": "GRUB loading, please wait...", "delay": 1.30, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "Booting 'Ubuntu, kernel 2.6.20-15-generic'", "delay": 0.90, "sfx": "", "color": "#f59e42"},
		{"text": "root (hd0,0)  Filesystem type is ext2fs, partition type 0x83", "delay": 0.65, "sfx": "hdd_click", "color": "#c8c8c8"},
		{"text": "kernel /boot/vmlinuz-2.6.20-15-generic root=UUID=4a8b-991c ro quiet splash", "delay": 0.75, "sfx": "", "color": "#c8c8c8"},
		{"text": "initrd /boot/initrd.img-2.6.20-15-generic", "delay": 1.40, "sfx": "hdd_burst", "color": "#c8c8c8"},
		{"text": "Uncompressing Linux... Ok, booting the kernel.", "delay": 1.65, "sfx": "", "color": "#ffffff"},
		{"text": "[    0.000000] Linux version 2.6.20-15-generic (root@palmer) (gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu4))", "delay": 0.55, "sfx": "", "color": "#9ec49e"},
		{"text": "[    0.148912] ACPI: Core revision 20060707", "delay": 0.45, "sfx": "", "color": "#a8a8a8"},
		{"text": "[    0.891204] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]", "delay": 0.85, "sfx": "hdd_click", "color": "#a8a8a8"},
		{"text": "[    1.421008] kjournald starting.  Commit interval 5 seconds", "delay": 1.15, "sfx": "hdd_burst", "color": "#a8a8a8"},
		{"text": "[    1.429410] EXT3-fs: mounted filesystem with ordered data mode.", "delay": 0.80, "sfx": "", "color": "#a8a8a8"},
		{"text": " * Loading hardware drivers (udev)...                                   [ OK ]", "delay": 1.25, "sfx": "hdd_click", "color": "#e8b878"},
		{"text": " * Mounting local filesystems...                                        [ OK ]", "delay": 1.10, "sfx": "hdd_burst", "color": "#e8b878"},
		{"text": " * Configuring network interfaces (eth0: e1000 1000Mbps Full-Duplex)... [ OK ]", "delay": 1.20, "sfx": "", "color": "#e8b878"},
		{"text": " * Starting Hardware Abstraction Layer (hald)...                        [ OK ]", "delay": 1.05, "sfx": "hdd_click", "color": "#e8b878"},
		{"text": " * Starting GNOME Display Manager (gdm)...                              [ OK ]", "delay": 1.60, "sfx": "hdd_burst", "color": "#ff9933"}
	]

	p.chrome_style = "gnome_human"
	p.desktop_bg_color = Color("6b4226")
	p.desktop_secondary_color = Color("9c5930")
	p.panel_bg_color = Color("ede9e3")
	p.panel_text_color = Color("2b241e")
	p.window_bg_color = Color("f2efeb")
	p.window_text_color = Color("221e1a")
	p.window_border_color = Color("5c3d28")
	p.titlebar_active_color = Color("d97a36")
	p.titlebar_active_gradient_end = Color("a8531b")
	p.titlebar_inactive_color = Color("b8afa6")
	p.titlebar_text_color = Color("ffffff")
	p.accent_color = Color("e6782b")

	p.terminal_title = "user@feisty-desktop: ~"
	p.terminal_bg_color = Color("ffffff")
	p.terminal_fg_color = Color("1f1916")
	p.terminal_prompt = "user@feisty-desktop:~$ "
	p.terminal_welcome_banner = (
		"Linux feisty-desktop 2.6.20-15-generic #2 SMP Sun Apr 15 07:36:31 UTC 2007 i686\n"
		+ "To run a command as administrator (user \"root\"), use \"sudo <command>\".\n"
		+ "See \"man sudo_root\" for details. Type 'help' for simulator commands."
	)
	p.terminal_commands = {
		"uname -a": "Linux feisty-desktop 2.6.20-15-generic #2 SMP Sun Apr 15 07:36:31 UTC 2007 i686 GNU/Linux",
		"lsb_release -a": "No LSB modules are available.\nDistributor ID: Ubuntu\nDescription:    Ubuntu 7.04\nRelease:        7.04\nCodename:       feisty",
		"cat /etc/issue": "Ubuntu 7.04 \\n \\l",
		"ls": "Desktop  Documents  Examples  Music  Pictures  ubuntu-feisty-tour.ogg  xorg.conf.bak",
		"ls -la": (
			"total 36\n"
			+ "drwxr-xr-x 14 user user 4096 2007-04-19 09:12 .\n"
			+ "drwxr-xr-x  3 root root 4096 2007-04-19 08:40 ..\n"
			+ "-rw-r--r--  1 user user 2227 2007-04-19 08:40 .bashrc\n"
			+ "drwxr-xr-x  2 user user 4096 2007-04-19 09:00 Desktop\n"
			+ "lrwxrwxrwx  1 user user   26 2007-04-19 08:40 Examples -> /usr/share/example-content"
		),
		"free -m": (
			"             total       used       free     shared    buffers     cached\n"
			+ "Mem:          1011        284        727          0         38        142\n"
			+ "-/+ buffers/cache:        104        907\n"
			+ "Swap:         2047          0       2047"
		),
		"df -h": (
			"Filesystem            Size  Used Avail Use% Mounted on\n"
			+ "/dev/sda1             145G  3.2G  135G   3% /\n"
			+ "varrun                506M  112K  506M   1% /var/run\n"
			+ "udev                  506M   24K  506M   1% /dev"
		),
		"apt-get moo": (
			"         (__)\n"
			+ "         (oo)\n"
			+ "   /------\\/\n"
			+ "  / |    ||\n"
			+ " *  /\\---/\\\n"
			+ "    ~~   ~~\n"
			+ "....\"Have you mooed today?\"..."
		),
		"ps aux": (
			"USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND\n"
			+ "root         1  0.0  0.1   2948  1852 ?        Ss   01:18   0:01 /sbin/init\n"
			+ "root      4120  0.8  2.4  32840 24912 tty7     Ss+  01:19   0:03 /usr/bin/X :0 -br\n"
			+ "user      4388  0.2  1.5  44120 15400 ?        Ss   01:19   0:00 gnome-session\n"
			+ "user      4432  0.1  1.8  58204 18920 ?        S    01:19   0:01 gnome-panel\n"
			+ "user      4436  0.1  1.6  61200 16400 ?        S    01:19   0:00 nautilus --no-default-window\n"
			+ "user      4510  0.3  2.1  48912 21400 ?        Sl   01:19   0:01 gnome-terminal"
		)
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "user@feisty-desktop: ~",
			"type": "terminal",
			"pos": Vector2(120, 74),
			"size": Vector2(560, 360),
			"content": ""
		},
		{
			"id": "sysmon",
			"title": "System Monitor (gnome-system-monitor)",
			"type": "monitor",
			"pos": Vector2(510, 400),
			"size": Vector2(460, 270),
			"content": (
				"feisty-desktop (Ubuntu 7.04)\n"
				+ "GNOME 2.18.1 • Kernel 2.6.20-15-generic\n\n"
				+ "CPU0 (Core 2 Duo E6400): [||||................]  18%\n"
				+ "CPU1 (Core 2 Duo E6400): [||..................]  11%\n"
				+ "User Memory:             [|||||...............] 284 MB / 1011 MB\n"
				+ "Used Swap:               [....................]   0 MB / 2047 MB\n"
				+ "Network (eth0 e1000):    Rx: 1.4 KiB/s   Tx: 0.3 KiB/s"
			)
		},
		{
			"id": "about",
			"title": "Examples - Nautilus File Browser",
			"type": "files",
			"pos": Vector2(58, 430),
			"size": Vector2(420, 240),
			"content": (
				"Location: /home/user/Examples\n"
				+ "----------------------------------------------------\n"
				+ "[Audio]  Experience ubuntu.ogg  (Nelson Mandela clip)\n"
				+ "[Doc]    oo-welcome.odt         (OpenOffice.org 2.2)\n"
				+ "[Doc]    ubuntu-book.pdf        (Official Ubuntu Book)\n"
				+ "[Image]  ubuntu-logo.svg        (Circle of Friends)\n"
				+ "----------------------------------------------------\n"
				+ "4 items, Free space: 135.2 GB (ext3)"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_term", "label": "Terminal", "glyph": "[>_]", "target_window_id": "terminal"},
		{"id": "icon_examples", "label": "Examples", "glyph": "[DIR]", "target_window_id": "about"},
		{"id": "icon_sysmon", "label": "System\nMonitor", "glyph": "[CPU]", "target_window_id": "sysmon"}
	]

	p.fan_base_freq = 105.0
	p.fan_noise_level = 0.20
	p.hdd_seek_interval_range = Vector2(3.5, 8.0)
	return p


# ==============================================================================
# 2. HP-UX 11i (CDE - COMMON DESKTOP ENVIRONMENT) - c. 2000
# ==============================================================================
static func _build_hpux_cde() -> OSProfile:
	var p := OSProfile.new()
	p.id = "hpux_cde"
	p.category = "UNIX & Alt-OS"
	p.display_name = "HP-UX 11i (CDE Workstation)"
	p.short_name = "HP-UX (CDE)"
	p.release_year = "2000"
	p.has_crt = true
	p.aspect_ratio = "4:3"
	p.vendor = "Hewlett-Packard Company"
	p.architecture_summary = "PA-RISC 2.0 (PA-8600) • HP-UX B.11.11 • Common Desktop Environment 2.1"
	p.hardware_profile = "HP 9000 Visualize C3600 • PA-8600 @ 552MHz • 1024MB ECC • Ultra2 SCSI"
	p.description = (
		"Heavy-iron UNIX engineering workstation running Hewlett-Packard's HP-UX 11i and "
		+ "the Motif-based Common Desktop Environment (CDE). Chiseled 3D bevels, docked "
		+ "Front Panel workspace switcher, and high-RPM Ultra2 SCSI disk acoustics."
	)

	p.bios_header = (
		"Hewlett-Packard Company               HP VISUALIZE C3600 Workstation\n"
		+ "Processor Dependent Code (PDC)        Firmware Revision 41.29"
	)
	p.boot_bg_color = Color("040a10")
	p.boot_text_color = Color("d0e4f0")
	p.boot_logs = [
		{"text": "Duplex Console IO Dependent Code (IODC) revision 1", "delay": 1.05, "sfx": "fan_spinup", "color": "#d0e4f0"},
		{"text": "Memory Test/Initialization Completed: 1024 MB ECC RAM OK", "delay": 1.50, "sfx": "beep", "color": "#88d8b0"},
		{"text": "Searching for potential boot devices (Fast-Wide Ultra2 LVD SCSI)...", "delay": 1.65, "sfx": "hdd_burst", "color": "#d0e4f0"},
		{"text": "   P0  scsi.6.0   SEAGATE ST318404LW (18.2 GB 10,000 RPM)", "delay": 1.10, "sfx": "hdd_click", "color": "#ffffff"},
		{"text": "Booting from: scsi.6.0 (10/0/15/1.6.0)", "delay": 1.00, "sfx": "hdd_click", "color": "#d0e4f0"},
		{"text": "ISL Revision A.00.43  Oct 12, 1999", "delay": 0.90, "sfx": "", "color": "#ffd080"},
		{"text": "ISL> hpux /stand/vmunix", "delay": 1.45, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "Boot: disc0(10/0/15/1.6.0.0.0.0.0;0)/stand/vmunix", "delay": 1.15, "sfx": "hdd_click", "color": "#b8d0e0"},
		{"text": "7946240 + 1835008 + 1142768 start 0x196528", "delay": 1.40, "sfx": "hdd_burst", "color": "#b8d0e0"},
		{"text": "NOTICE:escsi: Adapter at 10/0/15/1 initialized (Symbios 53C896)", "delay": 0.75, "sfx": "", "color": "#98b8c8"},
		{"text": "Logical Volume Manager: vg00 activated (8 logical volumes).", "delay": 1.15, "sfx": "hdd_click", "color": "#98b8c8"},
		{"text": "Checking VxFS filesystems (/dev/vg00/lvol3 : clean)...", "delay": 1.25, "sfx": "hdd_burst", "color": "#98b8c8"},
		{"text": "System Console is on the Built-In FXeVisualize PCI Graphics", "delay": 0.85, "sfx": "", "color": "#d0e4f0"},
		{"text": "Starting HP-UX System V Run-Level 3 Services...", "delay": 1.10, "sfx": "hdd_click", "color": "#ffd080"},
		{"text": "   Initialize Software Distributor Agent (swagentd) ............. [  OK  ]", "delay": 0.95, "sfx": "hdd_click", "color": "#88d8b0"},
		{"text": "   Start RPC portmapper & NFS client subsystem .................. [  OK  ]", "delay": 0.90, "sfx": "", "color": "#88d8b0"},
		{"text": "   Start X11 Font Server (xfs) & Print Spooler .................. [  OK  ]", "delay": 0.95, "sfx": "hdd_click", "color": "#88d8b0"},
		{"text": "   Starting CDE Login Server (/usr/dt/bin/dtlogin) .............. [  OK  ]", "delay": 1.65, "sfx": "hdd_burst", "color": "#88d8b0"}
	]

	p.chrome_style = "motif_cde"
	p.desktop_bg_color = Color("3a606e")
	p.desktop_secondary_color = Color("2c4a56")
	p.panel_bg_color = Color("9aa2aa")
	p.panel_text_color = Color("14181c")
	p.window_bg_color = Color("aeb6be")
	p.window_text_color = Color("111518")
	p.window_border_color = Color("e2e8ee")
	p.titlebar_active_color = Color("b56576")
	p.titlebar_active_gradient_end = Color("9e5263")
	p.titlebar_inactive_color = Color("7b858e")
	p.titlebar_text_color = Color("ffffff")
	p.accent_color = Color("b56576")

	p.terminal_title = "dtterm - hp9000:/home/root"
	p.terminal_bg_color = Color("1f262e")
	p.terminal_fg_color = Color("e6eef5")
	p.terminal_prompt = "hp9000:/home/root # "
	p.terminal_welcome_banner = (
		"(c)Copyright 1983-2000 Hewlett-Packard Co., All Rights Reserved.\n"
		+ "HP-UX hp9000 B.11.11 U 9000/785 (ta)\n"
		+ "You have mail in /var/mail/root. Type 'help' for simulator commands."
	)
	p.terminal_commands = {
		"uname -a": "HP-UX hp9000 B.11.11 U 9000/785 2010948215 unlimited-user license",
		"model": "9000/785/C3600",
		"bdf": (
			"Filesystem          kbytes    used   avail %used Mounted on\n"
			+ "/dev/vg00/lvol3     524288  142816  357624   29% /\n"
			+ "/dev/vg00/lvol1     196608   41200  135744   23% /stand\n"
			+ "/dev/vg00/lvol7    4194304 1892104 2158312   47% /usr\n"
			+ "/dev/vg00/lvol8    8388608 2140112 5857960   27% /home"
		),
		"ioscan -fn": (
			"Class     I  H/W Path       Driver    S/W State   H/W Type     Description\n"
			+ "==========================================================================\n"
			+ "processor 0  160            processor CLAIMED     PROCESSOR    PA-8600 CPU\n"
			+ "memory    0  192            memory    CLAIMED     MEMORY       1024 MB ECC\n"
			+ "ext_bus   0  10/0/15/1      c720      CLAIMED     INTERFACE    SCSI C896 Ultra2\n"
			+ "disk      0  10/0/15/1.6.0  sdisk     CLAIMED     DEVICE       SEAGATE ST318404LW\n"
			+ "lan       0  10/0/12/0      btlan     CLAIMED     INTERFACE    HP PCI 10/100Base-TX\n"
			+ "graphics  0  10/1/0/0       graph3    CLAIMED     INTERFACE    HP VISUALIZE-FXe"
		),
		"swapinfo": (
			"             Kb      Kb      Kb   PCT  START/      Kb\n"
			+ "TYPE      AVAIL    USED    FREE  USED   LIMIT RESERVE  PRI  NAME\n"
			+ "dev     2097152       0 2097152    0%       0       -    1  /dev/vg00/lvol2\n"
			+ "reserve       -  184320 -184320\n"
			+ "memory   812400  142100  670300   17%"
		),
		"sam": (
			"HP-UX System Administration Manager (SAM) [Terminal Summary]\n"
			+ "  -> Accounts for Users and Groups\n"
			+ "  -> Auditing and Security\n"
			+ "  -> Disks and File Systems (VxFS / LVM)\n"
			+ "  -> Kernel Configuration (/stand/system)\n"
			+ "  -> Peripheral Devices & Printers"
		),
		"ls": "Mail  SAM.log  cad_models  core  dtprofile  vmunix.bak"
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "dtterm - hp9000:/home/root",
			"type": "terminal",
			"pos": Vector2(85, 52),
			"size": Vector2(560, 350),
			"content": ""
		},
		{
			"id": "sam",
			"title": "System Administration Manager (SAM) - hp9000",
			"type": "monitor",
			"pos": Vector2(530, 310),
			"size": Vector2(440, 300),
			"content": (
				"HP 9000 Visualize C3600 Status\n"
				+ "========================================\n"
				+ "[ icon ] Accounts for Users and Groups\n"
				+ "[ icon ] Disks and File Systems (vg00)\n"
				+ "[ icon ] Kernel Configuration (vmunix)\n"
				+ "[ icon ] Networking and Communications\n"
				+ "[ icon ] Performance Monitors (GlancePlus)\n"
				+ "----------------------------------------\n"
				+ "PA-8600 @ 552 MHz | Load Avg: 0.08, 0.04, 0.01\n"
				+ "SCSI Bus 10/0/15/1: SEAGATE 10K RPM Online"
			)
		},
		{
			"id": "dtpad",
			"title": "Text Editor (dtpad) - /etc/motd",
			"type": "text",
			"pos": Vector2(60, 415),
			"size": Vector2(430, 210),
			"content": (
				"********************************************************\n"
				+ "*  HP VISUALIZE C3600 ENGINEERING WORKSTATION (HP-UX)  *\n"
				+ "*  Common Desktop Environment (CDE) 2.1 / Motif 2.1    *\n"
				+ "********************************************************\n"
				+ "CAD/CAE NFS mounts active on /net/mentor and /net/catia.\n"
				+ "Use 'ioscan -fn' or 'bdf' in dtterm to inspect storage."
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_dtterm", "label": "dtterm", "glyph": "[>_]", "target_window_id": "terminal"},
		{"id": "icon_sam", "label": "SAM Admin", "glyph": "[SAM]", "target_window_id": "sam"},
		{"id": "icon_dtpad", "label": "dtpad", "glyph": "[TXT]", "target_window_id": "dtpad"}
	]

	p.fan_base_freq = 148.0
	p.fan_noise_level = 0.34
	p.hdd_seek_interval_range = Vector2(2.0, 5.2)
	return p


# ==============================================================================
# 3. PLAN 9 FROM BELL LABS (4TH EDITION / RIO) - c. 2002
# ==============================================================================
static func _build_plan9() -> OSProfile:
	var p := OSProfile.new()
	p.id = "plan9"
	p.category = "UNIX & Alt-OS"
	p.display_name = "Plan 9 from Bell Labs (4th Ed.)"
	p.short_name = "Plan 9"
	p.release_year = "2002"
	p.has_crt = true
	p.aspect_ratio = "4:3"
	p.vendor = "Bell Labs / Lucent Technologies"
	p.architecture_summary = "386 (9pcf) • 9P2000 Protocol • rio Window System • rc Shell"
	p.hardware_profile = "Bell Labs 9pc Terminal • Pentium III 733MHz • 256MB RAM • 3Com 3C905C"
	p.description = (
		"Everything is a file—including the network, graphics, and window manager. Features "
		+ "Rob Pike's minimalist 'rio' window environment with pale cream windows, cyan borders, "
		+ "Tom Duff's 'rc' shell, and live per-process namespace tables."
	)

	p.bios_header = (
		"Plan 9 from Bell Labs — 9load bootstrap loader\n"
		+ "Lucent Technologies / Bell Labs Computing Sciences Research Center"
	)
	p.boot_bg_color = Color("0c0e0e")
	p.boot_text_color = Color("d8e8e4")
	p.boot_logs = [
		{"text": "PBS1... Plan 9 from Bell Labs", "delay": 1.10, "sfx": "fan_spinup", "color": "#ffffff"},
		{"text": "ELCR: 0E00", "delay": 0.90, "sfx": "beep", "color": "#b0c8c4"},
		{"text": "dev A0 port 1F0 config 045A capabilities 2F00 mwdma 0007 udma 043F", "delay": 1.15, "sfx": "hdd_click", "color": "#b0c8c4"},
		{"text": "fd0: 3.5\" HD 1.44MB floppy controller initialized", "delay": 1.60, "sfx": "floppy", "color": "#b0c8c4"},
		{"text": "using sdC0!9fat!plan9.ini", "delay": 1.05, "sfx": "hdd_click", "color": "#88d8d0"},
		{"text": ".684210+291044+120416=1095670", "delay": 1.50, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "entry: 0x80100020", "delay": 0.70, "sfx": "", "color": "#b0c8c4"},
		{"text": "Plan 9", "delay": 1.00, "sfx": "", "color": "#55dddd"},
		{"text": "cpu0: 733MHz GenuineIntel Pentium III (cpuid: AX 0x0686 DX 0x0383FBFF)", "delay": 0.85, "sfx": "", "color": "#d8e8e4"},
		{"text": "#l0: elnk3: 100Mbps port 0xDC00 irq 11: 00010289a4c1", "delay": 0.80, "sfx": "", "color": "#d8e8e4"},
		{"text": "256M memory: 104M kernel data, 152M user, 384M swap", "delay": 0.95, "sfx": "hdd_click", "color": "#d8e8e4"},
		{"text": "root is from (tcp, local)[local!#S/sdC0/fossil]: ", "delay": 1.40, "sfx": "hdd_click", "color": "#ffffaa"},
		{"text": "user[glenda]: glenda", "delay": 1.15, "sfx": "", "color": "#ffffaa"},
		{"text": "fossil(#S/sdC0/fossil)...version...time...", "delay": 1.55, "sfx": "hdd_burst", "color": "#88d8d0"},
		{"text": "init: starting /bin/rc", "delay": 1.05, "sfx": "hdd_click", "color": "#ffffff"},
		{"text": "rio -i riostart", "delay": 1.40, "sfx": "hdd_burst", "color": "#55dddd"}
	]

	p.chrome_style = "plan9_rio"
	p.desktop_bg_color = Color("777777")
	p.desktop_secondary_color = Color("666666")
	p.panel_bg_color = Color("e8f4f4")
	p.panel_text_color = Color("000000")
	p.window_bg_color = Color("ffffea")
	p.window_text_color = Color("000000")
	p.window_border_color = Color("55aaaa")
	p.titlebar_active_color = Color("55aaaa")
	p.titlebar_active_gradient_end = Color("55aaaa")
	p.titlebar_inactive_color = Color("9eeeee")
	p.titlebar_text_color = Color("002b2b")
	p.accent_color = Color("448888")

	p.terminal_title = "rc (rio /dev/cons)"
	p.terminal_bg_color = Color("ffffea")
	p.terminal_fg_color = Color("111111")
	p.terminal_prompt = "term% "
	p.terminal_welcome_banner = (
		"Plan 9 from Bell Labs (Fourth Edition)\n"
		+ "cpu0: 733MHz GenuineIntel Pentium III | fs: #S/sdC0/fossil\n"
		+ "Right-click anywhere on the grey desktop for the rio window menu.\n"
		+ "Type 'lc', 'cat /dev/drivers', 'fortune', or 'help'."
	)
	p.terminal_commands = {
		"lc": "bin/      lib/      profile   readme.9  src/      tmp/",
		"cat /dev/osversion": "2000",
		"cat /dev/sysname": "alef",
		"cat /dev/user": "glenda",
		"cat /dev/drivers": (
			"#c cons\n"
			+ "#e env\n"
			+ "#i draw\n"
			+ "#l ether\n"
			+ "#m mouse\n"
			+ "#p proc\n"
			+ "#s srv\n"
			+ "#I ip\n"
			+ "#S sd"
		),
		"ps": (
			"glenda          1    0:00   0:00      128K Pread    init\n"
			+ "glenda          5    0:00   0:02     1840K Pread    fossil\n"
			+ "glenda         14    0:01   0:01      912K Pread    rio\n"
			+ "glenda         16    0:00   0:00      420K Pread    stats\n"
			+ "glenda         19    0:00   0:00      680K Pread    acme\n"
			+ "glenda         22    0:00   0:00      340K Pread    rc"
		),
		"ns": (
			"bind /root /\n"
			+ "mount -a #s/boot /root\n"
			+ "bind #c /dev\n"
			+ "bind -a #i /dev\n"
			+ "bind -a #m /dev\n"
			+ "mount -b /srv/rio.glenda.14 /dev"
		),
		"fortune": "\"UNIX is basically a simple operating system, but you have to be a genius to understand the simplicity.\" — Dennis Ritchie",
		"glenda": (
			"   (\\_/)\n"
			+ "   (o.o)   Glenda, the Plan 9 Bunny\n"
			+ "   (> <)   http://plan9.bell-labs.com"
		)
	}

	p.default_windows = [
		{
			"id": "stats",
			"title": "stats -lmisce",
			"type": "monitor",
			"pos": Vector2(28, 28),
			"size": Vector2(310, 210),
			"content": (
				"alef (Plan 9 4e)\n"
				+ "load    [||..................] 0.12\n"
				+ "mem     [||||||..............] 42/152M\n"
				+ "intr    [|||.................] 240/s\n"
				+ "syscall [||||................] 610/s\n"
				+ "context [||..................] 180/s\n"
				+ "ether   [|...................]   4pkt"
			)
		},
		{
			"id": "acme",
			"title": "acme - /usr/glenda/readme.9",
			"type": "text",
			"pos": Vector2(358, 28),
			"size": Vector2(610, 220),
			"content": (
				"New Cut Paste Snarf Sort Zerox Delcol | Look \n"
				+ "/usr/glenda/readme.9 Del Snarf Undo | Put \n"
				+ "------------------------------------------------------------\n"
				+ "Welcome to Plan 9 from Bell Labs.\n"
				+ "In Plan 9, every resource—whether local or across the network—\n"
				+ "is represented as a hierarchical file system speaking 9P2000.\n"
				+ "Windows in 'rio' have pale yellow-cream backgrounds (#FFFFEA)\n"
				+ "and 4-pixel cyan borders (#55AAAA)."
			)
		},
		{
			"id": "terminal",
			"title": "rc",
			"type": "terminal",
			"pos": Vector2(180, 270),
			"size": Vector2(640, 390),
			"content": ""
		}
	]

	p.desktop_icons = [
		{"id": "icon_rc", "label": "New rc", "glyph": "[rc]", "target_window_id": "terminal"},
		{"id": "icon_stats", "label": "stats", "glyph": "[||]", "target_window_id": "stats"},
		{"id": "icon_acme", "label": "acme", "glyph": "[ed]", "target_window_id": "acme"}
	]

	p.fan_base_freq = 98.0
	p.fan_noise_level = 0.22
	p.hdd_seek_interval_range = Vector2(3.0, 6.8)
	return p


# ==============================================================================
# 4. MICROSOFT WINDOWS 98 SECOND EDITION (4.10.2222 A) - MAY 1999
# ==============================================================================
static func _build_win98_se() -> OSProfile:
	var p := OSProfile.new()
	p.id = "win98_se"
	p.category = "PC & OS/2"
	p.display_name = "Windows 98 Second Edition"
	p.short_name = "Windows 98 SE"
	p.release_year = "1999"
	p.has_crt = true
	p.aspect_ratio = "4:3"
	p.has_energy_star_badge = true
	p.vendor = "Microsoft Corporation"
	p.architecture_summary = "x86 • MS-DOS 7.10 / Win32 VMM 4.10.2222 A • Explorer Shell"
	p.hardware_profile = "Intel Pentium III 500MHz • 128MB PC100 SDRAM • 3dfx Voodoo3 3000 AGP"
	p.description = (
		"Peak late-90s consumer PC nostalgia. Classic #008080 Teal desktop, crisp 3D beveled "
		+ "#C0C0C0 Win32 controls, navy-to-cerulean gradient titlebars, Sound Blaster Live! "
		+ "initialization, and Quantum Fireball IDE hard drive chatter."
	)

	p.bios_header = (
		"Award Modular BIOS v4.51PG, An Energy Star Ally\n"
		+ "Copyright (C) 1984-99, Award Software, Inc.   Intel 440BX AGPSet BIOS v1.09"
	)
	p.boot_bg_color = Color("000000")
	p.boot_text_color = Color("c0c0c0")
	p.boot_logs = [
		{"text": "Main Processor : Intel Pentium(R) III 500MHz", "delay": 1.00, "sfx": "fan_spinup", "color": "#e0e0e0"},
		{"text": "Memory Testing : 131072K OK", "delay": 1.55, "sfx": "beep", "color": "#ffffff"},
		{"text": "Award Plug and Play BIOS Extension v1.0A", "delay": 0.90, "sfx": "", "color": "#c0c0c0"},
		{"text": "Detecting IDE Primary Master   ... QUANTUM FIREBALL CR8.4A", "delay": 1.35, "sfx": "hdd_click", "color": "#c0c0c0"},
		{"text": "Detecting IDE Secondary Master ... CREATIVE CD5233E 52X", "delay": 0.95, "sfx": "", "color": "#c0c0c0"},
		{"text": "Floppy disk(s) seek            ... Drive A: 1.44M, 3.5 in.", "delay": 1.75, "sfx": "floppy", "color": "#c0c0c0"},
		{"text": "", "delay": 0.50, "sfx": "", "color": ""},
		{"text": "Starting Windows 98...", "delay": 1.65, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "", "delay": 0.40, "sfx": "", "color": ""},
		{"text": "Microsoft(R) Windows 98", "delay": 0.70, "sfx": "", "color": "#c0c0c0"},
		{"text": "   (C)Copyright Microsoft Corp 1981-1999.", "delay": 0.75, "sfx": "", "color": "#c0c0c0"},
		{"text": "C:\\>SET BLASTER=A220 I5 D1 H5 P330 T6", "delay": 1.05, "sfx": "hdd_click", "color": "#c0c0c0"},
		{"text": "Creative SB16 Emulation Driver, Version 4.00", "delay": 0.95, "sfx": "", "color": "#a8a8a8"},
		{"text": "C:\\>LH C:\\WINDOWS\\COMMAND\\MSCDEX.EXE /D:MSCD001", "delay": 1.15, "sfx": "hdd_click", "color": "#c0c0c0"},
		{"text": "C:\\>C:\\WINDOWS\\WIN.COM", "delay": 1.85, "sfx": "hdd_burst", "color": "#55ffff"}
	]

	p.chrome_style = "win98_classic"
	p.desktop_bg_color = Color("008080")
	p.desktop_secondary_color = Color("006666")
	p.panel_bg_color = Color("c0c0c0")
	p.panel_text_color = Color("000000")
	p.window_bg_color = Color("c0c0c0")
	p.window_text_color = Color("000000")
	p.window_border_color = Color("dfdfdf")
	p.titlebar_active_color = Color("000080")
	p.titlebar_active_gradient_end = Color("1084d0")
	p.titlebar_inactive_color = Color("808080")
	p.titlebar_text_color = Color("ffffff")
	p.accent_color = Color("000080")

	p.terminal_title = "MS-DOS Prompt"
	p.terminal_bg_color = Color("000000")
	p.terminal_fg_color = Color("c0c0c0")
	p.terminal_prompt = "C:\\WINDOWS>"
	p.terminal_welcome_banner = (
		"Microsoft(R) Windows 98\n"
		+ "   (C)Copyright Microsoft Corp 1981-1999.\n"
		+ "Type 'help', 'ver', 'dir', 'mem', or 'type autoexec.bat'."
	)
	p.terminal_commands = {
		"ver": "\nWindows 98 [Version 4.10.2222]",
		"dir": (
			" Volume in drive C is WIN98_SE\n"
			+ " Volume Serial Number is 1E4F-09A2\n"
			+ " Directory of C:\\WINDOWS\n\n"
			+ ".              <DIR>        05-05-99  10:22p .\n"
			+ "..             <DIR>        05-05-99  10:22p ..\n"
			+ "COMMAND  COM        93,890  04-23-99  10:22p COMMAND.COM\n"
			+ "SYSTEM         <DIR>        05-05-99  10:22p SYSTEM\n"
			+ "WIN      COM        24,963  04-23-99  10:22p WIN.COM\n"
			+ "EXPLORER EXE       180,224  04-23-99  10:22p EXPLORER.EXE\n"
			+ "NOTEPAD  EXE        53,248  04-23-99  10:22p NOTEPAD.EXE\n"
			+ "        4 file(s)        352,325 bytes\n"
			+ "        3 dir(s)   6,842.15 MB free"
		),
		"mem": (
			"\nMemory Type        Total       Used       Free\n"
			+ "----------------  --------   --------   --------\n"
			+ "Conventional          640K        29K       611K\n"
			+ "Upper                   0K         0K         0K\n"
			+ "Reserved              384K       384K         0K\n"
			+ "Extended (XMS)     65,472K          ?   130,048K\n"
			+ "----------------  --------   --------   --------\n"
			+ "Largest executable program size: 611K (625,488 bytes)\n"
			+ "MS-DOS is resident in the high memory area."
		),
		"type autoexec.bat": (
			"@ECHO OFF\n"
			+ "SET SOUND=C:\\PROGRA~1\\CREATIVE\\CTSND\n"
			+ "SET BLASTER=A220 I5 D1 H5 P330 E620 T6\n"
			+ "SET PATH=C:\\WINDOWS;C:\\WINDOWS\\COMMAND\n"
			+ "LH C:\\WINDOWS\\COMMAND\\MSCDEX.EXE /D:MSCD001"
		),
		"type config.sys": (
			"DEVICE=C:\\WINDOWS\\HIMEM.SYS\n"
			+ "DEVICE=C:\\WINDOWS\\EMM386.EXE NOEMS\n"
			+ "DOS=HIGH,UMB\n"
			+ "DEVICEHIGH=C:\\CDROM\\OAKCDROM.SYS /D:MSCD001"
		),
		"ipconfig": (
			"Windows 98 IP Configuration\n\n"
			+ "0 Ethernet adapter :\n"
			+ "   IP Address. . . . . . . . . : 192.168.1.98\n"
			+ "   Subnet Mask . . . . . . . . : 255.255.255.0\n"
			+ "   Default Gateway . . . . . . : 192.168.1.1"
		),
		"winver": "Microsoft Windows 98 Second Edition (Build 4.10.2222 A)"
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "MS-DOS Prompt",
			"type": "terminal",
			"pos": Vector2(130, 62),
			"size": Vector2(540, 340),
			"content": ""
		},
		{
			"id": "sysprop",
			"title": "System Properties",
			"type": "monitor",
			"pos": Vector2(545, 360),
			"size": Vector2(420, 290),
			"content": (
				"[ General | Device Manager | Hardware Profiles | Performance ]\n"
				+ "------------------------------------------------------------\n"
				+ "System:\n"
				+ "   Microsoft Windows 98\n"
				+ "   Second Edition\n"
				+ "   4.10.2222 A\n\n"
				+ "Registered to:\n"
				+ "   RetroOS Workstation User\n"
				+ "   29912-OEM-0041922-88412\n\n"
				+ "Computer:\n"
				+ "   GenuineIntel\n"
				+ "   Intel Pentium(R) III processor 500MHz\n"
				+ "   128.0MB RAM • System Resources: 92% free"
			)
		},
		{
			"id": "notepad",
			"title": "README.TXT - Notepad",
			"type": "text",
			"pos": Vector2(120, 425),
			"size": Vector2(400, 220),
			"content": (
				"File  Edit  Search  Help\n"
				+ "----------------------------------------------------\n"
				+ "Microsoft Windows 98 Second Edition README\n"
				+ "April 1999\n\n"
				+ "- 3dfx Voodoo3 Glide 2.60 drivers installed.\n"
				+ "- DirectX 6.1 and Internet Connection Sharing enabled.\n"
				+ "- Double-click desktop icons or use the Start bar\n"
				+ "  to restore closed windows."
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_mycomp", "label": "My Computer", "glyph": "[PC]", "target_window_id": "sysprop"},
		{"id": "icon_msdos", "label": "MS-DOS\nPrompt", "glyph": "[C:\\]", "target_window_id": "terminal"},
		{"id": "icon_readme", "label": "README.TXT", "glyph": "[TXT]", "target_window_id": "notepad"}
	]

	p.fan_base_freq = 122.0
	p.fan_noise_level = 0.26
	p.hdd_seek_interval_range = Vector2(2.4, 6.2)
	return p


# ==============================================================================
# 5. IBM OS/2 WARP 4 (MERLIN / REV 9.023) - SEPTEMBER 1996
# ==============================================================================
static func _build_os2_warp() -> OSProfile:
	var p := OSProfile.new()
	p.id = "os2_warp"
	p.category = "PC & OS/2"
	p.display_name = "IBM OS/2 Warp 4 (Merlin)"
	p.short_name = "OS/2 Warp 4"
	p.release_year = "1996"
	p.has_crt = true
	p.aspect_ratio = "4:3"
	p.vendor = "International Business Machines Corp."
	p.architecture_summary = "x86 32-Bit Protected Mode • Rev 9.023 • Workplace Shell (PMSHELL)"
	p.hardware_profile = "IBM PC 300PL • Pentium Pro 200MHz • 64MB EDO RAM • HPFS File System"
	p.description = (
		"IBM's true preemptive multitasking 32-bit operating system. Features the object-oriented "
		+ "Workplace Shell (WPS), top-docked Lotus SmartCenter/WarpCenter bar, High Performance File "
		+ "System (HPFS), and deep purple/indigo Presentation Manager window chrome."
	)

	p.bios_header = (
		"IBM SurePath BIOS Version 1.18 (NVKT24AUS)\n"
		+ "(C) Copyright IBM Corp. 1981-1996. All rights reserved."
	)
	p.boot_bg_color = Color("04050c")
	p.boot_text_color = Color("d0d4e0")
	p.boot_logs = [
		{"text": "IBM Personal Computer 300PL — Intel Pentium(R) Pro 200MHz (256KB L2 Cache)", "delay": 1.05, "sfx": "fan_spinup", "color": "#ffffff"},
		{"text": "065536 KB Base/Extended Memory OK", "delay": 1.45, "sfx": "beep", "color": "#99ccff"},
		{"text": "Diskette Drive A: 1.44 MB 3.5-inch initialized", "delay": 1.65, "sfx": "floppy", "color": "#c8c8d8"},
		{"text": "", "delay": 0.45, "sfx": "", "color": ""},
		{"text": "█▀▀▀█ █▀▀▀  /  ▀▀▀█    OS/2 Warp Version 4", "delay": 0.90, "sfx": "hdd_click", "color": "#55aaff"},
		{"text": "█   █ ▀▀▀█ /   █▀▀▀    Internal Revision 9.023, 96/09/19", "delay": 0.65, "sfx": "", "color": "#55aaff"},
		{"text": "▀▀▀▀▀ ▀▀▀▀     ▀▀▀▀    (C) Copyright IBM Corp. 1987, 1996", "delay": 0.85, "sfx": "", "color": "#55aaff"},
		{"text": "", "delay": 0.45, "sfx": "", "color": ""},
		{"text": "Loading BASEDEV=IBMKBD.SYS", "delay": 0.80, "sfx": "hdd_click", "color": "#c8c8d8"},
		{"text": "Loading BASEDEV=IBM1FLPY.ADD", "delay": 1.45, "sfx": "floppy", "color": "#c8c8d8"},
		{"text": "Loading BASEDEV=IBM1S506.ADD (Bus Master IDE Adapter)", "delay": 1.10, "sfx": "hdd_click", "color": "#c8c8d8"},
		{"text": "The system is checking the hard disk (Drive C: IFS=HPFS.IFS)...", "delay": 1.65, "sfx": "hdd_burst", "color": "#ffffaa"},
		{"text": "The type of file system for the disk is HPFS. Volume WARP4_BOOT is clean.", "delay": 1.15, "sfx": "hdd_click", "color": "#88ee99"},
		{"text": "Loading DEVICE=C:\\OS2\\MDOS\\VEMM.SYS (Virtual DOS Machine MVDM)", "delay": 0.90, "sfx": "", "color": "#c8c8d8"},
		{"text": "Loading DEVICE=C:\\MMOS2\\SB16D2.SYS (Multimedia Presentation Manager/2)", "delay": 0.95, "sfx": "hdd_click", "color": "#c8c8d8"},
		{"text": "Starting Workplace Shell (PROTSHELL=C:\\OS2\\PMSHELL.EXE)...", "delay": 1.75, "sfx": "hdd_burst", "color": "#99ccff"}
	]

	p.chrome_style = "os2_pmshell"
	p.desktop_bg_color = Color("224b5e")
	p.desktop_secondary_color = Color("183545")
	p.panel_bg_color = Color("b8b8c0")
	p.panel_text_color = Color("111118")
	p.window_bg_color = Color("cccccc")
	p.window_text_color = Color("111118")
	p.window_border_color = Color("e0e0e8")
	p.titlebar_active_color = Color("3c2878")
	p.titlebar_active_gradient_end = Color("5a3ea6")
	p.titlebar_inactive_color = Color("787888")
	p.titlebar_text_color = Color("ffffff")
	p.accent_color = Color("3c2878")

	p.terminal_title = "OS/2 Window"
	p.terminal_bg_color = Color("000000")
	p.terminal_fg_color = Color("d8d8d8")
	p.terminal_prompt = "[C:\\]"
	p.terminal_welcome_banner = (
		"Operating System/2 Command Interpreter Version 4.00\n"
		+ "(C) Copyright IBM Corp. 1987, 1996.\n"
		+ "Type 'help', 'ver', 'dir', 'chkdsk', or 'type config.sys'."
	)
	p.terminal_commands = {
		"ver": "\nThe Operating System/2 Version is 4.00\nRevision 9.023",
		"dir": (
			"The volume label in drive C is WARP4_BOOT.\n"
			+ "The Volume Serial Number is 2A91:440C\n"
			+ "Directory of C:\\\n\n"
			+ " 9-19-96   4:00a     <DIR>         0  DESKTOP\n"
			+ " 9-19-96   4:00a     <DIR>         0  OS2\n"
			+ " 9-19-96   4:00a     <DIR>         0  MMOS2\n"
			+ " 9-19-96   4:00a     <DIR>         0  MPTN\n"
			+ " 9-19-96   4:00a      3,842      124  CONFIG.SYS\n"
			+ " 9-19-96   4:00a        512        0  STARTUP.CMD\n"
			+ "       6 file(s)       4,354 bytes used\n"
			+ "                   1,842,176 K bytes free"
		),
		"chkdsk": (
			"The type of file system for the disk is HPFS.\n"
			+ "The HPFS file system program has been started.\n"
			+ "2097152 kilobytes total disk space.\n"
			+ "  18432 kilobytes are in 412 directories.\n"
			+ " 236544 kilobytes are in 8,940 user files.\n"
			+ "1842176 kilobytes are available for use."
		),
		"type config.sys": (
			"IFS=C:\\OS2\\HPFS.IFS /CACHE:2048 /CRECL:4 /AUTOCHECK:C\n"
			+ "PROTSHELL=C:\\OS2\\PMSHELL.EXE\n"
			+ "SET USER_INI=C:\\OS2\\OS2.INI\n"
			+ "SET SYSTEM_INI=C:\\OS2\\OS2SYS.INI\n"
			+ "SET AUTOSTART=PROGRAMS,TASKLIST,FOLDERS,WARPCENTER\n"
			+ "THREADS=1024\n"
			+ "BASEDEV=IBM1S506.ADD"
		),
		"pstat": (
			"Process and Thread Information (Revision 9.023):\n"
			+ " PID  PPID  SESS  PROC NAME\n"
			+ "0001  0000   00   SYSINIT\n"
			+ "0004  0001   01   C:\\OS2\\PMSHELL.EXE (Workplace Shell)\n"
			+ "0007  0004   01   C:\\OS2\\PMSPOOL.EXE\n"
			+ "0011  0004   01   C:\\OS2\\APPS\\SCENTER.EXE (WarpCenter)\n"
			+ "0015  0004   02   C:\\OS2\\CMD.EXE"
		)
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "OS/2 Window",
			"type": "terminal",
			"pos": Vector2(130, 66),
			"size": Vector2(540, 340),
			"content": ""
		},
		{
			"id": "wps_sys",
			"title": "OS/2 System - Icon View",
			"type": "files",
			"pos": Vector2(535, 370),
			"size": Vector2(430, 260),
			"content": (
				"Workplace Shell Object Folder: <WP_OS2SYS>\n"
				+ "=================================================\n"
				+ "[Drives]          [System Setup]    [Command Prompts]\n"
				+ "  Drive A: (FDD)    System Clock      OS/2 Window\n"
				+ "  Drive C: (HPFS)   Sound Palette     DOS Full Screen\n"
				+ "  Drive D: (CD)     Win-OS/2 Setup    REXX Try\n"
				+ "-------------------------------------------------\n"
				+ "Shredder Ready | SOM/DSOM Workplace Objects Active"
			)
		},
		{
			"id": "epm",
			"title": "OS/2 System Editor - C:\\CONFIG.SYS",
			"type": "text",
			"pos": Vector2(115, 430),
			"size": Vector2(395, 220),
			"content": (
				"File  Edit  Options  Help\n"
				+ "-------------------------------------------------\n"
				+ "IFS=C:\\OS2\\HPFS.IFS /CACHE:2048 /CRECL:4\n"
				+ "PROTSHELL=C:\\OS2\\PMSHELL.EXE\n"
				+ "SET RUNWORKPLACE=C:\\OS2\\PMSHELL.EXE\n"
				+ "SET AUTOSTART=PROGRAMS,TASKLIST,FOLDERS,WARPCENTER\n"
				+ "BASEDEV=IBM1S506.ADD\n"
				+ "DEVICE=C:\\OS2\\MDOS\\VSVGA.SYS"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_os2sys", "label": "OS/2 System", "glyph": "[WPS]", "target_window_id": "wps_sys"},
		{"id": "icon_cmd", "label": "OS/2 Window", "glyph": "[C:\\]", "target_window_id": "terminal"},
		{"id": "icon_epm", "label": "CONFIG.SYS", "glyph": "[EPM]", "target_window_id": "epm"}
	]

	p.fan_base_freq = 128.0
	p.fan_noise_level = 0.27
	p.hdd_seek_interval_range = Vector2(2.6, 6.5)
	return p


# ==============================================================================
# 6. WINDOWS XP PRO SP2 - ALIENWARE AREA-51 "PREDATOR" P4 RIG (c. 2003-2004)
# ==============================================================================
static func _build_winxp_alienware() -> OSProfile:
	var p := OSProfile.new()
	p.id = "winxp_alienware"
	p.category = "PC & OS/2"
	p.display_name = "Windows XP Pro SP2 (Alienware Area-51 P4)"
	p.short_name = "WinXP (Area-51)"
	p.release_year = "2003"
	p.has_crt = true
	p.aspect_ratio = "4:3"
	p.vendor = "Microsoft / Alienware Corp. (Miami, FL)"
	p.architecture_summary = "x86 NT 5.1 (Build 2600.xpsp2) • Luna / AlienGUIse Shell • DirectX 9.0c"
	p.hardware_profile = "Alienware Area-51 'Predator' Full-Tower • P4 3.2GHz EE • Radeon 9800 XT • 2x WD Raptor 10K RAID-0"
	p.description = (
		"Early-2000s flagship enthusiast gaming monolith housed in the sculpted Saucer-Silver/Cyborg-Green "
		+ "Alienware 'Predator' hydraulic-door full-tower. Powered by an Intel Pentium 4 3.20GHz Extreme Edition "
		+ "(Hyper-Threading) on an i875P Canterwood board, dual 10,000 RPM WD Raptor SATA RAID-0 drives, "
		+ "ATI Radeon 9800 XT 256MB AGP 8X, Sound Blaster Audigy 2 ZS, and KoolMaxx high-CFM case blowers."
	)

	p.bios_header = (
		"AMIBIOS (C) 2003 American Megatrends, Inc.       Alienware Area-51 Desktop System\n"
		+ "Intel D875PBZ (i875P Canterwood) BIOS Rev P22    KoolMaxx Thermal Control: ACTIVE"
	)
	p.boot_bg_color = Color("030504")
	p.boot_text_color = Color("d0dcd4")
	p.boot_logs = [
		{"text": "CPU : Intel(R) Pentium(R) 4 CPU 3.20GHz Extreme Edition (FSB 800MHz)", "delay": 1.10, "sfx": "fan_spinup", "color": "#ffffff"},
		{"text": "Hyper-Threading Technology : ENABLED (2 Logical Processors Detected)", "delay": 0.85, "sfx": "", "color": "#66ff88"},
		{"text": "L2 Cache: 512KB Full-Speed  |  L3 Cache: 2048KB On-Die Integrated", "delay": 0.80, "sfx": "", "color": "#b8d0c0"},
		{"text": "DDR-400 Dual-Channel Linear Mode Enabled (PAT: Performance Acceleration Tech)", "delay": 0.90, "sfx": "", "color": "#b8d0c0"},
		{"text": "Checking NVRAM.. 2097152 KB OK (Corsair XMS3200LL TwinX 2-2-2-5)", "delay": 1.55, "sfx": "beep", "color": "#ffffff"},
		{"text": "Initializing USB Controllers .. Done. (8 USB 2.0 Ports, Alienware Front IO)", "delay": 0.95, "sfx": "", "color": "#c0c8c4"},
		{"text": "Floppy Disk Drive A: 1.44MB 3.5-inch (TEAC Black Bezel) Seek Check...", "delay": 1.75, "sfx": "floppy", "color": "#c0c8c4"},
		{"text": "", "delay": 0.45, "sfx": "", "color": ""},
		{"text": "Promise FastTrak S150 TX2plus RAID BIOS Version 1.00.0.33", "delay": 1.25, "sfx": "hdd_click", "color": "#ffd066"},
		{"text": "Scanning SATA 150 Channels for Drives...", "delay": 1.50, "sfx": "hdd_burst", "color": "#ffd066"},
		{"text": "   Ch0: WDC WD740GD-00FLA1 (74.3 GB 10,000 RPM Raptor)", "delay": 0.75, "sfx": "hdd_click", "color": "#e0e8e4"},
		{"text": "   Ch1: WDC WD740GD-00FLA1 (74.3 GB 10,000 RPM Raptor)", "delay": 0.75, "sfx": "hdd_click", "color": "#e0e8e4"},
		{"text": "ID   MODE          SIZE     TRACK-MAPPING    STATUS", "delay": 0.45, "sfx": "", "color": "#ffffff"},
		{"text": "1*   2+0 Stripe    148600M   18094/255/63    Functional [ARRAY_AREA51]", "delay": 1.15, "sfx": "hdd_burst", "color": "#66ff88"},
		{"text": "", "delay": 0.50, "sfx": "", "color": ""},
		{"text": "Booting from Promise FastTrak RAID0 Array (NTLDR)...", "delay": 1.45, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "Starting Microsoft Windows XP Professional [Version 5.1.2600 Service Pack 2]", "delay": 1.60, "sfx": "hdd_burst", "color": "#55aaff"},
		{"text": "   Loading multi(0)disk(0)rdisk(0)partition(1)\\WINDOWS\\System32\\ntoskrnl.exe", "delay": 1.10, "sfx": "hdd_click", "color": "#a8b8c8"},
		{"text": "   Loading AGP 8X Display Driver: ati2mtag.sys (ATI Radeon 9800 XT 256MB)", "delay": 1.15, "sfx": "hdd_click", "color": "#a8b8c8"},
		{"text": "   Loading WDM Audio Driver: ctaud2k.sys (Sound Blaster Audigy 2 ZS THX)", "delay": 1.00, "sfx": "hdd_click", "color": "#a8b8c8"},
		{"text": "   Starting AlienGUIse Theme Service & AlienAdrenaline Profile Manager...", "delay": 1.70, "sfx": "hdd_burst", "color": "#66ff88"}
	]

	p.chrome_style = "winxp_luna"
	p.desktop_bg_color = Color("122a44")
	p.desktop_secondary_color = Color("164a32")
	p.panel_bg_color = Color("1f52c8")
	p.panel_text_color = Color("ffffff")
	p.window_bg_color = Color("ece9d8")
	p.window_text_color = Color("111111")
	p.window_border_color = Color("0046d5")
	p.titlebar_active_color = Color("0054e3")
	p.titlebar_active_gradient_end = Color("3d95ff")
	p.titlebar_inactive_color = Color("7a96df")
	p.titlebar_text_color = Color("ffffff")
	p.accent_color = Color("3c9e38")

	p.terminal_title = "C:\\WINDOWS\\system32\\cmd.exe"
	p.terminal_bg_color = Color("050a06")
	p.terminal_fg_color = Color("44ff66")
	p.terminal_prompt = "C:\\Documents and Settings\\Area51>"
	p.terminal_welcome_banner = (
		"Microsoft Windows XP [Version 5.1.2600]\n"
		+ "(C) Copyright 1985-2001 Microsoft Corp. // Alienware Area-51 OEM Build\n"
		+ "Type 'systeminfo', 'dxdiag', 'tasklist', 'dir', 'ipconfig', or 'help'."
	)
	p.terminal_commands = {
		"ver": "\nMicrosoft Windows XP [Version 5.1.2600]",
		"systeminfo": (
			"Host Name:                 AREA51-PREDATOR\n"
			+ "OS Name:                   Microsoft Windows XP Professional\n"
			+ "OS Version:                5.1.2600 Service Pack 2 Build 2600\n"
			+ "System Manufacturer:       Alienware Corporation\n"
			+ "System Model:              Area-51 Predator Full-Tower (i875P)\n"
			+ "Processor(s):              2 Processor(s) Installed (HT Enabled).\n"
			+ "                           [01]: x86 Family 15 Model 2 Stepping 5 GenuineIntel ~3200 Mhz\n"
			+ "                           [02]: x86 Family 15 Model 2 Stepping 5 GenuineIntel ~3200 Mhz\n"
			+ "Total Physical Memory:     2,047 MB (DDR-400 Dual Channel)"
		),
		"dxdiag": (
			"------------------\n"
			+ "DirectX Diagnostic Tool (DirectX 9.0c - 4.09.0000.0904)\n"
			+ "------------------\n"
			+ "Card name:        ATI RADEON 9800 XT AGP (0x4E4A)\n"
			+ "Display Memory:   256.0 MB DDR (256-bit Bus, 412MHz Core / 730MHz Mem)\n"
			+ "Driver Version:   6.14.0010.6476 (Catalyst 4.9)\n"
			+ "Sound Tab 1:      SB Audigy 2 ZS Audio [DF00] (EAX 4.0 ADVANCED HD: Enabled)"
		),
		"tasklist": (
			"Image Name                   PID Session Name     Mem Usage\n"
			+ "========================= ====== ================ ============\n"
			+ "System Idle Process            0 Console                 16 K\n"
			+ "System                         4 Console                240 K\n"
			+ "svchost.exe                  948 Console             18,412 K\n"
			+ "explorer.exe                1420 Console             24,880 K\n"
			+ "CTHelper.exe                1588 Console              4,920 K\n"
			+ "atiptaxx.exe                1612 Console              5,410 K\n"
			+ "AlienGUIse.exe              1704 Console             12,640 K\n"
			+ "winamp.exe                  1892 Console              9,120 K"
		),
		"dir": (
			" Volume in drive C is AREA51_RAID0\n"
			+ " Volume Serial Number is 88F1-A409\n"
			+ " Directory of C:\\Documents and Settings\\Area51\n\n"
			+ "10/21/2004  01:14 AM    <DIR>          .\n"
			+ "10/21/2004  01:14 AM    <DIR>          ..\n"
			+ "10/18/2004  09:42 PM    <DIR>          Desktop\n"
			+ "10/19/2004  11:15 PM    <DIR>          Doom3_Saves\n"
			+ "10/20/2004  08:05 PM    <DIR>          Half-Life 2 Preload\n"
			+ "10/20/2004  11:50 PM            14,820 3DMark03_6842pts.txt\n"
			+ "10/21/2004  12:30 AM             4,192 AlienOpt_OC_Profile.ini\n"
			+ "               2 File(s)         19,012 bytes\n"
			+ "               5 Dir(s)  124,819,402,752 bytes free"
		),
		"ipconfig": (
			"Windows IP Configuration\n\n"
			+ "Ethernet adapter Intel PRO/1000 CT Network Connection:\n"
			+ "   Connection-specific DNS Suffix  . : lan.area51\n"
			+ "   IP Address. . . . . . . . . . . . : 192.168.1.51\n"
			+ "   Subnet Mask . . . . . . . . . . . : 255.255.255.0\n"
			+ "   Default Gateway . . . . . . . . . : 192.168.1.1"
		)
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "C:\\WINDOWS\\system32\\cmd.exe",
			"type": "terminal",
			"pos": Vector2(124, 48),
			"size": Vector2(565, 345),
			"content": ""
		},
		{
			"id": "dxdiag",
			"title": "DirectX Diagnostic Tool (dxdiag.exe)",
			"type": "monitor",
			"pos": Vector2(515, 365),
			"size": Vector2(465, 290),
			"content": (
				"[ System | DirectX Files | Display | Sound | Music | Network ]\n"
				+ "==============================================================\n"
				+ "Machine Name : AREA51-PREDATOR (Alienware Chieftec Full-Tower)\n"
				+ "OS           : Windows XP Professional (5.1, Build 2600) SP2\n"
				+ "Processor    : Intel(R) Pentium(R) 4 3.20GHz EE (2 CPUs, HT)\n"
				+ "Memory       : 2048MB DDR-400 Dual-Channel (PAT Enabled)\n"
				+ "DirectX      : DirectX 9.0c (4.09.0000.0904)\n"
				+ "GPU          : ATI Radeon 9800 XT 256MB AGP 8X (412/730 MHz)\n"
				+ "RAID Array   : 2x 74GB WD Raptor 10,000 RPM (RAID-0 Stripe)"
			)
		},
		{
			"id": "alien_bench",
			"title": "AlienAdrenaline // Predator Thermal & Benchmark Log",
			"type": "text",
			"pos": Vector2(115, 412),
			"size": Vector2(385, 240),
			"content": (
				"ALIENWARE AREA-51 'PREDATOR' TELEMETRY\n"
				+ "----------------------------------------------\n"
				+ "Case Finish   : Saucer Silver / Cyborg Green\n"
				+ "KoolMaxx Fans : Front 92mm (2800 RPM) | Rear 2x80mm\n"
				+ "P4 3.2EE Temp : 41°C Idle / 56°C Load\n"
				+ "Radeon 9800XT : 52°C OverDrive Active\n"
				+ "----------------------------------------------\n"
				+ "3DMark2001 SE : 21,490 Marks\n"
				+ "3DMark03      :  6,842 Marks\n"
				+ "DOOM 3 Demo1  :   64.8 FPS (1024x768 High)"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_mycomp", "label": "Area-51\nSystem", "glyph": "[👽]", "target_window_id": "dxdiag"},
		{"id": "icon_cmd", "label": "Command\nPrompt", "glyph": "[C:\\]", "target_window_id": "terminal"},
		{"id": "icon_bench", "label": "Predator\nTelemetry", "glyph": "[3D]", "target_window_id": "alien_bench"}
	]

	p.fan_base_freq = 136.0
	p.fan_noise_level = 0.30
	p.hdd_seek_interval_range = Vector2(1.8, 4.5)
	return p


# ==============================================================================
# 7. SGI IRIX 6.5.22 - SILICON GRAPHICS OCTANE2 WORKSTATION (c. 2001)
# ==============================================================================
static func _build_sgi_irix() -> OSProfile:
	var p := OSProfile.new()
	p.id = "sgi_irix"
	p.category = "UNIX & Alt-OS"
	p.display_name = "SGI IRIX 6.5.22 (Octane2 VPro V12)"
	p.short_name = "SGI IRIX 6.5"
	p.release_year = "2001"
	p.has_crt = true
	p.aspect_ratio = "4:3"
	p.vendor = "Silicon Graphics, Inc. (Mountain View, CA)"
	p.architecture_summary = "MIPS64 (2x R14000A) • IRIX 6.5.22m • Indigo Magic / 4Dwm Desktop"
	p.hardware_profile = "SGI Octane2 (IP30) • Dual 600MHz MIPS R14000A • 2GB ECC • VPro V12 Odyssey • 15K SCSI"
	p.description = (
		"Silicon Graphics' legendary crossbar-switched visual computing workstation in Compression "
		+ "Purple skins. Features dual 600MHz 64-bit MIPS R14000A CPUs, VPro V12 Odyssey 48-bit RGBA "
		+ "hardware texture engine, 15,000 RPM Seagate Cheetah X15 Ultra160 SCSI storage, and the "
		+ "classic Indigo Magic 4Dwm desktop with the top-left SGI Toolchest."
	)

	p.bios_header = (
		"Silicon Graphics Octane2 (IP30) ARCS PROM Monitor — Revision 6.5 (Build Oct 14 2000)\n"
		+ "(C) Copyright 1996-2001 Silicon Graphics, Inc. All Rights Reserved."
	)
	p.boot_bg_color = Color("070914")
	p.boot_text_color = Color("d8e0f8")
	p.boot_logs = [
		{"text": "Running IP30 Power-On Diagnostics...", "delay": 1.15, "sfx": "fan_spinup", "color": "#a8c4ff"},
		{"text": "HEART ASIC Rev D / XBOW Crossbar Switch Rev 1.3 (1.6 GB/s Link OK)", "delay": 1.05, "sfx": "beep", "color": "#d8e0f8"},
		{"text": "CPU 0: MIPS R14000A Processor Chip Revision: 2.4 (600 MHz, 8MB L2 Cache) - PASSED", "delay": 0.90, "sfx": "", "color": "#88eeaa"},
		{"text": "CPU 1: MIPS R14000A Processor Chip Revision: 2.4 (600 MHz, 8MB L2 Cache) - PASSED", "delay": 0.90, "sfx": "", "color": "#88eeaa"},
		{"text": "Memory Diagnostic: 2048 MB Direct-Attached Crossbar ECC SDRAM — PASSED", "delay": 1.35, "sfx": "", "color": "#ffffff"},
		{"text": "Probing XIO Slot 1: Odyssey VPro V12 Graphics Subsystem (128MB SDRAM) — ONLINE", "delay": 1.15, "sfx": "", "color": "#ffcc77"},
		{"text": "Probing Dual-Channel Ultra160 SCSI Controller (qla0 / QLogic ISP12160)...", "delay": 1.55, "sfx": "hdd_burst", "color": "#d8e0f8"},
		{"text": "   dksc(0,1,0) : SEAGATE ST336752LW (36.7 GB 15,000 RPM Cheetah X15)", "delay": 1.05, "sfx": "hdd_click", "color": "#ffffff"},
		{"text": "", "delay": 0.45, "sfx": "", "color": ""},
		{"text": "System Maintenance Menu: Starting Up the System...", "delay": 1.20, "sfx": "hdd_click", "color": "#a8c4ff"},
		{"text": "Loading xfs(dksc(0,1,0)s0)/unix ...", "delay": 1.60, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "IRIX Release 6.5.22m IP30 (64-bit) #1 SMP Mon Oct 20 14:12:09 PDT 2003", "delay": 1.05, "sfx": "", "color": "#77ddff"},
		{"text": "Copyright 1987-2003 Silicon Graphics, Inc. All Rights Reserved.", "delay": 0.75, "sfx": "", "color": "#a8b8d8"},
		{"text": "xfs: Mounting /dev/dsk/dks0d1s0 on / (clean, 64-bit journaled XFS)", "delay": 1.25, "sfx": "hdd_burst", "color": "#c8d8f0"},
		{"text": "autoconfig: checking hardware inventory against /unix...", "delay": 1.20, "sfx": "hdd_click", "color": "#c8d8f0"},
		{"text": "Starting Network Daemons: portmap, ypbind, nfsd, automount, mediad.", "delay": 1.05, "sfx": "hdd_click", "color": "#c8d8f0"},
		{"text": "Starting Xsgi OpenGL X11 Server on Odyssey V12 (1280x1024 @ 75Hz Stereo)...", "delay": 1.35, "sfx": "hdd_click", "color": "#ffcc77"},
		{"text": "Launching Indigo Magic Desktop (4Dwm, toolchest, fm, gr_osview)...", "delay": 1.65, "sfx": "hdd_burst", "color": "#88eeaa"}
	]

	p.chrome_style = "sgi_4dwm"
	p.desktop_bg_color = Color("364268")
	p.desktop_secondary_color = Color("232c48")
	p.panel_bg_color = Color("9ca4b8")
	p.panel_text_color = Color("121520")
	p.window_bg_color = Color("b4bccf")
	p.window_text_color = Color("10131c")
	p.window_border_color = Color("dce2f2")
	p.titlebar_active_color = Color("465884")
	p.titlebar_active_gradient_end = Color("6478a8")
	p.titlebar_inactive_color = Color("767e94")
	p.titlebar_text_color = Color("fff6d6")
	p.accent_color = Color("5c3d99")

	p.terminal_title = "winterm - octane2:/usr/people/vfx"
	p.terminal_bg_color = Color("121624")
	p.terminal_fg_color = Color("e2e8f8")
	p.terminal_prompt = "octane2 1% "
	p.terminal_welcome_banner = (
		"IRIX64 octane2 6.5 6.5.22m 10070055 IP30\n"
		+ "Silicon Graphics Octane2 // Dual MIPS R14000A @ 600MHz // VPro V12 Odyssey\n"
		+ "Type 'hinv', 'uname -Ra', 'gr_osview', 'df -k', 'versions', or 'help'."
	)
	p.terminal_commands = {
		"hinv": (
			"2 600 MHZ IP30 Processors\n"
			+ "CPU: MIPS R14000A Processor Chip Revision: 2.4\n"
			+ "FPU: MIPS R14010 Floating Point Chip Revision: 2.4\n"
			+ "Main memory size: 2048 Mbytes\n"
			+ "Secondary unified instruction/data cache size: 8 Mbytes on Processor 0\n"
			+ "Secondary unified instruction/data cache size: 8 Mbytes on Processor 1\n"
			+ "Integral SCSI controller 0: Version QL12160 (Ultra160 Wide LVD)\n"
			+ "  Disk drive: unit 1 on SCSI controller 0 (SEAGATE ST336752LW 15K)\n"
			+ "Integral Fast Ethernet: ef0, version 1, pci 2\n"
			+ "Odyssey graphics (VPro V12) installed: 128MB texture memory, 48-bit RGBA\n"
			+ "RAD Audio Processor: version 2 revision 0"
		),
		"uname -ra": "IRIX64 octane2 6.5 6.5.22m 10070055 IP30",
		"uname -a": "IRIX64 octane2 6.5 10070055 IP30",
		"df -k": (
			"Filesystem             Type  kbytes     use     avail  %use Mounted on\n"
			+ "/dev/root              xfs  35482624  8412960 27069664  24%  /\n"
			+ "/hw                    hwgfs       0        0        0   0%  /hw\n"
			+ "renderfarm:/shots      nfs  289401200 194120000 95281200 68%  /hosts/renderfarm"
		),
		"versions": (
			"I = Installed, R = Removed\n\n"
			+ "   Name                 Date      Description\n"
			+ "I  eoe                  10/20/03  IRIX Execution Environment 6.5.22m\n"
			+ "I  ftn77_dev            10/20/03  MIPSpro Fortran 77 Compiler 7.4.1\n"
			+ "I  c++_dev              10/20/03  MIPSpro C++ Compiler 7.4.1\n"
			+ "I  opengl_glx           10/20/03  OpenGL 1.2 ARB VPro Odyssey Drivers\n"
			+ "I  maya_unlimited       10/20/03  Alias|Wavefront Maya 5.0 for IRIX\n"
			+ "I  prman                10/20/03  Pixar PhotoRealistic RenderMan 11.5"
		),
		"gr_osview": (
			"gr_osview (octane2 IP30):\n"
			+ "  CPU0 [R14k 600MHz] : usr 14% | sys  4% | intr 1% | idle 81%\n"
			+ "  CPU1 [R14k 600MHz] : usr  9% | sys  2% | intr 0% | idle 89%\n"
			+ "  Odyssey V12 DMA    : 184 MB/s Geometry & Texture Fill\n"
			+ "  Memory (2048 MB)   : Kernel 192M | FsCtl 410M | Free 1446M"
		),
		"ls": "Desktop  MayaProjects  RenderMan_RIBs  buttonfly.c  demo_dinosaur.obj  twilight"
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "winterm - octane2:/usr/people/vfx",
			"type": "terminal",
			"pos": Vector2(145, 52),
			"size": Vector2(560, 345),
			"content": ""
		},
		{
			"id": "grosview",
			"title": "gr_osview - octane2",
			"type": "monitor",
			"pos": Vector2(540, 375),
			"size": Vector2(445, 275),
			"content": (
				"SGI Octane2 (IP30) // Dual MIPS R14000A @ 600MHz\n"
				+ "====================================================\n"
				+ "CPU 0 Activity : [||||................]  18% (User/Sys)\n"
				+ "CPU 1 Activity : [||..................]  11% (User/Sys)\n"
				+ "VPro V12 GFX   : [|||||...............]  24% (OpenGL FIFO)\n"
				+ "XBOW Crossbar  : [|||.................] 240 MB/s\n"
				+ "PhysMem (2GB)  : [||||||..............] 602 MB / 2048 MB\n"
				+ "Cheetah 15K I/O: /dev/dsk/dks0d1s0 (XFS Clean)"
			)
		},
		{
			"id": "showcase",
			"title": "IRIS Showcase / Maya 5.0 Render Queue",
			"type": "text",
			"pos": Vector2(135, 420),
			"size": Vector2(390, 230),
			"content": (
				"File  Edit  View  Render  Shader  Help\n"
				+ "--------------------------------------------------\n"
				+ "Scene : /usr/people/vfx/MayaProjects/ep2_ship.mb\n"
				+ "Engine: VPro V12 Hardware 48-Bit RGBA + Z-Buffer\n"
				+ "Audio : RAD PCI Digital Audio (48kHz 24-bit AES)\n\n"
				+ "Tip: Run 'hinv' or 'versions' in winterm to inspect\n"
				+ "the Octane2 hardware inventory and MIPSpro compilers."
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_winterm", "label": "winterm", "glyph": "[>_]", "target_window_id": "terminal"},
		{"id": "icon_osview", "label": "gr_osview", "glyph": "[SGI]", "target_window_id": "grosview"},
		{"id": "icon_maya", "label": "Showcase\n3D", "glyph": "[V12]", "target_window_id": "showcase"}
	]

	p.fan_base_freq = 140.0
	p.fan_noise_level = 0.32
	p.hdd_seek_interval_range = Vector2(1.9, 4.8)
	return p


# ==============================================================================
# 8. DATAPOINT 2200 - DATAPOINT DOS 2.1 (1972)
# GENESIS OF THE WORKSTATION & DIRECT ANCESTOR OF INTEL 8008 / X86
# ==============================================================================
static func _build_datapoint_2200() -> OSProfile:
	var p := OSProfile.new()
	p.id = "datapoint_2200"
	p.category = "Pioneering Workstations"
	p.display_name = "Datapoint DOS 2.1 (Datapoint 2200)"
	p.short_name = "Datapoint DOS"
	p.release_year = "1972"
	p.has_crt = true
	p.aspect_ratio = "4:3"
	p.vendor = "Computer Terminal Corporation (CTC • San Antonio, TX)"
	p.architecture_summary = "CTC 8-bit Discrete TTL (Intel 8008 / x86 Ancestor) • Datapoint DOS 2.1"
	p.hardware_profile = "Datapoint 2200 Type II • 8-Bit Discrete TTL @ 3.3MHz • 16KB RAM • Diablo 2.5MB Disk • Dual Cassette"
	p.description = (
		"The genesis of the personal workstation. Engineered in 1970–1972 by Computer Terminal Corporation (CTC) "
		+ "to match the footprint of an IBM Selectric typewriter, the Datapoint 2200 combined an integrated 12-line green "
		+ "CRT, mechanical keyboard, dual cassette decks, and an 8-bit discrete TTL processor whose architectural blueprint "
		+ "became the Intel 8008 and founded the modern x86 lineage. Running Datapoint DOS 2.1 with Diablo removable cartridge "
		+ "hard disks, it introduced disk-oriented business computing, succeeding the earlier tape-based CTOS and establishing "
		+ "the foundation for 1973's multi-terminal Datashare timesharing and 1977's ARCNET."
	)

	p.bios_header = (
		"DATAPOINT 2200 BOOTSTRAP ROM REV 2.4\n"
		+ "COMPUTER TERMINAL CORPORATION • SAN ANTONIO, TEXAS"
	)
	p.boot_bg_color = Color("040d06")
	p.boot_text_color = Color("33ff55")
	p.boot_logs = [
		{"text": "DATAPOINT 2200 BOOTSTRAP ROM REV 2.4", "delay": 1.10, "sfx": "fan_spinup", "color": "#33ff55"},
		{"text": "LOADING DOS.SYS FROM DISK 0...", "delay": 1.45, "sfx": "hdd_burst", "color": "#20c20e"},
		{"text": "DATAPOINT DOS VERSION 2.1  COPYRIGHT (C) 1972 CTC", "delay": 1.20, "sfx": "beep", "color": "#33ff55"},
		{"text": "PLEASE ENTER CURRENT DATE (MM/DD/YY): 10/22/72", "delay": 1.50, "sfx": "hdd_click", "color": "#80ff80"},
		{"text": "DATE SET: 10/22/72", "delay": 0.85, "sfx": "", "color": "#33ff55"},
		{"text": "DOS READY.", "delay": 0.90, "sfx": "hdd_burst", "color": "#33ff55"}
	]

	p.chrome_style = "datapoint_green"
	p.desktop_bg_color = Color("030a05")
	p.desktop_secondary_color = Color("06180a")
	p.panel_bg_color = Color("0a2410")
	p.panel_text_color = Color("33ff55")
	p.window_bg_color = Color("040d06")
	p.window_text_color = Color("33ff55")
	p.window_border_color = Color("20c20e")
	p.titlebar_active_color = Color("0e3816")
	p.titlebar_active_gradient_end = Color("0a2810")
	p.titlebar_inactive_color = Color("061a0a")
	p.titlebar_text_color = Color("66ff88")
	p.accent_color = Color("33ff55")

	p.terminal_title = "DATAPOINT 2200 CONSOLE // DOS 2.1"
	p.terminal_bg_color = Color("020804")
	p.terminal_fg_color = Color("33ff55")
	p.terminal_prompt = ": "
	p.terminal_welcome_banner = (
		"DATAPOINT DOS VERSION 2.1   COPYRIGHT (C) 1972 COMPUTER TERMINAL CORPORATION\n"
		+ "16K BYTES MEMORY AVAILABLE • SYSTEM DRIVE 0 (DIABLO 2.5MB) ONLINE\n"
		+ "TYPE 'CATALOG', 'DATE', 'CTOS', 'DATASHARE', 'DATABUS', OR 'HELP'."
	)

	p.terminal_commands = {
		"catalog": (
			"\nDIRECTORY OF DRIVE 0: (PACK ID: CTC-SYSTEM-01)\n\n"
			+ " FILE NAME   EXT   TYPE   SEC   START   STATUS\n"
			+ "-------------------------------------------------\n"
			+ " DOS         SYS   SYS     32    0001   PROTECT\n"
			+ " CATALOG     CMD   UTL     12    0033   READY\n"
			+ " EDIT        CMD   UTL     24    0045   READY\n"
			+ " ASM         CMD   DEV     48    0069   READY\n"
			+ " DATABUS     CMD   CMP     64    0117   READY\n"
			+ " BASIC       CMD   INT     56    0181   READY\n"
			+ " DIAG        CMD   DIAG    16    0237   READY\n"
			+ " CASSETTE    CMD   IO      14    0253   READY\n"
			+ " LEDGER      DAT   DATA    80    0267   READY\n\n"
			+ " TOTAL BLOCKS: 1024   FREE BLOCKS: 677   BAD BLOCKS: 0"
		),
		"cat": "USE 'CATALOG' FOR FULL DATAPOINT DOS DISK DIRECTORY LISTING.",
		"dir": "USE 'CATALOG' FOR FULL DATAPOINT DOS DISK DIRECTORY LISTING.",
		"date": "CURRENT SYSTEM DATE: 10/22/72  (USE 'DATE MM/DD/YY' TO UPDATE)",
		"ctos": (
			"CTOS (CASSETTE TAPE OPERATING SYSTEM) SUBSYSTEM:\n"
			+ "---------------------------------------------------------\n"
			+ "PREDECESSOR SYSTEM (1971):\n"
			+ "PRIMARY CASSETTE DRIVE A: PHILIPS COMPACT CASSETTE [ONLINE]\n"
			+ "SECONDARY CASSETTE DRIVE B: PHILIPS COMPACT CASSETTE [READY]\n"
			+ "TAPE SPEED: 7.5 IPS • CAPACITY: ~130 KB PER CASSETTE\n"
			+ "RECORD FORMAT: 128-BYTE DATA BLOCKS WITH 16-BIT CRC\n"
			+ "NOTE: CTOS PROVIDED THE FIRST WORKSTATION TAPE OS BEFORE\n"
			+ "THE INTRODUCTION OF DIABLO CARTRIDGE DISKS AND DATAPOINT DOS."
		),
		"datashare": (
			"DATASHARE MULTI-USER TIMESHARING SUBSYSTEM (PREVIEW 1973):\n"
			+ "---------------------------------------------------------\n"
			+ "FUTURE EXPANSION NOTE (1973):\n"
			+ "TURNS THIS SINGLE DATAPOINT 2200 INTO A MULTI-USER MAINFRAME\n"
			+ "ALTERNATIVE RUNNING THE DATABUS COMPILER.\n"
			+ "SUPPORTS UP TO 16 REMOTE SLAVE TERMINALS (DATAPOINT 3600/3360)\n"
			+ "CONNECTED OVER ASYNCHRONOUS CURRENT-LOOP / RS-232 LINES.\n"
			+ "DIRECT TECHNOLOGICAL ANCESTOR OF ARCNET (1977), THE WORLD'S\n"
			+ "FIRST COMMERCIALLY INSTALLED LOCAL AREA NETWORK."
		),
		"databus": (
			"DATABUS HIGH-LEVEL BUSINESS LANGUAGE COMPILER V2.0 (CTC 1972)\n"
			+ "SOURCE: /SYS/LEDGER.TXT   OBJECT: /SYS/LEDGER.CMD\n"
			+ "PASS 1: GENERATING 8-BIT PSEUDOCODE...\n"
			+ "PASS 2: RESOLVING DATA DESCRIPTORS AND KEYED INDEXES...\n"
			+ "0 ERRORS DETECTED. COMPILED 142 STATEMENTS. OBJECT SAVED."
		),
		"diablo": (
			"DIABLO SERIES 30 REMOVABLE CARTRIDGE DISK DRIVE 0:\n"
			+ "STATUS: ONLINE • SPINDLE SPEED: 2400 RPM • HEAD COUNT: 2\n"
			+ "CYLINDERS: 408 • CAPACITY: 2.5 MEGABYTES • SEEK TIME: 70 MS\n"
			+ "MEDIA: SINGLE REMOVABLE TOP-LOADING MAGNETIC DISK CARTRIDGE"
		),
		"tape": "CASSETTE DECK A: REWOUND TO HEAD-OF-TAPE. CASSETTE DECK B: READY.",
		"dump": (
			"REGISTER & MEMORY DUMP (CTC 8-BIT DISCRETE MSI PROCESSOR):\n"
			+ "  A=44 B=02 C=10 D=00 E=22 H=04 L=1A  SP=0007 PC=01A0\n"
			+ "  FLAGS: [C=0 Z=1 S=0 P=1] (INTEL 8008 PRE-SILICON REGISTER SET)\n"
			+ "  MEMORY AT 01A0: 06 44 26 04 2E 1A 7E 12 13 23 C2 A0 01"
		),
		"info": (
			"DATAPOINT 2200 TYPE II (CTC 1972)\n"
			+ "FIRST WORKSTATION IN HISTORY • ARCHITECTURAL ANCESTOR OF X86\n"
			+ "RUNNING DATAPOINT DOS 2.1 WITH DIABLO 2.5MB DISK DRIVE"
		)
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "DATAPOINT 2200 SYSTEM CONSOLE (12x80 CRT)",
			"type": "terminal",
			"pos": Vector2(120, 52),
			"size": Vector2(580, 320),
			"content": ""
		},
		{
			"id": "ledger",
			"title": "Chase Manhattan / Insurance Ledger — Entry #1042",
			"type": "text",
			"pos": Vector2(530, 370),
			"size": Vector2(460, 240),
			"content": (
				"ACCOUNTING BATCH: 72-10-A      OPERATOR: OP-04     DATE: 10/22/72\n"
				+ "----------------------------------------------------------------\n"
				+ "ACCT #      CLIENT NAME           DEBIT ($)      CREDIT ($)\n"
				+ "----------------------------------------------------------------\n"
				+ "1004-92     HOUSTON MARITIME                   12,450.00\n"
				+ "1008-14     SAN ANTONIO PACKING   4,230.50\n"
				+ "1012-77     LONE STAR REFINING                 38,910.00\n"
				+ "----------------------------------------------------------------\n"
				+ "BATCH BALANCE: +$47,129.50      CRC VERIFIED: OK\n"
				+ "RECORD BUFFERED TO DIABLO DISK DRIVE 0 [CYLINDER 42, SECTOR 3]"
			)
		},
		{
			"id": "specs",
			"title": "CTC Architecture // 8-Bit Discrete MSI Processor",
			"type": "monitor",
			"pos": Vector2(115, 415),
			"size": Vector2(410, 240),
			"content": (
				"COMPUTER TERMINAL CORPORATION • SAN ANTONIO, TEXAS\n"
				+ "MODEL: DATAPOINT 2200 TYPE II (DESKTOP WORKSTATION)\n"
				+ "----------------------------------------------------------------\n"
				+ "CPU: 8-Bit Discrete MSI/SSI TTL Logic Board (~100 ICs)\n"
				+ "Instruction Set: CTC 8-Bit (Commissioned as Intel 8008 / x86 Root)\n"
				+ "Memory: 16 KB RAM (Shift Registers / Intel 1101/1103)\n"
				+ "Storage: Dual Digital Cassette Drives + Diablo 2.5MB Cartridge\n"
				+ "Screen: 7-Inch P31 Green Phosphor CRT (12 Lines x 80 Columns)\n"
				+ "Predecessor: CTOS (Cassette Tape OS, 1971)\n"
				+ "Future: Datashare Timesharing (1973) & ARCNET (1977)"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_terminal", "label": "Console", "glyph": "[:_]", "target_window_id": "terminal"},
		{"id": "icon_ledger", "label": "DATABUS\nLedger", "glyph": "[$$$]", "target_window_id": "ledger"},
		{"id": "icon_specs", "label": "Hardware\nSpecs", "glyph": "[CTC]", "target_window_id": "specs"}
	]

	p.fan_base_freq = 110.0
	p.fan_noise_level = 0.22
	p.hdd_seek_interval_range = Vector2(3.5, 8.0)
	return p


# ==============================================================================
# 9. UBUNTU 10.04 LTS (LUCID LYNX) - APRIL 2010
# THE ALEXNET WORKSTATION (2012) & THE PARADIGM SHIFT TO MODERN GPU AI
# ==============================================================================
static func _build_ubuntu_1004() -> OSProfile:
	var p := OSProfile.new()
	p.id = "ubuntu_1004"
	p.category = "UNIX & Alt-OS"
	p.display_name = "Ubuntu 10.04 LTS (AlexNet Workstation)"
	p.short_name = "Ubuntu 10.04"
	p.release_year = "2010"
	p.has_crt = false
	p.aspect_ratio = "16:9"
	p.vendor = "Canonical Ltd. / U of T Machine Learning Group"
	p.architecture_summary = "x86_64 • Linux 2.6.32-21 • Dual NVIDIA GTX 580 (Fermi CUDA) • GNOME 2.30 Ambiance"
	p.hardware_profile = "AlexNet AI Rig (Dual GTX 580 Confirmed; Host Inferred) • Core i7 • 16GB DDR3 • 1200W PSU"
	p.description = (
		"The hardware zero-point of the modern deep learning revolution and the twilight of classic desktop Linux. "
		+ "Released in April 2010, Ubuntu 10.04 LTS ('Lucid Lynx') introduced the signature aubergine 'Ambiance' theme "
		+ "and relocated window controls to the top-left, foreshadowing the impending transition to the Unity desktop. "
		+ "In 2011–2012 at the University of Toronto, researchers Alex Krizhevsky, Ilya Sutskever, and Geoffrey Hinton "
		+ "deployed a contemporary low-overhead Linux environment to host 'cuda-convnet' across two high-wattage NVIDIA GeForce "
		+ "GTX 580 Fermi GPUs—splitting the 60-million parameter AlexNet neural network in half and shattering the ImageNet benchmark "
		+ "(15.3% error vs 26.2%), marking the paradigm shift to modern compute-driven AI. Crucially, while the dual 3GB GeForce GTX 580 "
		+ "graphics cards are documented fact, the rest of the information about the workstation is unknown and is inferred from what would "
		+ "have likely been used at the time, unless Alex, Ilya, or Geoff eventually confirm what it ran on."
	)

	p.bios_header = (
		"American Megatrends Inc. (AMI) BIOS v0402                    ASUS P9X79 Deluxe Workstation\n"
		+ "Intel(R) Core(TM) i7-3930K CPU @ 3.20GHz                    PCIe 2.0: 2x NVIDIA GeForce GTX 580 3GB"
	)
	p.boot_bg_color = Color("110816")
	p.boot_text_color = Color("f4eff6")
	p.boot_logs = [
		{"text": "AMI BIOS (C) 2011 American Megatrends, Inc. (Intel X79 / Sandy Bridge-E)", "delay": 0.90, "sfx": "fan_spinup", "color": "#e0e0e0"},
		{"text": "Intel(R) Core(TM) i7-3930K CPU @ 3.20GHz (6 Cores, 12 Threads)", "delay": 1.10, "sfx": "beep", "color": "#e0e0e0"},
		{"text": "Memory Passed: 16384MB DDR3-1600 Quad-Channel Interleaved (9-9-9-24)", "delay": 1.25, "sfx": "", "color": "#e0e0e0"},
		{"text": "PCIe Bus 02:00.0: NVIDIA GeForce GTX 580 (512 CUDA Cores, 3072MB GDDR5)", "delay": 1.05, "sfx": "fan_spinup", "color": "#76b900"},
		{"text": "PCIe Bus 03:00.0: NVIDIA GeForce GTX 580 (512 CUDA Cores, 3072MB GDDR5)", "delay": 1.05, "sfx": "", "color": "#76b900"},
		{"text": "SATA Port 1: WDC WD1002FAEX 1.0TB 7200 RPM 64MB Cache (ImageNet Dataset)", "delay": 1.15, "sfx": "hdd_click", "color": "#b8b8b8"},
		{"text": "", "delay": 0.40, "sfx": "", "color": ""},
		{"text": "Booting 'Ubuntu 10.04.4 LTS, kernel 2.6.32-21-generic'...", "delay": 0.85, "sfx": "", "color": "#dd4814"},
		{"text": "Loading Linux 2.6.32-21-generic ...", "delay": 0.90, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "Loading initial ramdisk ...", "delay": 1.05, "sfx": "hdd_click", "color": "#c8c8c8"},
		{"text": "[    0.000000] Linux version 2.6.32-21-generic (buildd@alligator) (gcc 4.4.3)", "delay": 0.60, "sfx": "", "color": "#9ec49e"},
		{"text": "[    1.120404] nvidia: module license 'NVIDIA' taints kernel.", "delay": 0.65, "sfx": "", "color": "#76b900"},
		{"text": "[    1.148012] NVRM: loading NVIDIA UNIX x86_64 Kernel Module 295.40", "delay": 0.75, "sfx": "hdd_burst", "color": "#76b900"},
		{"text": "[    1.152008] NVRM: GPU 0: GeForce GTX 580 (3072 MB VRAM, 512 CUDA cores)", "delay": 0.60, "sfx": "", "color": "#a8e063"},
		{"text": "[    1.156014] NVRM: GPU 1: GeForce GTX 580 (3072 MB VRAM, 512 CUDA cores)", "delay": 0.60, "sfx": "", "color": "#a8e063"},
		{"text": "[    1.160100] nvidia-uvm: Unified Memory / Peer-to-Peer DMA initialized.", "delay": 0.70, "sfx": "", "color": "#a8e063"},
		{"text": " * Starting Plymouth boot splash (Ambiance aubergine)...                 [ OK ]", "delay": 0.90, "sfx": "", "color": "#dd4814"},
		{"text": " * Mounting local filesystems (ext4)...                                 [ OK ]", "delay": 0.90, "sfx": "hdd_click", "color": "#dd4814"},
		{"text": " * Initializing CUDA 4.2 Compute Toolkit & cuBLAS...                   [ OK ]", "delay": 1.10, "sfx": "", "color": "#76b900"},
		{"text": " * Starting GNOME Display Manager (gdm) [Ambiance Theme]...             [ OK ]", "delay": 1.30, "sfx": "hdd_burst", "color": "#ffffff"}
	]

	p.chrome_style = "ubuntu_ambiance"
	p.desktop_bg_color = Color("2c001e")
	p.desktop_secondary_color = Color("77216f")
	p.panel_bg_color = Color("1c191a")
	p.panel_text_color = Color("dfdbd2")
	p.window_bg_color = Color("edeceb")
	p.window_text_color = Color("2c2c2c")
	p.window_border_color = Color("3c3b37")
	p.titlebar_active_color = Color("3c3b37")
	p.titlebar_active_gradient_end = Color("2b2a26")
	p.titlebar_inactive_color = Color("484643")
	p.titlebar_text_color = Color("ffffff")
	p.accent_color = Color("dd4814")

	p.terminal_title = "alex@alexnet-node0: ~/cuda-convnet"
	p.terminal_bg_color = Color("1a0a1e")
	p.terminal_fg_color = Color("ffffff")
	p.terminal_prompt = "alex@alexnet-node0:~/cuda-convnet$ "
	p.terminal_welcome_banner = (
		"Ubuntu 10.04.4 LTS (GNU/Linux 2.6.32-21-generic x86_64)\n"
		+ "NVIDIA CUDA Driver Version: 295.40  •  CUDA Runtime Version: 4.2\n"
		+ "GPU 0: GeForce GTX 580 (512 cores @ 1.54GHz, 3072 MB GDDR5)\n"
		+ "GPU 1: GeForce GTX 580 (512 cores @ 1.54GHz, 3072 MB GDDR5)\n"
		+ "Type 'nvidia-smi', 'train', 'cuda-convnet', 'imagenet', 'unity', or 'help'."
	)

	p.terminal_commands = {
		"nvidia-smi": (
			"+-----------------------------------------------------------------------------+\n"
			+ "| NVIDIA-SMI 295.40                 Driver Version: 295.40                    |\n"
			+ "|-------------------------------+----------------------+----------------------+\n"
			+ "| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |\n"
			+ "| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |\n"
			+ "|===============================+======================+======================|\n"
			+ "|   0  GeForce GTX 580      On  | 0000:02:00.0     Off |                  N/A |\n"
			+ "| 85%   82C    P0   241W / 244W |   2884MB /  3072MB |     98%      Default |\n"
			+ "|-------------------------------+----------------------+----------------------|\n"
			+ "|   1  GeForce GTX 580      On  | 0000:03:00.0     Off |                  N/A |\n"
			+ "| 86%   84C    P0   244W / 244W |   2912MB /  3072MB |     99%      Default |\n"
			+ "+-------------------------------+----------------------+----------------------+\n"
			+ "| Processes:                                                       GPU Memory |\n"
			+ "|  GPU       PID  Type  Process name                               Usage      |\n"
			+ "|=============================================================================|\n"
			+ "|    0      4128     C  python ./convdata.py (cuda-convnet)             2880MB |\n"
			+ "|    1      4128     C  python ./convdata.py (cuda-convnet)             2908MB |\n"
			+ "+-----------------------------------------------------------------------------+"
		),
		"train": (
			"[alex@alexnet-node0:~/cuda-convnet]$ python convdata.py --data-path=./imagenet --train-range=1-90\n"
			+ "Initialized ImageNet dataset: 1,281,167 training images in 1000 categories.\n"
			+ "Allocating model across dual Fermi architecture:\n"
			+ "  GPU 0: Conv1, Conv2(top), Conv3, Conv4(top), Conv5(top), FC6, FC7\n"
			+ "  GPU 1: Conv1, Conv2(bot), Conv3, Conv4(bot), Conv5(bot), FC6, FC7\n"
			+ "Peer-to-Peer PCIe DMA active for inter-GPU convolution synchronization.\n"
			+ "Epoch 84/90 [Batch 1200/1280] Step Time: 452ms (2,240 img/sec)\n"
			+ "Training Loss: 1.412 | Validation Top-1: 37.5% | Validation Top-5: 15.3% (RECORD)"
		),
		"cuda-convnet": (
			"cuda-convnet (Alex Krizhevsky, University of Toronto, 2012):\n"
			+ "High-performance C++/CUDA framework for training deep convolutional neural networks.\n"
			+ "Features:\n"
			+ "  • Explicit multi-GPU model parallelism across two GeForce GTX 580 3GB cards\n"
			+ "  • Hand-tuned assembly CUDA matrix multiplication and 2D convolution kernels\n"
			+ "  • Cross-GPU synchronization at Conv2, Conv4, Conv5, and FC6 layers\n"
			+ "  • Zero-copy memory pooling and asynchronous host-to-device streaming"
		),
		"imagenet": (
			"ILSVRC 2012 ImageNet Benchmark Dataset:\n"
			+ "  • Training Images  : 1,281,167 JPEGs (256x256 downsampled)\n"
			+ "  • Validation Set   : 50,000 JPEGs\n"
			+ "  • Test Set         : 100,000 JPEGs\n"
			+ "  • Classes / Labels : 1,000 object categories\n"
			+ "  • Disk Footprint   : 27 GB on Western Digital Caviar Black SATA drive\n"
			+ "  • On-the-Fly CPU Augmentation: 224x224 random crops, horizontal flips, PCA RGB jitter"
		),
		"unity": (
			"Ubuntu 10.04 LTS ('Lucid Lynx') Desktop Transition Note:\n"
			+ "  • The final Long Term Support (LTS) release powered by classic GNOME 2.30.\n"
			+ "  • Canonical introduced 'Light: Soft Software' rebranding and moved window buttons\n"
			+ "    to the top-left (close,minimize,maximize:) to prepare users for the vertical launcher.\n"
			+ "  • The Unity desktop debuted on Ubuntu Netbook Edition 10.10, and officially replaced\n"
			+ "    GNOME on the main desktop in Ubuntu 11.04 ('Natty Narwhal')."
		),
		"ls": "checkpoints  convdata.py  cuda-convnet  data  example-layers  imagenet  src  train.py",
		"uname -a": "Linux alexnet-node0 2.6.32-21-generic #32-Ubuntu SMP Fri Apr 16 08:09:38 UTC 2010 x86_64 GNU/Linux",
		"lsb_release -a": "Distributor ID: Ubuntu\nDescription:    Ubuntu 10.04.4 LTS\nRelease:        10.04\nCodename:       lucid",
		"top": (
			"top - 14:22:04 up 6 days, 14:12,  2 users,  load average: 11.84, 11.62, 11.45\n"
			+ "Tasks: 168 total,   2 running, 166 sleeping,   0 stopped,   0 zombie\n"
			+ "Cpu(s): 88.4%us, 10.2%sy,  0.0%ni,  1.2%id,  0.2%wa,  0.0%hi,  0.0%si\n"
			+ "Mem:  16428416k total, 15124920k used,  1303496k free,   284192k buffers\n"
			+ "Swap:  8388604k total,   421008k used,  7967596k free,  9842104k cached"
		),
		"info": (
			"Ubuntu 10.04 LTS 'Lucid Lynx' // AlexNet Workstation (2012)\n"
			+ "Hardware Zero-Point of Modern Deep Learning & GPU Acceleration\n"
			+ "Confirmed Hardware: 2x NVIDIA GeForce GTX 580 3GB (Fermi GF110)\n"
			+ "Inferred Specs    : Host CPU/motherboard/RAM/chassis inferred (pending author confirmation)\n"
			+ "Desktop Environment: GNOME 2.30 Ambiance (Aubergine / Left Window Controls)"
		)
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "alex@alexnet-node0: ~/cuda-convnet",
			"type": "terminal",
			"pos": Vector2(130, 50),
			"size": Vector2(580, 330),
			"content": ""
		},
		{
			"id": "monitor",
			"title": "AlexNet 2012 ILSVRC Training Monitor (Epoch 84/90)",
			"type": "monitor",
			"pos": Vector2(520, 360),
			"size": Vector2(480, 270),
			"content": (
				"EPOCH: 84 / 90  •  BATCH: 1200 / 1280  •  STEP TIME: 452 ms\n"
				+ "-----------------------------------------------------------------\n"
				+ "Model Architecture: 5 Convolutional + 3 Fully-Connected Layers\n"
				+ "GPU 0 (Upper Net) : 98% UTIL • 2884 MB VRAM • 82°C • 241W\n"
				+ "GPU 1 (Lower Net) : 99% UTIL • 2912 MB VRAM • 84°C • 244W\n"
				+ "Cross-GPU P2P DMA : Layers Conv2, Conv4, Conv5, FC6 Sync OK\n"
				+ "-----------------------------------------------------------------\n"
				+ "Top-1 Training Loss : 1.412  (Validation Top-1 Error: 37.5%)\n"
				+ "Top-5 Benchmark Rate: 15.3% (State-of-the-Art vs Traditional 26.2%)\n"
				+ "Speed: 2,240 forward passes / second • ETA Completion: 18h 22m"
			)
		},
		{
			"id": "unity_notes",
			"title": "Ubuntu 10.04 LTS 'Lucid Lynx' // Archival Notes",
			"type": "text",
			"pos": Vector2(120, 420),
			"size": Vector2(390, 230),
			"content": (
				"ALEXNET WORKSTATION ARCHIVAL NOTES\n"
				+ "-----------------------------------------------------------------\n"
				+ "• Confirmed Hardware: 2x NVIDIA GeForce GTX 580 (3GB VRAM each)\n"
				+ "• Inferred Specifications: Host CPU, motherboard, RAM, power supply,\n"
				+ "  and exact Linux distro are unrecorded and inferred from period\n"
				+ "  requirements, unless Alex, Ilya, or Geoff confirm them.\n"
				+ "• Visual Identity: 'Light: Soft Software' (Ambiance GTK aubergine)\n"
				+ "• Window Controls Relocated to Top-Left (Precursor to Unity)\n"
				+ "• Final Long Term Support (LTS) release of classic GNOME 2!"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_terminal", "label": "CUDA\nTerminal", "glyph": "[>_]", "target_window_id": "terminal"},
		{"id": "icon_train", "label": "AlexNet\nMonitor", "glyph": "[CNN]", "target_window_id": "monitor"},
		{"id": "icon_unity", "label": "Lucid\nNotes", "glyph": "[UBT]", "target_window_id": "unity_notes"}
	]

	p.fan_base_freq = 155.0
	p.fan_noise_level = 0.38
	p.hdd_seek_interval_range = Vector2(2.0, 5.0)
	return p


# ==============================================================================
# 10. EVGA SR-2 "SUPER RECORD" TRIPLE-BOOT WORKSTATION - LATE 2011
# THE PINNACLE AND FIERY TWILIGHT OF BRUTE-FORCE ENTHUSIAST COMPUTING
# ==============================================================================
static func _build_evga_sr2() -> OSProfile:
	var p := OSProfile.new()
	p.id = "evga_sr2"
	p.category = "PC & OS/2"
	p.display_name = "EVGA SR-2 Super Record (Triple-Boot)"
	p.short_name = "EVGA SR-2"
	p.release_year = "2011"
	p.has_crt = false
	p.aspect_ratio = "16:9"
	p.vendor = "EVGA / Lian Li Custom HPTX Workstation"
	p.architecture_summary = "Dual LGA1366 / Intel 5520 / Triple-Boot (x86_64)"
	p.hardware_profile = "EVGA Classified SR-2 • 2x Xeon X5690 @ 4.4GHz • 48GB • 4x FirePro V9800"
	p.description = (
		"The EVGA SR-2 'Super Record' Triple-Boot Workstation represents the absolute pinnacle—and the "
		+ "fiery twilight—of enthusiast desktop computing in late 2011. Built around the legendary EVGA "
		+ "Classified SR-2 motherboard, this system demonstrates the rare convergence of enterprise-grade server "
		+ "hardware with extreme overclocking capabilities and multi-OS versatility. Featuring dual 32nm Intel "
		+ "Xeon X5690 processors liquid-overclocked to 4.40 GHz across 24 threads, 48GB of triple-channel Corsair "
		+ "Dominator GT DDR3, and a quad-GPU array of ATI FirePro V9800 workstation graphics cards hardware-synchronized "
		+ "via a dedicated ATI FirePro S400 Genlock/Framelock module driving up to 24 synchronized displays simultaneously, "
		+ "this 2400W dual-PSU monolith pushed the limits of brute-force computing before the industry pivoted to "
		+ "high-efficiency architectures, Ryzen, Threadripper, and Apple Silicon. A complex triple-boot environment "
		+ "utilizes three dedicated physical solid-state drives to run Windows 7 Ultimate SP1, Mac OS X 10.7 Lion "
		+ "(via Chameleon Hackintosh bootloader), and Oracle Solaris 11."
	)

	p.bios_header = (
		"EVGA CLASSIFIED SR-2 AWARD BIOS v1.21 (E759) • INTEL 5520 / DUAL NF200\n"
		+ "2x INTEL XEON X5690 @ 4.40 GHz (12C/24T) • 48GB CORSAIR DOMINATOR GT • 4x FIREPRO V9800 + S400"
	)
	p.boot_bg_color = Color("06080c")
	p.boot_text_color = Color("e2e8f0")

	p.boot_logs = [
		{"text": "EVGA Classified SR-2 (E759) AwardBIOS v1.21 (Release 10/28/2011)", "delay": 0.65, "sfx": "fan_spinup", "color": "e2e8f0"},
		{"text": "Chipset: Intel 5520 (Tylersburg-36D) + ICH10R + Dual NVIDIA NF200 Bridge (7x PCIe 2.0 x16)", "delay": 0.70, "sfx": "hdd_click", "color": "94a3b8"},
		{"text": "CPU 0: Intel(R) Xeon(R) CPU X5690 @ 3.46GHz [Liquid O/C: 200 BCLK x 22 = 4.40 GHz]", "delay": 0.75, "sfx": "", "color": "38bdf8"},
		{"text": "CPU 1: Intel(R) Xeon(R) CPU X5690 @ 3.46GHz [Liquid O/C: 200 BCLK x 22 = 4.40 GHz]", "delay": 0.75, "sfx": "", "color": "38bdf8"},
		{"text": "Hyper-Threading: ENABLED (12 Physical Cores / 24 Logical Processors Active)", "delay": 0.65, "sfx": "beep", "color": "4ade80"},
		{"text": "Memory Testing: 48,128 MB Corsair Dominator GT DDR3-1600 (Triple-Channel x2) ... OK", "delay": 0.85, "sfx": "", "color": "facc15"},
		{"text": "PCIe Gen2 Link 1-4: 4x ATI FirePro V9800 4GB GDDR5 (6,400 Stream Processors / 16GB VRAM)", "delay": 0.80, "sfx": "", "color": "f87171"},
		{"text": "ATI FirePro S400 Module: FRAMELOCK & GENLOCK LOCKED (24 Displays / 11520x4320 Eyefinity)", "delay": 0.85, "sfx": "hdd_burst", "color": "4ade80"},
		{"text": "Marvell 88SE9128 SATA3 6Gbps Controller Initialized (3x Dedicated Physical SSDs):", "delay": 0.65, "sfx": "", "color": "94a3b8"},
		{"text": "  Port 0: OCZ-VERTEX3 240GB SSD -> Windows 7 Ultimate SP1 (x64) [NTFS Boot Volume]", "delay": 0.60, "sfx": "hdd_click", "color": "60a5fa"},
		{"text": "  Port 1: OCZ-VERTEX3 240GB SSD -> Mac OS X 10.7 Lion (x86_64) [Chameleon v2.1 r1684]", "delay": 0.60, "sfx": "hdd_click", "color": "a78bfa"},
		{"text": "  Port 2: OCZ-VERTEX3 240GB SSD -> Oracle Solaris 11 11/11 (x86) [GRUB2 ZFS Root Pool]", "delay": 0.60, "sfx": "hdd_click", "color": "f472b6"},
		{"text": "ICH10R SATA2: 4x Western Digital Caviar Black 2TB (8TB Storage Pools across NTFS/HFS+/ZFS)", "delay": 0.70, "sfx": "hdd_burst", "color": "94a3b8"},
		{"text": "Power Supply Telemetry: Dual Corsair AX1200 80+ Gold (2400W Combined / 920W Idle Load)", "delay": 0.75, "sfx": "", "color": "fb923c"},
		{"text": "Thermal Telemetry: Dual EK-Supreme HF Blocks + Dual 480mm Rads (CPU0: 38°C / CPU1: 41°C)", "delay": 0.70, "sfx": "", "color": "38bdf8"},
		{"text": "Press [F12] or [BBS POPUP] for BIOS Boot Device Selection...", "delay": 0.90, "sfx": "hdd_burst", "color": "facc15"},
		{"text": "BIOS BBS Default: Booting SATA Port 0 (OCZ Vertex 3) -> Windows Boot Manager...", "delay": 0.80, "sfx": "hdd_burst", "color": "60a5fa"},
		{"text": "Starting Windows...", "delay": 0.90, "sfx": "", "color": "e2e8f0"},
		{"text": "[OK] Windows 7 Ultimate SP1 (Build 7601) x64 Kernel loaded", "delay": 0.70, "sfx": "", "color": "4ade80"},
		{"text": "[OK] ATI FirePro Catalyst 8.911 Workstation Driver initialized", "delay": 0.70, "sfx": "", "color": "4ade80"},
		{"text": "[OK] S400 Hardware Genlock: 24 Displays locked in frame sync @ 59.94 Hz", "delay": 0.75, "sfx": "hdd_burst", "color": "4ade80"},
		{"text": "[OK] Desktop Window Manager (Aero DWM Compositor) ready.", "delay": 0.70, "sfx": "", "color": "4ade80"},
	]

	# Default sub-profile: Windows 7 Ultimate SP1
	apply_sr2_sub_profile(p, "win7")

	p.fan_base_freq = 135.0
	p.fan_noise_level = 0.32
	p.hdd_seek_interval_range = Vector2(2.5, 6.0)
	return p


static func apply_sr2_sub_profile(p: OSProfile, sub_os_id: String) -> void:
	match sub_os_id:
		"lion":
			p.display_name = "EVGA SR-2 Super Record // Mac OS X 10.7 Lion (x86_64)"
			p.short_name = "OS X Lion"
			p.chrome_style = "aqua_pinstripe"
			p.desktop_bg_color = Color("1e2638")
			p.desktop_secondary_color = Color("334155")
			p.panel_bg_color = Color("e2e8f0")
			p.panel_text_color = Color("0f172a")
			p.window_bg_color = Color("f1f5f9")
			p.window_text_color = Color("0f172a")
			p.window_border_color = Color("64748b")
			p.titlebar_active_color = Color("94a3b8")
			p.titlebar_inactive_color = Color("cbd5e1")
			p.titlebar_text_color = Color("0f172a")
			p.accent_color = Color("3b82f6")

			p.terminal_title = "admin@sr2-mac-pro: ~ (bash - 80x24)"
			p.terminal_bg_color = Color("0f172a")
			p.terminal_fg_color = Color("f8fafc")
			p.terminal_prompt = "sr2-mac-pro:~ admin$ "
			p.terminal_welcome_banner = (
				"Last login: Mon Oct 24 10:14:02 on ttys000\n"
				+ "Mac OS X Version 10.7 (Build 11A511) [Darwin Kernel 11.0.0]\n"
				+ "EVGA SR-2 Hackintosh Workstation • 24 Virtual Cores • 48GB RAM\n"
				+ "Chameleon v2.1-r1684 • FakeSMC 4.2.0 • 4x FirePro V9800 OpenCL Ready\n"
				+ "Type 'help' for available commands or 'switch-win7' to change OS."
			)

			p.terminal_commands = {
				"sw_vers": "ProductName:\tMac OS X\nProductVersion:\t10.7\nBuildVersion:\t11A511",
				"uname -a": "Darwin sr2-mac-pro.local 11.0.0 Darwin Kernel Version 11.0.0: Sat Jun 18 12:56:35 PDT 2011; root:xnu-1699.22.73~1/RELEASE_X86_64 x86_64",
				"system_profiler": (
					"Hardware Overview:\n"
					+ "  Model Name: Mac Pro (Mid 2010 / EVGA Classified SR-2 Hackintosh)\n"
					+ "  Model Identifier: MacPro5,1\n"
					+ "  Processor Name: 6-Core Intel Xeon (Westmere-EP X5690)\n"
					+ "  Processor Speed: 4.40 GHz (Overclocked Liquid-Cooled)\n"
					+ "  Number of Processors: 2\n"
					+ "  Total Number of Cores: 12 (24 Threads with Hyper-Threading)\n"
					+ "  L2 Cache (per Core): 256 KB\n"
					+ "  L3 Cache (per Processor): 12 MB\n"
					+ "  Memory: 48 GB 1600 MHz DDR3 Corsair Dominator GT\n"
					+ "  Boot ROM Version: Chameleon v2.1-r1684 (Apple EFI v1.30 Emulation)\n"
					+ "  Graphics: 4x ATI FirePro V9800 4096 MB GDDR5 (S400 Genlock Synced)"
				),
				"clinfo": (
					"OpenCL Platform: Apple OpenCL 1.1\n"
					+ "  Device 0: 4x Cypress XT (ATI FirePro V9800 Workstation)\n"
					+ "  Total Compute Units: 80 (6,400 Stream Processors)\n"
					+ "  Global Memory: 16,384 MB GDDR5\n"
					+ "  Max Clock Frequency: 850 MHz\n"
					+ "  Double-Precision Support: cl_khr_fp64 enabled\n"
					+ "  Status: Online • Accelerated Final Cut Pro 7 / Color 1.5 Pipeline"
				),
				"fcp": (
					"Apple Final Cut Studio Pro 7 // Color 1.5 Real-Time Engine\n"
					+ "--------------------------------------------------------\n"
					+ "Active Sequence: 4K ProRes 422 HQ (3840x2160 @ 23.98 fps)\n"
					+ "GPU Acceleration: 4x FirePro V9800 OpenCL Primary Buffers\n"
					+ "Scratch Disk: 4x 2TB WD Caviar Black HFS+ Striped Array\n"
					+ "Playback Status: Real-time 4K Color Grade without drop frames."
				),
				"kextstat": (
					"Index Refs Address            Size       Name (Version)\n"
					+ "  112    0 0xffffff7f81a00000 0x12000    org.netkas.FakeSMC (4.2.0)\n"
					+ "  113    0 0xffffff7f81a15000 0x08000    org.tgvs.NullCPUPowerManagement (1.0.0)\n"
					+ "  114    2 0xffffff7f81a20000 0x48000    com.insanelymac.ATY_Init (1.3.1)\n"
					+ "  115    0 0xffffff7f81a69000 0x32000    com.insanelymac.AppleIntelE1000e (2.4.14)"
				),
				"switch-win7": "Switching active boot drive to SSD 0: Windows 7 Ultimate SP1 (x64)...",
				"switch-solaris": "Switching active boot drive to SSD 2: Oracle Solaris 11 (11/11)...",
				"bbs": "Opening BIOS Boot Device Selection (BBS) menu..."
			}

			p.default_windows = [
				{
					"id": "terminal",
					"title": "admin@sr2-mac-pro: ~ (bash)",
					"type": "terminal",
					"pos": Vector2(120, 50),
					"size": Vector2(560, 320),
					"content": ""
				},
				{
					"id": "fcp",
					"title": "Final Cut Studio Pro 7 // 4K ProRes Color Grade",
					"type": "monitor",
					"pos": Vector2(510, 350),
					"size": Vector2(500, 280),
					"content": (
						"FINAL CUT STUDIO PRO 7 • APPLE COLOR 1.5 PIPELINE\n"
						+ "---------------------------------------------------------\n"
						+ "Project: 'Fiery Twilight' (Feature Documentary 4K Master)\n"
						+ "Timeline Codec: Apple ProRes 422 HQ (3840x2160 10-Bit)\n"
						+ "Hardware Engine: 24 Cores @ 4.40GHz + 4x FirePro V9800\n"
						+ "Memory Footprint: 28.4 GB / 48 GB Allocated\n"
						+ "Real-time 3-Way Color Corrector: 60 fps Continuous Playback\n"
						+ "Display Output: Dual 27\" Apple LED Cinema IPS Displays"
					)
				},
				{
					"id": "switcher",
					"title": "EVGA SR-2 Multi-OS Boot Manager & BIOS BBS Switcher",
					"type": "text",
					"pos": Vector2(100, 390),
					"size": Vector2(390, 240),
					"content": (
						"EVGA CLASSIFIED SR-2 MULTI-OS BOOT MANAGER\n"
						+ "=========================================================\n"
						+ "Active OS: [2] Mac OS X 10.7 Lion (x86_64 Hackintosh)\n"
						+ "Boot SSD : SATA Port 1 - OCZ Vertex 3 240GB (HFS+)\n\n"
						+ "Switch OS immediately or reboot to BIOS BBS:\n"
						+ "• Type 'switch-win7' in Terminal for Windows 7 Ultimate\n"
						+ "• Type 'switch-solaris' in Terminal for Oracle Solaris 11\n"
						+ "• Press [ESC] or run 'bbs' to return to BIOS POST"
					)
				}
			]

			p.desktop_icons = [
				{"id": "icon_term", "label": "Terminal", "glyph": "[>_]", "target_window_id": "terminal"},
				{"id": "icon_fcp", "label": "Final Cut\nPro 7", "glyph": "[🎬]", "target_window_id": "fcp"},
				{"id": "icon_switcher", "label": "Multi-Boot\nSwitcher", "glyph": "[⚡]", "target_window_id": "switcher"}
			]

		"solaris":
			p.display_name = "EVGA SR-2 Super Record // Oracle Solaris 11 (11/11 x86_64)"
			p.short_name = "Solaris 11"
			p.chrome_style = "solaris_cde"
			p.desktop_bg_color = Color("0f1f33")
			p.desktop_secondary_color = Color("1a3556")
			p.panel_bg_color = Color("1e293b")
			p.panel_text_color = Color("e2e8f0")
			p.window_bg_color = Color("111c2a")
			p.window_text_color = Color("e2e8f0")
			p.window_border_color = Color("0284c7")
			p.titlebar_active_color = Color("0369a1")
			p.titlebar_inactive_color = Color("1e293b")
			p.titlebar_text_color = Color("ffffff")
			p.accent_color = Color("0284c7")

			p.terminal_title = "admin@sr2-solaris:~# (ksh93 - 80x24)"
			p.terminal_bg_color = Color("070c14")
			p.terminal_fg_color = Color("38bdf8")
			p.terminal_prompt = "admin@sr2-solaris:~# "
			p.terminal_welcome_banner = (
				"Oracle Solaris 11 11/11 x86 (SunOS 5.11)\n"
				+ "Copyright (c) 1983, 2011, Oracle and/or its affiliates. All rights reserved.\n"
				+ "EVGA SR-2 Super Record • 24 CPU threads • 48GB RAM • 8TB ZFS Storage Pool\n"
				+ "Type 'help' for Solaris commands or 'switch-win7' to change OS."
			)

			p.terminal_commands = {
				"zpool status": (
					"  pool: datapool\n"
					+ " state: ONLINE\n"
					+ "  scan: scrub repaired 0 in 1h42m with 0 errors on Sun Oct 23 04:12:00 2011\n"
					+ "config:\n"
					+ "\tNAME                       STATE     READ WRITE CKSUM\n"
					+ "\tdatapool                   ONLINE       0     0     0\n"
					+ "\t  raidz2-0                 ONLINE       0     0     0\n"
					+ "\t    c2t0d0 (WD2002FAEX)    ONLINE       0     0     0\n"
					+ "\t    c2t1d0 (WD2002FAEX)    ONLINE       0     0     0\n"
					+ "\t    c2t2d0 (WD2002FAEX)    ONLINE       0     0     0\n"
					+ "\t    c2t3d0 (WD2002FAEX)    ONLINE       0     0     0\n"
					+ "errors: No known data errors\n"
					+ "--------------------------------------------------------\n"
					+ "  pool: rpool\n"
					+ " state: ONLINE (OCZ-VERTEX3 240GB SATA3 SSD - SSD Port 2)"
				),
				"zfs list": (
					"NAME                         USED  AVAIL  REFER  MOUNTPOINT\n"
					+ "datapool                    3.41T  2.38T   128K  /datapool\n"
					+ "datapool/cad_vault          1.82T  2.38T  1.82T  /datapool/cad_vault\n"
					+ "datapool/render_frames       980G  2.38T   980G  /datapool/render_frames\n"
					+ "datapool/telemetry           610G  2.38T   610G  /datapool/telemetry\n"
					+ "rpool                       18.4G   205G  4.20G  /\n"
					+ "rpool/ROOT                  12.1G   205G    31K  legacy\n"
					+ "rpool/ROOT/solaris-11       12.1G   205G  12.1G  /"
				),
				"psrinfo -v": (
					"Status of virtual processors:\n"
					+ "  Status of processor 0-11: on-line since 10/24/2011 08:30:12 (Socket 0: Xeon X5690 @ 4.40GHz)\n"
					+ "  Status of processor 12-23: on-line since 10/24/2011 08:30:12 (Socket 1: Xeon X5690 @ 4.40GHz)\n"
					+ "  Total: 24 virtual processors operating at full liquid-cooled frequency."
				),
				"prtconf": (
					"System Configuration: Oracle Corporation SunOS x86 Workstation\n"
					+ "Memory size: 48,128 Megabytes (Triple-Channel Corsair Dominator GT)\n"
					+ "Device Nodes: 4x PCI-Express Cypress XT (ATI FirePro V9800 4GB)\n"
					+ "Display Sync: ATI FirePro S400 Genlock driver active on bus /pci@0/pci8086,3408"
				),
				"dtrace": (
					"DTrace script 'pcie_dma_bandwidth.d' active:\n"
					+ "  DEVICE                  DMA READ (MB/s)    DMA WRITE (MB/s)   LATENCY\n"
					+ "  FirePro V9800 [Card 0]  1,420.5 MB/s       880.2 MB/s         1.8 us\n"
					+ "  FirePro V9800 [Card 1]  1,390.1 MB/s       875.4 MB/s         1.9 us\n"
					+ "  FirePro V9800 [Card 2]  1,410.8 MB/s       882.0 MB/s         1.8 us\n"
					+ "  FirePro V9800 [Card 3]  1,405.2 MB/s       879.6 MB/s         1.8 us\n"
					+ "  ZFS ARC Cache Hit Rate: 98.6% (Hit/Miss: 1,482,901 / 21,040)"
				),
				"firepro-sync": "FirePro S400 Genlock: 24/24 Synced Displays @ 59.94 Hz (Zero frame drift)",
				"switch-win7": "Switching active boot drive to SSD 0: Windows 7 Ultimate SP1 (x64)...",
				"switch-lion": "Switching active boot drive to SSD 1: Mac OS X 10.7 Lion (x86_64)...",
				"bbs": "Opening BIOS Boot Device Selection (BBS) menu..."
			}

			p.default_windows = [
				{
					"id": "terminal",
					"title": "admin@sr2-solaris:~# (ksh93)",
					"type": "terminal",
					"pos": Vector2(120, 50),
					"size": Vector2(560, 320),
					"content": ""
				},
				{
					"id": "zfs",
					"title": "Oracle Solaris 11 ZFS Storage Administration",
					"type": "monitor",
					"pos": Vector2(510, 350),
					"size": Vector2(500, 280),
					"content": (
						"ORACLE SOLARIS 11 ZFS ENTERPRISE STORAGE POOL\n"
						+ "---------------------------------------------------------\n"
						+ "Storage Array: 4x 2TB WD Caviar Black (RAIDZ2 Configuration)\n"
						+ "Total Usable Capacity: 5.79 TB (Checksum Validation Active)\n"
						+ "Compression: lzjb Enabled (1.32x space savings)\n"
						+ "Self-Healing Scrub: 0 checksum errors, 0 disk faults\n"
						+ "ZFS ARC Cache: 36 GB allocated in Corsair Dominator RAM"
					)
				},
				{
					"id": "switcher",
					"title": "EVGA SR-2 Multi-OS Boot Manager & BIOS BBS Switcher",
					"type": "text",
					"pos": Vector2(100, 390),
					"size": Vector2(390, 240),
					"content": (
						"EVGA CLASSIFIED SR-2 MULTI-OS BOOT MANAGER\n"
						+ "=========================================================\n"
						+ "Active OS: [3] Oracle Solaris 11 (11/11 x86_64)\n"
						+ "Boot SSD : SATA Port 2 - OCZ Vertex 3 240GB (ZFS rpool)\n\n"
						+ "Switch OS immediately or reboot to BIOS BBS:\n"
						+ "• Type 'switch-win7' in Terminal for Windows 7 Ultimate\n"
						+ "• Type 'switch-lion' in Terminal for Mac OS X 10.7 Lion\n"
						+ "• Press [ESC] or run 'bbs' to return to BIOS POST"
					)
				}
			]

			p.desktop_icons = [
				{"id": "icon_term", "label": "Terminal", "glyph": "[>_]", "target_window_id": "terminal"},
				{"id": "icon_zfs", "label": "ZFS Pool\nManager", "glyph": "[ZFS]", "target_window_id": "zfs"},
				{"id": "icon_switcher", "label": "Multi-Boot\nSwitcher", "glyph": "[⚡]", "target_window_id": "switcher"}
			]

		_: # "win7"
			p.display_name = "EVGA SR-2 Super Record // Windows 7 Ultimate SP1 (x64)"
			p.short_name = "Windows 7"
			p.chrome_style = "win7_aero"
			p.desktop_bg_color = Color("0d233a")
			p.desktop_secondary_color = Color("1b4673")
			p.panel_bg_color = Color(0.06, 0.12, 0.20, 0.92)
			p.panel_text_color = Color("ffffff")
			p.window_bg_color = Color("0c1420")
			p.window_text_color = Color("e0e6ed")
			p.window_border_color = Color("2a4e7c")
			p.titlebar_active_color = Color("143b66")
			p.titlebar_inactive_color = Color("0e2238")
			p.titlebar_text_color = Color("ffffff")
			p.accent_color = Color("2563eb")

			p.terminal_title = "Command Prompt - cmd.exe (Administrator)"
			p.terminal_bg_color = Color("080c12")
			p.terminal_fg_color = Color("d1d5db")
			p.terminal_prompt = "C:\\Users\\Admin> "
			p.terminal_welcome_banner = (
				"Microsoft Windows [Version 6.1.7601]\n"
				+ "Copyright (c) 2009 Microsoft Corporation. All rights reserved.\n"
				+ "EVGA SR-2 Super Record • Dual Xeon X5690 @ 4.40GHz • 48GB RAM\n"
				+ "ATI FirePro S400 Genlock: 24 Displays Active (11520x4320 Eyefinity Wall)\n"
				+ "Type 'help' for available commands or 'switch-lion' to change OS."
			)

			p.terminal_commands = {
				"systeminfo": (
					"OS Name:                   Microsoft Windows 7 Ultimate SP1 (64-bit)\n"
					+ "OS Version:                6.1.7601 Service Pack 1 Build 7601\n"
					+ "System Manufacturer:       EVGA / Lian Li Custom HPTX Workstation\n"
					+ "System Model:              EVGA Classified SR-2 (270-WS-W555-A2)\n"
					+ "Processors:                2 Processor(s) Installed.\n"
					+ "                           [01]: Intel64 Family 6 Model 44 Stepping 2 @ 4400 Mhz (6 Cores/12 Threads)\n"
					+ "                           [02]: Intel64 Family 6 Model 44 Stepping 2 @ 4400 Mhz (6 Cores/12 Threads)\n"
					+ "BIOS Version:              Award Software International, Inc. 1.21, 10/28/2011\n"
					+ "Total Physical Memory:     48,128 MB (12x 4GB Corsair Dominator GT DDR3-1600 Triple-Channel)\n"
					+ "Available Physical Memory: 42,910 MB\n"
					+ "Graphics Cards:            4x ATI FirePro V9800 4GB GDDR5 (16GB Total VRAM)\n"
					+ "Display Genlock:           ATI FirePro S400 Hardware Frame Synchronization Module"
				),
				"dxdiag": (
					"DirectX Diagnostic Tool Version 6.01.7601.17514 64-bit\n"
					+ "---------------------------------------------------------\n"
					+ "DirectX Version: DirectX 11.0\n"
					+ "DDI Version: 11 • Feature Levels: 11_0, 10_1, 10_0, 9_3\n"
					+ "Display Devices: 4x ATI FirePro V9800 (6x Mini-DP outputs per card)\n"
					+ "Eyefinity SLS (Single Large Surface) Matrix: 6x4 = 24 Panels (11520 x 4320 @ 60Hz)\n"
					+ "Driver Name: aticfx64.dll,aticfx64.dll,aticfx32,aticfx32\n"
					+ "Driver Version: 8.911.0.0 (Catalyst Pro 2011)"
				),
				"firepro-s400": (
					"ATI FirePro S400 Synchronization Status:\n"
					+ "  Genlock Mode: Broadcast Studio Reference (House Sync NTSC/PAL/HD)\n"
					+ "  Framelock Status: LOCKED across all 4 GPUs\n"
					+ "  GPU 0 (Master): Slot 1 PCIe 2.0 x16 - Clock 850MHz, 4GB GDDR5 [Displays 1-6]\n"
					+ "  GPU 1 (Slave):  Slot 3 PCIe 2.0 x16 - S400 Bus In/Out [Displays 7-12]\n"
					+ "  GPU 2 (Slave):  Slot 5 PCIe 2.0 x16 - S400 Bus In/Out [Displays 13-18]\n"
					+ "  GPU 3 (Slave):  Slot 7 PCIe 2.0 x16 - S400 Bus In/Out [Displays 19-24]\n"
					+ "  Frame Drop Count: 0 • Phase Skew: <0.02 microseconds"
				),
				"eyefinity": (
					"AMD Eyefinity Multi-Display Control Panel:\n"
					+ "  Display Group: 24-Monitor Synchronized Video Wall\n"
					+ "  Grid Layout: 6 columns x 4 rows of 1920x1080 24\" IPS Displays\n"
					+ "  Total Resolution: 11,520 x 4,320 pixels (49.7 Megapixels total)\n"
					+ "  Bezel Compensation: Enabled (32px horizontal / 24px vertical)\n"
					+ "  Color Calibration: 10-bit per channel wide color gamut (Rec.709)"
				),
				"cpuz": (
					"CPU-Z 1.58 Report:\n"
					+ "  CPU: 2x Intel Xeon X5690 'Westmere-EP' (32nm LGA1366)\n"
					+ "  Base Clock (BCLK): 200.0 MHz (Stock 133.3 MHz)\n"
					+ "  Multiplier: x22.0 -> Core Speed: 4,400.0 MHz\n"
					+ "  QPI Link: 3,600.0 MHz (7.2 GT/s)\n"
					+ "  Vcore: 1.375 V (Dual EK-Supreme HF Custom Water Loop)\n"
					+ "  Memory: 48 GB Triple-Channel DDR3-1600 (7-8-7-20 1T @ 1.65V)"
				),
				"render": (
					"Autodesk 3ds Max 2012 / Chaos Group V-Ray 2.0 Benchmark:\n"
					+ "  Scene: 'Cathedral of Light' (4K Raytraced Interior with 12M Polys)\n"
					+ "  Active Threads: 24 (Dual Xeon X5690 @ 4.40GHz)\n"
					+ "  Global Illumination: Irradiance Map + Light Cache\n"
					+ "  Render Time: 1 min 42 sec (Record score for 2011 enthusiast hardware!)\n"
					+ "  Peak Power Draw: 1,840 Watts (Dual Corsair AX1200 load: 76.6%)"
				),
				"switch-lion": "Switching active boot drive to SSD 1: Mac OS X 10.7 Lion (x86_64)...",
				"switch-solaris": "Switching active boot drive to SSD 2: Oracle Solaris 11 (11/11)...",
				"bbs": "Opening BIOS Boot Device Selection (BBS) menu..."
			}

			p.default_windows = [
				{
					"id": "terminal",
					"title": "Command Prompt - cmd.exe",
					"type": "terminal",
					"pos": Vector2(120, 50),
					"size": Vector2(560, 320),
					"content": ""
				},
				{
					"id": "eyefinity",
					"title": "ATI FirePro Catalyst Workstation — 24-Display S400 Sync Console",
					"type": "monitor",
					"pos": Vector2(520, 350),
					"size": Vector2(500, 280),
					"content": (
						"ATI FIREPRO S400 HARDWARE FRAMELOCK & EYEFINITY WALL\n"
						+ "---------------------------------------------------------\n"
						+ "GPU Architecture: 4x ATI FirePro V9800 4GB (6,400 Stream Cores)\n"
						+ "Active Displays: 24 independent Mini-DP outputs @ 1920x1080 60Hz\n"
						+ "Combined Resolution: 11,520 x 4,320 SLS Desktop Matrix\n"
						+ "S400 Genlock State: LOCKED to Studio Reference (0 dropped frames)\n"
						+ "Primary Console: Dual 27-inch Color-Calibrated IPS Displays (2560x1440)\n"
						+ "Workloads: Military Simulation • CAVE VR • Broadcast Video Wall"
					)
				},
				{
					"id": "switcher",
					"title": "EVGA SR-2 Multi-OS Boot Manager & BIOS BBS Switcher",
					"type": "text",
					"pos": Vector2(100, 390),
					"size": Vector2(400, 240),
					"content": (
						"EVGA CLASSIFIED SR-2 MULTI-OS BOOT MANAGER\n"
						+ "=========================================================\n"
						+ "Active OS: [1] Microsoft Windows 7 Ultimate SP1 (x64)\n"
						+ "Boot SSD : SATA Port 0 - OCZ Vertex 3 240GB (NTFS)\n\n"
						+ "Switch OS immediately or reboot to BIOS BBS:\n"
						+ "• Type 'switch-lion' in Command Prompt for Mac OS X Lion\n"
						+ "• Type 'switch-solaris' in Command Prompt for Oracle Solaris 11\n"
						+ "• Press [ESC] or run 'bbs' to return to BIOS POST"
					)
				}
			]

			p.desktop_icons = [
				{"id": "icon_cmd", "label": "Command\nPrompt", "glyph": "[>_]", "target_window_id": "terminal"},
				{"id": "icon_eyefinity", "label": "Eyefinity\n24-Wall", "glyph": "[24-DP]", "target_window_id": "eyefinity"},
				{"id": "icon_switcher", "label": "Multi-Boot\nSwitcher", "glyph": "[⚡]", "target_window_id": "switcher"}
			]
