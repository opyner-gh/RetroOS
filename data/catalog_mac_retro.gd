extends RefCounted
## Catalog of Classic Macintosh, Power Mac G4 OS X, Commodore Amiga, and Apple IIe profiles.

const OSProfile = preload("res://data/os_profile.gd")


static func get_profiles() -> Array[OSProfile]:
	return [
		_build_mac_sys75(),
		_build_macosx_g4(),
		_build_amiga_os31(),
		_build_apple_iie(),
	]


# ==============================================================================
# 1. MACINTOSH SYSTEM 7.5.3 - QUADRA 840AV (MOTOROLA 68040 @ 40MHZ, 1993)
# ==============================================================================
static func _build_mac_sys75() -> OSProfile:
	var p := OSProfile.new()
	p.id = "mac_sys75"
	p.category = "Mac & Home Classics"
	p.display_name = "Mac OS System 7.5.3 (Quadra 840AV)"
	p.short_name = "Mac System 7.5"
	p.release_year = "1995"
	p.vendor = "Apple Computer, Inc. (Cupertino, CA)"
	p.architecture_summary = "Motorola 68040 + AT&T DSP3210 • System 7.5.3 (Rev 2) • MultiFinder"
	p.hardware_profile = "Macintosh Quadra 840AV • MC68040 @ 40MHz • DSP3210 @ 66MHz • 64MB RAM • 1GB SCSI"
	p.description = (
		"The fastest 68k Macintosh ever built. Features the iconic Quadra harmonic startup chime, "
		+ "the 'Happy Mac' & marching System Extensions startup screen, QuickDraw pinstriped window "
		+ "titlebars with left-side close boxes, Control Strip, and MPW (Macintosh Programmer's Workshop)."
	)

	p.bios_header = (
		"Apple Macintosh Quadra 840AV — Universal ROM $067C (2MB NewAge/Cyclone)\n"
		+ "MC68040 @ 40MHz + AT&T DSP3210 @ 66.7MHz Realtime Audio/Video Subsystem"
	)
	p.boot_bg_color = Color("1e1e26")
	p.boot_text_color = Color("e8e8f0")
	p.boot_logs = [
		{"text": "[Quadra 840AV Hardware Diagnostic: ROM Checksum $067C42A1 Passed]", "delay": 1.15, "sfx": "fan_spinup", "color": "#ffffff"},
		{"text": "Memory SIMM Banks: 64 MB 60ns 72-pin Interleaved DRAM OK", "delay": 1.35, "sfx": "beep", "color": "#b8d8ff"},
		{"text": "AT&T DSP3210 32-Bit Digital Signal Processor Initialized (GeoPort Ready)", "delay": 0.95, "sfx": "", "color": "#c8c8d8"},
		{"text": "SuperDrive 1.44MB Sony FDHD Floppy Controller Poll...", "delay": 1.65, "sfx": "floppy", "color": "#c8c8d8"},
		{"text": "Scanning NCR 53C96 Fast SCSI Bus ... ID 0: Quantum Empire 1080S (1.08 GB)", "delay": 1.45, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "", "delay": 0.45, "sfx": "", "color": ""},
		{"text": "   .-------.     [ Happy Mac Found on SCSI ID 0: 'Quadra HD' ]", "delay": 1.10, "sfx": "hdd_click", "color": "#88eeaa"},
		{"text": "   | ^   ^ |     Welcome to Macintosh.", "delay": 1.30, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "   |  \\_/  |     System Software 7.5.3 (Revision 2)", "delay": 1.00, "sfx": "", "color": "#dcdce8"},
		{"text": "   '-------'", "delay": 0.65, "sfx": "", "color": "#88eeaa"},
		{"text": "Loading System Enabler 088 & 32-Bit Addressing Mode...", "delay": 1.05, "sfx": "hdd_click", "color": "#c8c8d8"},
		{"text": "Loading Extension: [QuickTime 2.5] [Sound Manager 3.2] [AppleTalk]...", "delay": 1.25, "sfx": "hdd_burst", "color": "#ffcc77"},
		{"text": "Loading Extension: [MacTCP 2.0.6] [Open Transport 1.1] [Speech Manager]...", "delay": 1.15, "sfx": "hdd_click", "color": "#ffcc77"},
		{"text": "Loading Control Panels: [Appearance] [Monitors & Sound] [WindowShade]...", "delay": 1.10, "sfx": "hdd_click", "color": "#ffcc77"},
		{"text": "Starting Finder 7.5.5 & Desktop Manager...", "delay": 1.60, "sfx": "hdd_burst", "color": "#ffffff"}
	]

	p.chrome_style = "mac_platinum"
	p.desktop_bg_color = Color("5a6e9c")
	p.desktop_secondary_color = Color("46567c")
	p.panel_bg_color = Color("eeeeee")
	p.panel_text_color = Color("000000")
	p.window_bg_color = Color("dedede")
	p.window_text_color = Color("000000")
	p.window_border_color = Color("222222")
	p.titlebar_active_color = Color("cccccc")
	p.titlebar_active_gradient_end = Color("e8e8e8")
	p.titlebar_inactive_color = Color("efefef")
	p.titlebar_text_color = Color("000000")
	p.accent_color = Color("333399")

	p.terminal_title = "MPW Shell — Worksheet (Macintosh Programmer's Workshop)"
	p.terminal_bg_color = Color("ffffff")
	p.terminal_fg_color = Color("000000")
	p.terminal_prompt = "QuadraHD:MPW: "
	p.terminal_welcome_banner = (
		"Macintosh Programmer's Workshop (MPW) v3.4 — 68040 C/Assembler Environment\n"
		+ "System 7.5.3 • 64,000K Total Memory • PlainTalk Speech & DSP3210 Active.\n"
		+ "Type 'files', 'volumes', 'gestalt', 'macsbug', 'say hello', or 'help'."
	)
	p.terminal_commands = {
		"files": (
			":System Folder:\n"
			+ ":Applications:\n"
			+ ":Adobe Photoshop 3.0.5:\n"
			+ ":Marathon Infinity:\n"
			+ ":MPW:\n"
			+ "Desktop DB\n"
			+ "Desktop DF"
		),
		"volumes": (
			"Volume Name          Free      Size   Kind\n"
			+ "---------------  --------  --------   ------------\n"
			+ "Quadra HD          612 MB   1080 MB   HFS (SCSI 0)\n"
			+ "Myst CD-ROM          0 MB    640 MB   ISO 9660 (SCSI 3)"
		),
		"gestalt": (
			"Gestalt Selector Dump (Quadra 840AV):\n"
			+ "  'mach' = 0x0000004E (Macintosh Quadra 840AV)\n"
			+ "  'proc' = 0x00000005 (Motorola 68040 @ 40MHz)\n"
			+ "  'fpu ' = 0x00000003 (68040 Built-In FPU)\n"
			+ "  'sysv' = 0x00000753 (System 7.5.3)"
		),
		"macsbug": (
			"MacsBug 6.5.2, Copyright Apple Computer, Inc. 1981-95\n"
			+ "  PC = 40812A4C  SR = 2000  A7 = 03F8E120\n"
			+ "  CurApName = 'Finder'  (32-bit mode)\n"
			+ "  Type 'G' (or any command) to resume System 7.5."
		),
		"say hello": "PlainTalk MacInTalk Pro (Fred): \"Hello, I am a Macintosh Quadra 840 A V. It is good to see you.\""
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "MPW Shell — Worksheet",
			"type": "terminal",
			"pos": Vector2(125, 58),
			"size": Vector2(540, 335),
			"content": ""
		},
		{
			"id": "about_mac",
			"title": "About This Macintosh",
			"type": "monitor",
			"pos": Vector2(515, 365),
			"size": Vector2(455, 275),
			"content": (
				" Macintosh Quadra 840AV          System Software 7.5.3\n"
				+ "  Built-in Memory: 64,000K         Largest Unused Block: 48,120K\n"
				+ "================================================================\n"
				+ "  Adobe Photoshop™ 3.0   (8,192K) : [||||||||............]\n"
				+ "  MPW Shell 3.4          (4,096K) : [|||||...............]\n"
				+ "  System Software        (3,592K) : [||||||..............]\n"
				+ "----------------------------------------------------------------\n"
				+ "  © Apple Computer, Inc. 1983-1996"
			)
		},
		{
			"id": "quadra_hd",
			"title": "Quadra HD (7 items, 612 MB available)",
			"type": "files",
			"pos": Vector2(115, 415),
			"size": Vector2(385, 225),
			"content": (
				"[Folder] System Folder       [Folder] Applications\n"
				+ "[Folder] Adobe Photoshop 3   [Folder] Marathon Infinity\n"
				+ "[Folder] ClarisWorks 4.0     [Folder] SoundEdit 16\n"
				+ "[App]    ResEdit 2.1.3       [App]    SimpleText"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_hd", "label": "Quadra HD", "glyph": "[HFS]", "target_window_id": "quadra_hd"},
		{"id": "icon_mpw", "label": "MPW Shell", "glyph": "[MPW]", "target_window_id": "terminal"},
		{"id": "icon_about", "label": "About This\nMacintosh", "glyph": "[]", "target_window_id": "about_mac"}
	]

	p.fan_base_freq = 116.0
	p.fan_noise_level = 0.25
	p.hdd_seek_interval_range = Vector2(2.6, 6.0)
	return p


# ==============================================================================
# 2. MAC OS X 10.2 "JAGUAR" - 1999 POWER MAC G4 "SAWTOOTH" GRAPHITE TOWER
# ==============================================================================
static func _build_macosx_g4() -> OSProfile:
	var p := OSProfile.new()
	p.id = "macosx_g4"
	p.category = "Mac & Home Classics"
	p.display_name = "Mac OS X 10.2 (1999 Power Mac G4 Tower)"
	p.short_name = "Mac OS X (G4)"
	p.release_year = "1999"
	p.vendor = "Apple Computer, Inc."
	p.architecture_summary = "PowerPC G4 (MPC7400 AltiVec) • Darwin 6.0 / Mach 3.0 • Quartz Extreme Aqua"
	p.hardware_profile = "1999 Power Mac G4 'Sawtooth' (Graphite) • 450MHz AltiVec • 512MB PC100 • Rage 128 Pro AGP"
	p.description = (
		"The translucent polycarbonate 'Graphite' Power Mac G4 tower classified as a 'supercomputer' "
		+ "for its 128-bit AltiVec Velocity Engine vector unit. Runs early 'lickable' pinstripe Aqua "
		+ "Mac OS X with red/yellow/green traffic-light buttons, Quartz PDF compositing, and BSD Terminal."
	)

	p.bios_header = (
		"Apple PowerMac3,1 3.1.1f1 BootROM built on 09/14/99 at 11:42:08\n"
		+ "Copyright 1994-1999 Apple Computer, Inc.  Open Firmware 3.1.1 (New World ROM)"
	)
	p.boot_bg_color = Color("0c0e14")
	p.boot_text_color = Color("e4e8f0")
	p.boot_logs = [
		{"text": "Welcome to Open Firmware, the system time and date is: 02:14:00 10/21/1999", "delay": 1.05, "sfx": "fan_spinup", "color": "#ffffff"},
		{"text": "0 > boot hd:,\\System\\Library\\CoreServices\\BootX", "delay": 1.25, "sfx": "hdd_click", "color": "#99ccff"},
		{"text": "Loading Mach-O Kernel (mach_kernel) from Ultra ATA/66 HFS+ Volume...", "delay": 1.50, "sfx": "hdd_burst", "color": "#e4e8f0"},
		{"text": "Darwin Kernel Version 6.0: Sat Jul 27 13:18:52 PDT 2002; root:xnu-344.obj~1/RELEASE_PPC", "delay": 1.10, "sfx": "hdd_click", "color": "#77ddff"},
		{"text": "standard timeslicing quantum is 10000 us", "delay": 0.65, "sfx": "", "color": "#b8c0d0"},
		{"text": "PowerMac3,1 (PowerPC 7400 G4 @ 450 MHz, 1MB Backside L2 Cache, AltiVec Vector Unit)", "delay": 0.95, "sfx": "", "color": "#ffffff"},
		{"text": "512 MB physical memory initialized (UniNorth 100MHz System Controller)", "delay": 0.90, "sfx": "", "color": "#b8c0d0"},
		{"text": "ATY,Rage128Pd: AGP 2X 16MB SDRAM Framebuffer (Quartz Compositor Ready)", "delay": 0.95, "sfx": "", "color": "#ffcc77"},
		{"text": "disk0s9: HFS+ Volume 'Macintosh HD' journaled and clean.", "delay": 1.25, "sfx": "hdd_burst", "color": "#88eeaa"},
		{"text": "FireWire (OHCI) Lucent FW323 built-in 400Mbps port active.", "delay": 0.85, "sfx": "", "color": "#b8c0d0"},
		{"text": "Starting SystemStarter: DirectoryServices, CoreGraphics, ATSFontServer, cupsd...", "delay": 1.35, "sfx": "hdd_click", "color": "#b8c0d0"},
		{"text": "Launching Aqua WindowServer, Finder.app & Dock.app...", "delay": 1.65, "sfx": "hdd_burst", "color": "#99ccff"}
	]

	p.chrome_style = "aqua_pinstripe"
	p.desktop_bg_color = Color("24589c")
	p.desktop_secondary_color = Color("183c6e")
	p.panel_bg_color = Color("f0f2f6")
	p.panel_text_color = Color("111111")
	p.window_bg_color = Color("ededf2")
	p.window_text_color = Color("111111")
	p.window_border_color = Color("8892a4")
	p.titlebar_active_color = Color("dce2ec")
	p.titlebar_active_gradient_end = Color("f4f6fa")
	p.titlebar_inactive_color = Color("e8eaee")
	p.titlebar_text_color = Color("111111")
	p.accent_color = Color("1f75fe")

	p.terminal_title = "Terminal — tcsh (80x24)"
	p.terminal_bg_color = Color("ffffff")
	p.terminal_fg_color = Color("111111")
	p.terminal_prompt = "[G4-Sawtooth:~] user% "
	p.terminal_welcome_banner = (
		"Last login: Sat Oct 21 02:10:14 on console\n"
		+ "Welcome to Darwin! (Power Mac G4 450MHz AltiVec // Mac OS X 10.2)\n"
		+ "Type 'uname -a', 'machine', 'top', 'df -h', 'ls', or 'help'."
	)
	p.terminal_commands = {
		"uname -a": "Darwin G4-Sawtooth.local 6.0 Darwin Kernel Version 6.0: RELEASE_PPC Power Macintosh powerpc",
		"machine": "ppc7400",
		"ls": "Applications/  Desktop/  Documents/  Library/  Movies/  Music/  Public/  Sites/",
		"df -h": (
			"Filesystem     Size   Used  Avail Capacity  Mounted on\n"
			+ "/dev/disk0s9    27G   4.8G    22G    18%    /\n"
			+ "devfs          1.0K   1.0K     0B   100%    /dev\n"
			+ "fdesc          1.0K   1.0K     0B   100%    /dev"
		),
		"top": (
			"Processes:  42 total, 2 running, 40 sleeping... 148 threads\n"
			+ "Load Avg:  0.18, 0.14, 0.09     CPU usage:  8.4% user,  4.2% sys, 87.4% idle\n"
			+ "PhysMem:   64.2M wired,  148M active,  92.4M inactive,  304M used,  208M free\n"
			+ "  PID COMMAND      %CPU   TIME   #TH #PRTS #MREGS RPRVT  RSHRD  RSIZE  VSIZE\n"
			+ "  182 WindowServ   5.2%  0:14.22   3   184    210 14.2M  28.4M  32.1M   142M\n"
			+ "  214 Finder       1.1%  0:03.40   4   112    145 8.40M  16.2M  19.8M   118M\n"
			+ "  240 iTunes       2.0%  0:08.15   6   128    168 9.10M  18.0M  21.4M   124M"
		)
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "Terminal — tcsh (80x24)",
			"type": "terminal",
			"pos": Vector2(125, 54),
			"size": Vector2(545, 340),
			"content": ""
		},
		{
			"id": "sysprof",
			"title": "Apple System Profiler — Power Mac G4 (AGP Graphics)",
			"type": "monitor",
			"pos": Vector2(525, 365),
			"size": Vector2(450, 275),
			"content": (
				"[ System Profile | Devices and Volumes | Frameworks | Logs ]\n"
				+ "===========================================================\n"
				+ "Machine Model       : Power Mac G4 (AGP Graphics 'Sawtooth')\n"
				+ "Processor           : PowerPC G4 (2.9) @ 450 MHz\n"
				+ "AltiVec Vector Unit : Enabled (128-Bit Velocity Engine)\n"
				+ "L2 Backside Cache   : 1 MB (2:1 225 MHz)\n"
				+ "Memory              : 512 MB PC100 SDRAM (4 DIMM Slots)\n"
				+ "Graphics Card       : ATI Rage 128 Pro AGP (16 MB VRAM)\n"
				+ "Optical Drive       : MATSHITA DVD-ROM SR-8584A"
			)
		},
		{
			"id": "itunes",
			"title": "iTunes 3 — SoundJam / FireWire iPod Sync",
			"type": "text",
			"pos": Vector2(115, 415),
			"size": Vector2(390, 225),
			"content": (
				"[ <|  |>  >| ]   Volume: [|||||||...]   [ iPod (5GB) Ready ]\n"
				+ "------------------------------------------------------------\n"
				+ "Now Playing : Daft Punk - Digital Love (Discovery, 2001)\n"
				+ "Encoding    : 160 kbps MP3 (AltiVec Accelerated Ripper)\n"
				+ "Visualizer  : G-Force / iTunes Lathe OpenGL"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_hd", "label": "Macintosh\nHD", "glyph": "[HFS+]", "target_window_id": "sysprof"},
		{"id": "icon_term", "label": "Terminal.app", "glyph": "[>_]", "target_window_id": "terminal"},
		{"id": "icon_itunes", "label": "iTunes 3", "glyph": "[♫]", "target_window_id": "itunes"}
	]

	p.fan_base_freq = 120.0
	p.fan_noise_level = 0.26
	p.hdd_seek_interval_range = Vector2(2.8, 6.4)
	return p


# ==============================================================================
# 3. COMMODORE AMIGAOS 3.1 - AMIGA 3000 (MOTOROLA 68030 @ 25MHZ, 1990)
# ==============================================================================
static func _build_amiga_os31() -> OSProfile:
	var p := OSProfile.new()
	p.id = "amiga_os31"
	p.category = "Mac & Home Classics"
	p.display_name = "Commodore AmigaOS 3.1 (Amiga 3000)"
	p.short_name = "AmigaOS 3.1"
	p.release_year = "1993"
	p.vendor = "Commodore-Amiga, Inc. (West Chester, PA)"
	p.architecture_summary = "Motorola 68030 + 68882 FPU • Kickstart 40.68 • Workbench 40.42 • Paula/Amber"
	p.hardware_profile = "Amiga 3000 • MC68030 @ 25MHz • 2MB Chip + 16MB Fast RAM • WD33C93A SCSI"
	p.description = (
		"Commodore's 32-bit multimedia workstation featuring dedicated custom coprocessors (Agnus, "
		+ "Denise, Paula 4-channel 8-bit DMA audio, and Amber scan-doubler), preemptive multitasking "
		+ "in 256KB ROM, and the iconic grey-and-blue Workbench 3.1 desktop."
	)

	p.bios_header = (
		"Commodore-Amiga Kickstart ROM v40.68 (AmigaOS 3.1) — Amiga 3000 (MC68030/68882)\n"
		+ "Copyright © 1985-1993 Commodore-Amiga, Inc. All Rights Reserved."
	)
	p.boot_bg_color = Color("181422")
	p.boot_text_color = Color("e0dcd8")
	p.boot_logs = [
		{"text": "[Power-On Screen Transition: Dark Grey -> Light Grey -> White -> Kickstart Ready]", "delay": 1.15, "sfx": "fan_spinup", "color": "#cccccc"},
		{"text": "Exec 40.10 initialized: 2,097,152 bytes Chip RAM | 16,777,216 bytes 32-bit Fast RAM", "delay": 1.25, "sfx": "beep", "color": "#ffffff"},
		{"text": "trackdisk.device 40.1: Polling Internal Floppy Drive DF0: (880KB AmigaDOS)...", "delay": 1.65, "sfx": "floppy", "color": "#ffcc66"},
		{"text": "scsi.device 40.12 (WD33C93A): Scanning SCSI bus... Unit 0: QUANTUM LP105S (105MB FFS)", "delay": 1.45, "sfx": "hdd_burst", "color": "#88eeaa"},
		{"text": "", "delay": 0.45, "sfx": "", "color": ""},
		{"text": "Executing S:Startup-Sequence on DH0: (Workbench3.1:)...", "delay": 1.20, "sfx": "hdd_click", "color": "#ffffff"},
		{"text": "C:SetPatch QUIET -> CPU 68030 (MMU Active) 68882 FPU Enabled, ECS Denise Patch Installed", "delay": 1.15, "sfx": "hdd_click", "color": "#77ccff"},
		{"text": "C:Mount >NIL: DEVS:DOSDrivers/~(#?.info)  [PIPE: AUX: RAD: CD0:]", "delay": 1.10, "sfx": "hdd_burst", "color": "#d8d8d8"},
		{"text": "C:IPrefs -> Loading ENV:sys/workbench.prefs & screenmode.prefs (640x400 DblNTSC)", "delay": 1.15, "sfx": "hdd_click", "color": "#d8d8d8"},
		{"text": "RexxMast >NIL: (ARexx Inter-Process Scripting Server Active)", "delay": 0.90, "sfx": "", "color": "#d8d8d8"},
		{"text": "C:LoadWB -> Launching Amiga Workbench 40.42...", "delay": 1.55, "sfx": "hdd_burst", "color": "#88eeaa"}
	]

	p.chrome_style = "amiga_workbench"
	p.desktop_bg_color = Color("959595")
	p.desktop_secondary_color = Color("7a7a7a")
	p.panel_bg_color = Color("ffffff")
	p.panel_text_color = Color("000000")
	p.window_bg_color = Color("959595")
	p.window_text_color = Color("000000")
	p.window_border_color = Color("ffffff")
	p.titlebar_active_color = Color("3b67a2")
	p.titlebar_active_gradient_end = Color("3b67a2")
	p.titlebar_inactive_color = Color("959595")
	p.titlebar_text_color = Color("ffffff")
	p.accent_color = Color("3b67a2")

	p.terminal_title = "AmigaShell"
	p.terminal_bg_color = Color("959595")
	p.terminal_fg_color = Color("000000")
	p.terminal_prompt = "1.Workbench3.1:> "
	p.terminal_welcome_banner = (
		"New Shell process 1\n"
		+ "AmigaOS Release 3.1 (Kickstart 40.68, Workbench 40.42)\n"
		+ "Type 'avail', 'info', 'cpu', 'assign', 'list', 'guru', or 'help'."
	)
	p.terminal_commands = {
		"version": "Kickstart version 40.68, Workbench version 40.42",
		"cpu": "System: 68030 68882 FastROM (INST: Cache Burst) (DATA: Cache WriteAllocate Burst)",
		"avail": (
			"Type  Available    In-Use   Maximum   Largest\n"
			+ "chip    1842160    254992   2097152   1810400\n"
			+ "fast   14912400   1864816  16777216  14680064\n"
			+ "total  16754560   2119808  18874368  14680064"
		),
		"info": (
			"Mounted disks:\n"
			+ "Unit      Size    Used    Free Full Errs   Status   Name\n"
			+ "RAM:       14K     14K      0K 100%   0  Read/Write Ram Disk\n"
			+ "DF0:      No disk present\n"
			+ "DH0:      105M     38M     67M  36%   0  Read/Write Workbench3.1\n"
			+ "DH1:      420M    284M    136M  68%   0  Read/Write Work_Demoscene"
		),
		"assign": (
			"Volumes:\n"
			+ "  Ram Disk [Mounted]\n"
			+ "  Workbench3.1 [Mounted]\n"
			+ "Directories:\n"
			+ "  SYS:       Workbench3.1:\n"
			+ "  C:         Workbench3.1:C\n"
			+ "  S:         Workbench3.1:S\n"
			+ "  LIBS:      Workbench3.1:Libs\n"
			+ "  DEVS:      Workbench3.1:Devs"
		),
		"list": (
			"Directory \"Workbench3.1:\" on Saturday 21-Oct-95\n"
			+ "Prefs                        Dir ----rwed Today     01:10:00\n"
			+ "Utilities                    Dir ----rwed Today     01:10:00\n"
			+ "Tools                        Dir ----rwed Today     01:10:00\n"
			+ "System                       Dir ----rwed Today     01:10:00\n"
			+ "Devs                         Dir ----rwed Today     01:10:00\n"
			+ "Disk.info                   1642 ----rw-d 14-Aug-94 12:00:00"
		),
		"guru": (
			"================================================================\n"
			+ "  SOFTWARE FAILURE.   Press left mouse button to continue.\n"
			+ "  GURU MEDITATION #80000004.00004845\n"
			+ "================================================================"
		)
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "AmigaShell",
			"type": "terminal",
			"pos": Vector2(120, 56),
			"size": Vector2(545, 340),
			"content": ""
		},
		{
			"id": "wb_root",
			"title": "Workbench3.1 (36% full, 67MB free)",
			"type": "files",
			"pos": Vector2(530, 365),
			"size": Vector2(440, 270),
			"content": (
				"[Drawer] System         [Drawer] Utilities      [Drawer] Prefs\n"
				+ "[Drawer] Tools          [Drawer] Devs           [Drawer] Expansion\n"
				+ "[Tool]   ProTracker3.15 [Tool]   DeluxePaintIV  [Tool]   DirOpus4\n"
				+ "---------------------------------------------------------------\n"
				+ "Paula 8364 Audio: 4-Channel 8-Bit DMA Stereo Active"
			)
		},
		{
			"id": "sysinfo_amiga",
			"title": "SysInfo v3.24 by Nic Wilson",
			"type": "monitor",
			"pos": Vector2(115, 415),
			"size": Vector2(395, 225),
			"content": (
				"AMIGA 3000 HARDWARE BENCHMARK\n"
				+ "---------------------------------------------\n"
				+ "CPU / FPU       : 68030 @ 25MHz / 68882 @ 25MHz\n"
				+ "Dhrystones/sec  : 9,482 (7.12x Amiga 600)\n"
				+ "Chip Speed      : 10.42 vs A600\n"
				+ "SCSI Speed      : 2,480,120 Bytes/sec"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_ram", "label": "Ram Disk", "glyph": "[RAM]", "target_window_id": "sysinfo_amiga"},
		{"id": "icon_wb", "label": "Workbench3.1", "glyph": "[DH0]", "target_window_id": "wb_root"},
		{"id": "icon_shell", "label": "AmigaShell", "glyph": "[CLI]", "target_window_id": "terminal"}
	]

	p.fan_base_freq = 108.0
	p.fan_noise_level = 0.22
	p.hdd_seek_interval_range = Vector2(2.4, 5.5)
	return p


# ==============================================================================
# 4. APPLE IIe ENHANCED - PRODOS 8 v2.0.3 & APPLESOFT BASIC (1985)
# ==============================================================================
static func _build_apple_iie() -> OSProfile:
	var p := OSProfile.new()
	p.id = "apple_iie"
	p.category = "Mac & Home Classics"
	p.display_name = "Apple IIe Enhanced (ProDOS 8 / BASIC)"
	p.short_name = "Apple //e"
	p.release_year = "1985"
	p.vendor = "Apple Computer, Inc."
	p.architecture_summary = "MOS/WDC 65C02 @ 1.023MHz • 128KB Extended 80-Col • ProDOS 8 v2.0.3"
	p.hardware_profile = "Apple //e Enhanced • Apple Monitor II (P31 Green Phosphor) • 2x Disk II 5.25\" + Profile 5MB"
	p.description = (
		"The quintessential 8-bit personal computer with an Apple Monitor II P31 green phosphor CRT, "
		+ "128KB Extended 80-Column Card, MouseText graphical characters, ProDOS 8, Applesoft BASIC in ROM, "
		+ "and Steve Wozniak's Disk II 5.25-inch floppy controller slamming the head against Track 0."
	)

	p.bios_header = (
		"                           APPLE //e  ENHANCED (128K)\n"
		+ "          APPLESOFT BASIC ROM // SLOT 6: DISK II 5.25\" CONTROLLER"
	)
	p.boot_bg_color = Color("030e04")
	p.boot_text_color = Color("33ff55")
	p.boot_logs = [
		{"text": "APPLE //e", "delay": 1.10, "sfx": "beep", "color": "#33ff55"},
		{"text": "[SLOT 6 DRIVE 1: RECALIBRATING SHUGART SA-390 STEPPER HEAD TO TRACK 00...]", "delay": 1.85, "sfx": "disk2_bang", "color": "#22cc44"},
		{"text": "READING TRACK $00 SECTOR $00 -> BOOT0 STAGE LOADER...", "delay": 1.40, "sfx": "floppy", "color": "#33ff55"},
		{"text": "LOADING PRODOS.SYS ($2000-$4FFF) & BASIC.SYSTEM ($9A00-$BEFF)...", "delay": 1.55, "sfx": "floppy", "color": "#33ff55"},
		{"text": "", "delay": 0.45, "sfx": "", "color": ""},
		{"text": "****************************************************************", "delay": 0.45, "sfx": "", "color": "#33ff55"},
		{"text": "*                                                              *", "delay": 0.35, "sfx": "", "color": "#33ff55"},
		{"text": "*               APPLE //e  PRODOS 8  VERSION 2.0.3             *", "delay": 0.65, "sfx": "hdd_click", "color": "#66ff88"},
		{"text": "*          COPYRIGHT APPLE COMPUTER, INC. 1983-1993            *", "delay": 0.65, "sfx": "", "color": "#33ff55"},
		{"text": "*                                                              *", "delay": 0.35, "sfx": "", "color": "#33ff55"},
		{"text": "****************************************************************", "delay": 0.55, "sfx": "", "color": "#33ff55"},
		{"text": "SLOT 3: EXTENDED 80-COLUMN TEXT/RAMDRIVE (/RAM 64K INITIALIZED)", "delay": 0.95, "sfx": "", "color": "#22cc44"},
		{"text": "SLOT 4: APPLE II MOUSE CARD (MOUSETEXT DESKTOP READY)", "delay": 0.90, "sfx": "", "color": "#22cc44"},
		{"text": "SLOT 7: APPLE PROFILE 5MB HARD DISK (/PROFILE ONLINE)", "delay": 1.25, "sfx": "hdd_burst", "color": "#33ff55"},
		{"text": "EXECUTING HELLOSTARTUP BAS...", "delay": 1.35, "sfx": "floppy", "color": "#66ff88"}
	]

	p.chrome_style = "apple2_green"
	p.desktop_bg_color = Color("041206")
	p.desktop_secondary_color = Color("061c09")
	p.panel_bg_color = Color("0a2b0e")
	p.panel_text_color = Color("33ff55")
	p.window_bg_color = Color("051607")
	p.window_text_color = Color("33ff55")
	p.window_border_color = Color("33ff55")
	p.titlebar_active_color = Color("1b6e28")
	p.titlebar_active_gradient_end = Color("1b6e28")
	p.titlebar_inactive_color = Color("0b3010")
	p.titlebar_text_color = Color("66ff88")
	p.accent_color = Color("33ff55")

	p.terminal_title = "APPLESOFT BASIC // PRODOS 8"
	p.terminal_bg_color = Color("030e04")
	p.terminal_fg_color = Color("33ff55")
	p.terminal_prompt = "]"
	p.terminal_welcome_banner = (
		"PRODOS BASIC 1.5 -- COPYRIGHT APPLE, 1983-90\n"
		+ "TYPE 'CATALOG', 'LIST', 'RUN', 'CALL -151', 'PR#6', OR 'HELP'."
	)
	p.terminal_commands = {
		"catalog": (
			"\n/USERS.DISK.1\n\n"
			+ " NAME           TYPE  BLOCKS  MODIFIED         CREATED          ENDFILE\n\n"
			+ "*PRODOS          SYS      35  18-MAY-93  0:00  18-MAY-93  0:00    17128\n"
			+ "*BASIC.SYSTEM    SYS      21  18-MAY-93  0:00  18-MAY-93  0:00    10240\n"
			+ " STARTUP         BAS       4  21-OCT-85 14:20  21-OCT-85 14:10     1412\n"
			+ " OREGON.TRAIL    BIN      68  12-SEP-85  9:00  12-SEP-85  9:00    34120\n"
			+ " KARATEKA        BIN      92  04-NOV-84 18:30  04-NOV-84 18:30    46800\n"
			+ " APPLEWORKS.SYS  SYS      45  10-JAN-85 11:00  10-JAN-85 11:00    22528\n\n"
			+ "BLOCKS FREE:  15     BLOCKS USED:  265     TOTAL BLOCKS:  280"
		),
		"cat": "USE 'CATALOG' FOR FULL 80-COLUMN PRODOS DIRECTORY LISTING.",
		"list": (
			"10  HOME : PRINT \"=== APPLE //e RETRO-OS DEMO ===\"\n"
			+ "20  FOR I = 1 TO 4 : PRINT \"65C02 @ 1.023 MHZ - MEMORY FREE: \"; FRE(0) : NEXT I\n"
			+ "30  PRINT CHR$(7); \"READY.\"\n"
			+ "40  END"
		),
		"run": (
			"=== APPLE //e RETRO-OS DEMO ===\n"
			+ "65C02 @ 1.023 MHZ - MEMORY FREE: 36418\n"
			+ "65C02 @ 1.023 MHZ - MEMORY FREE: 36418\n"
			+ "65C02 @ 1.023 MHZ - MEMORY FREE: 36418\n"
			+ "65C02 @ 1.023 MHZ - MEMORY FREE: 36418\n"
			+ "READY."
		),
		"call -151": (
			"*\n"
			+ "FF00: 4C 58 FF 4C 65 FF 4C 65  FF 00 00 00 00 00 00 00\n"
			+ "FF10: 20 35 FF A0 00 B9 00 02  99 00 03 C8 D0 F7 60 00\n"
			+ "[APPLE II SYSTEM MONITOR ROM — TYPE '3D0G' OR ANY COMMAND TO RETURN]"
		),
		"pr#6": "RECALIBRATING SLOT 6 DRIVE 1 (SHUGART 5.25\" TRACK 00)... OK.",
		"home": ""
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "APPLESOFT BASIC // PRODOS 8 (SLOT 3 80-COL)",
			"type": "terminal",
			"pos": Vector2(120, 52),
			"size": Vector2(565, 345),
			"content": ""
		},
		{
			"id": "appleworks",
			"title": "AppleWorks v2.0 — Main Menu (128K Desktop)",
			"type": "text",
			"pos": Vector2(525, 370),
			"size": Vector2(450, 270),
			"content": (
				"Disk: Drive 1                           55K Avail.\n"
				+ "====================================================\n"
				+ "       1. Add files to the Desktop\n"
				+ "       2. Work with one of the files on the Desktop\n"
				+ "       3. Save Desktop files to disk\n"
				+ "       4. Remove files from the Desktop\n"
				+ "       5. Other Activities\n"
				+ "       6. Quit\n"
				+ "===================================================="
			)
		},
		{
			"id": "slots",
			"title": "Apple //e Peripheral Expansion Slots (1-7)",
			"type": "monitor",
			"pos": Vector2(115, 415),
			"size": Vector2(395, 225),
			"content": (
				"AUX : Apple Extended 80-Column TextCard (64KB)\n"
				+ "SL1 : Super Serial Card (Printer 9600 Baud)\n"
				+ "SL2 : Hayes Micromodem IIe (300/1200 Baud)\n"
				+ "SL4 : Mockingboard Sound II (2x AY-3-8910 PSG)\n"
				+ "SL6 : Apple Disk II 5.25\" Controller (Drives 1 & 2)\n"
				+ "SL7 : Apple ProFile 5MB Hard Disk Interface"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_basic", "label": "APPLESOFT\nBASIC", "glyph": "[ ] ]", "target_window_id": "terminal"},
		{"id": "icon_aw", "label": "AppleWorks", "glyph": "[AW]", "target_window_id": "appleworks"},
		{"id": "icon_slots", "label": "Bus Slots", "glyph": "[6502]", "target_window_id": "slots"}
	]

	p.fan_base_freq = 60.0
	p.fan_noise_level = 0.08
	p.hdd_seek_interval_range = Vector2(4.5, 10.0)
	return p

