extends RefCounted
## Catalog of classic UNIX, BSD, Linux, NeXTSTEP, and BeOS workstation profiles.

const OSProfile = preload("res://data/os_profile.gd")


static func get_profiles() -> Array[OSProfile]:
	return [
		_build_beos_r5(),
		_build_nextstep_33(),
		_build_solaris_8(),
		_build_redhat_62(),
		_build_freebsd_411(),
		_build_sco_openserver(),
	]


# ==============================================================================
# 1. BEOS R5 PRO (5.0.3) - TYAN TIGER 100 DUAL PENTIUM III SMP (2000)
# ==============================================================================
static func _build_beos_r5() -> OSProfile:
	var p := OSProfile.new()
	p.id = "beos_r5"
	p.category = "UNIX & Alt-OS"
	p.display_name = "BeOS R5 Pro (5.0.3)"
	p.short_name = "BeOS R5"
	p.release_year = "2000"
	p.has_crt = true
	p.aspect_ratio = "4:3"
	p.has_energy_star_badge = true
	p.vendor = "Be Incorporated (Menlo Park, CA)"
	p.architecture_summary = "x86 SMP • BeOS Kernel 5.0.3 • Tracker & Deskbar • 64-Bit BFS"
	p.hardware_profile = "Tyan Tiger 100 (i440BX) • Dual Pentium III 800MHz • 512MB PC100 • Matrox G400 MAX"
	p.description = (
		"The legendary 'Media OS' engineered for pervasive multithreading, symmetric multiprocessing, "
		+ "and sub-millisecond audio/video latency. Features the iconic left-tabbed bright yellow titlebars, "
		+ "top-right Deskbar with the blue feather menu, and the 64-bit journaled Be File System (BFS)."
	)

	p.bios_header = (
		"Award Modular BIOS v4.51PG, An Energy Star Ally\n"
		+ "Tyan S1832DL Tiger 100 Dual-Slot 1 Intel 440BX AGPSet BIOS v1.12"
	)
	p.boot_bg_color = Color("04060a")
	p.boot_text_color = Color("d4dce8")
	p.boot_logs = [
		{"text": "CPU0 : Intel Pentium(R) III 800MHz (100x8.0) Slot 1 SECC2", "delay": 0.95, "sfx": "fan_spinup", "color": "#ffffff"},
		{"text": "CPU1 : Intel Pentium(R) III 800MHz (100x8.0) — APIC SMP Initialized", "delay": 0.95, "sfx": "", "color": "#66ee99"},
		{"text": "Memory Test : 524288K OK (512MB PC100 ECC Registered SDRAM)", "delay": 1.45, "sfx": "beep", "color": "#ffffff"},
		{"text": "Primary Master : IBM-DTLA-307030 (30.7GB 7200RPM Deskstar 75GXP)", "delay": 1.25, "sfx": "hdd_click", "color": "#c8d0dc"},
		{"text": "Floppy Drive A : 1.44M, 3.5 in. initialized", "delay": 1.65, "sfx": "floppy", "color": "#c8d0dc"},
		{"text": "", "delay": 0.45, "sfx": "", "color": ""},
		{"text": "BeOS Boot Loader v5.0 (zbeos) — Select Boot Volume: /dev/disk/ide/ata/0/master/0_0", "delay": 1.20, "sfx": "hdd_click", "color": "#ffcc00"},
		{"text": "Loading kernel_intel ... [1,184,240 bytes]", "delay": 1.45, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "BeOS Release 5.0.3 (Build Dano/Pro) — Welcome to the Media OS", "delay": 1.00, "sfx": "", "color": "#55aaff"},
		{"text": "   [Icon 1/7] Mounting BFS root volume '/boot' (64-bit journaled attributes)...", "delay": 1.15, "sfx": "hdd_burst", "color": "#ffd84d"},
		{"text": "   [Icon 2/7] Probing PCI/AGP buses (Matrox Millennium G400 MAX DualHead)...", "delay": 0.95, "sfx": "hdd_click", "color": "#ffd84d"},
		{"text": "   [Icon 3/7] Starting Media Server & Audio Mixer (Aureal Vortex2 AU8830)...", "delay": 1.05, "sfx": "", "color": "#ffd84d"},
		{"text": "   [Icon 4/7] Starting NetServer (3Com 3C905B-TX Fast EtherLink XL)...", "delay": 0.95, "sfx": "", "color": "#ffd84d"},
		{"text": "   [Icon 5/7] Spawning Application Server (app_server) & Input Server...", "delay": 1.15, "sfx": "hdd_click", "color": "#ffd84d"},
		{"text": "   [Icon 6/7] Starting Tracker & Deskbar...", "delay": 1.50, "sfx": "hdd_burst", "color": "#66ee99"}
	]

	p.chrome_style = "beos_yellowtab"
	p.desktop_bg_color = Color("336698")
	p.desktop_secondary_color = Color("254d75")
	p.panel_bg_color = Color("dcdcdc")
	p.panel_text_color = Color("111111")
	p.window_bg_color = Color("eeeeee")
	p.window_text_color = Color("111111")
	p.window_border_color = Color("888888")
	p.titlebar_active_color = Color("ffcc00")
	p.titlebar_active_gradient_end = Color("e6b400")
	p.titlebar_inactive_color = Color("d0d0d0")
	p.titlebar_text_color = Color("111111")
	p.accent_color = Color("0055bb")

	p.terminal_title = "Terminal"
	p.terminal_bg_color = Color("ffffff")
	p.terminal_fg_color = Color("111111")
	p.terminal_prompt = "/boot/home$ "
	p.terminal_welcome_banner = (
		"Welcome to the BeOS shell (bash 2.03-beos)\n"
		+ "SMP: 2x Intel Pentium III 800MHz active.\n"
		+ "Type 'sysinfo', 'roster', 'df', 'ps', 'ls', or 'help'."
	)
	p.terminal_commands = {
		"uname -a": "BeOSbebox 5.0 1000003 BePC unknown",
		"sysinfo": (
			"Kernel: kernel_intel built Apr 18 2000 14:29:11 (version 0x503)\n"
			+ "2 Intel Pentium III processors (Model 8, Stepping 3) @ 800 MHz\n"
			+ "CPU 0: 800 MHz | Bus: 100 MHz | L2 Cache: 256 KB\n"
			+ "CPU 1: 800 MHz | Bus: 100 MHz | L2 Cache: 256 KB\n"
			+ "524288 KB RAM total, 89412 KB used (17%)"
		),
		"roster": (
			"team   id  name                             state\n"
			+ "---------------------------------------------------\n"
			+ "   1    1  /boot/beos/system/kernel_intel   running\n"
			+ "  14   82  /boot/beos/system/servers/app_server\n"
			+ "  19  104  /boot/beos/system/Tracker        running\n"
			+ "  21  118  /boot/beos/system/Deskbar        running\n"
			+ "  24  142  /boot/beos/system/servers/media_server\n"
			+ "  31  188  /boot/beos/apps/SoundPlay        playing\n"
			+ "  36  214  /boot/beos/apps/Terminal         running"
		),
		"df": (
			"Mount             Type      Total     Free      Flags   Device\n"
			+ "----------------- --------- --------- --------- ------- ------------------------\n"
			+ "/                 rootfs         0 K       0 K    ------\n"
			+ "/boot             bfs     30004224 K 26412800 K  QAM-P- /dev/disk/ide/ata/0/master/0_0"
		),
		"ls": "config/   desktop/  mail/     media_clips/  people/   queries/",
		"ps": (
			"  Thread                 Id     State    Prio      User    Kernel\n"
			+ "  kernel_team             1     running     5     120ms    1840ms\n"
			+ "  app_server             82     receive    20     940ms     410ms\n"
			+ "  media_addon_server    149     realtime  105     210ms      85ms\n"
			+ "  Pulse                 194     asleep     10     180ms      40ms"
		)
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "Terminal",
			"type": "terminal",
			"pos": Vector2(120, 62),
			"size": Vector2(540, 340),
			"content": ""
		},
		{
			"id": "pulse",
			"title": "Pulse (SMP CPU Activity)",
			"type": "monitor",
			"pos": Vector2(540, 375),
			"size": Vector2(430, 270),
			"content": (
				"BeOS Pulse // Tyan Tiger 100 Dual P-III 800MHz\n"
				+ "=================================================\n"
				+ "[ON] CPU 1 (800 MHz): [||||................]  19%\n"
				+ "[ON] CPU 2 (800 MHz): [|||.................]  14%\n\n"
				+ "Click a CPU button in real BeOS Pulse to disable\n"
				+ "a processor core on-the-fly while video plays!\n"
				+ "Media Latency: 2.8 ms | GL Teapot: 340 FPS"
			)
		},
		{
			"id": "tracker",
			"title": "beos_demo_media - Tracker",
			"type": "files",
			"pos": Vector2(115, 425),
			"size": Vector2(400, 220),
			"content": (
				"/boot/home/media_clips (BFS Indexed Attributes)\n"
				+ "-------------------------------------------------\n"
				+ "[Video]  launchpad_4x_simultaneous.avi\n"
				+ "[Audio]  Sting_BrandNewDay_BeOS_Demo.mp3\n"
				+ "[3D]     GLTeapot_Spinning.app\n"
				+ "[People] Jean-Louis Gassée (jlg@be.com)"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_boot", "label": "BeOS (bfs)", "glyph": "[Be]", "target_window_id": "tracker"},
		{"id": "icon_term", "label": "Terminal", "glyph": "[>_]", "target_window_id": "terminal"},
		{"id": "icon_pulse", "label": "Pulse SMP", "glyph": "[CPU]", "target_window_id": "pulse"}
	]

	p.fan_base_freq = 126.0
	p.fan_noise_level = 0.25
	p.hdd_seek_interval_range = Vector2(2.6, 6.0)
	return p


# ==============================================================================
# 2. NEXTSTEP 3.3 - NEXTSTATION TURBO COLOR (MOTOROLA 68040 @ 33MHZ, 1995)
# ==============================================================================
static func _build_nextstep_33() -> OSProfile:
	var p := OSProfile.new()
	p.id = "nextstep_33"
	p.category = "UNIX & Alt-OS"
	p.display_name = "NeXTSTEP 3.3 (NeXTstation Turbo Color)"
	p.short_name = "NeXTSTEP 3.3"
	p.release_year = "1995"
	p.has_crt = true
	p.aspect_ratio = "4:3"
	p.vendor = "NeXT Computer, Inc. (Redwood City, CA)"
	p.architecture_summary = "Motorola 68040 • Mach 2.5 / 4.3BSD • Display PostScript • Workspace Manager"
	p.hardware_profile = "NeXTstation Turbo Color ('The Slab') • MC68040 @ 33MHz • Motorola DSP56001 • 32MB RAM"
	p.description = (
		"Steve Jobs' magnesium-encased interpersonal workstation where Tim Berners-Lee invented the "
		+ "World Wide Web and id Software built DOOM. Features Display PostScript, pitch-black titlebars, "
		+ "chiseled 2-bit gray bevels, Objective-C Interface Builder, and the vertical NeXT Dock."
	)

	p.bios_header = (
		"NeXT ROM Monitor v3.2 (v74) — NeXTstation Turbo Color (MC68040 @ 33MHz)\n"
		+ "(C) Copyright 1988-1994 NeXT Computer, Inc. All Rights Reserved."
	)
	p.boot_bg_color = Color("181818")
	p.boot_text_color = Color("e0e0e0")
	p.boot_logs = [
		{"text": "Testing System Memory (32 MB Parity SIMMs) ... Passed.", "delay": 1.15, "sfx": "fan_spinup", "color": "#ffffff"},
		{"text": "Testing Motorola DSP56001 @ 25MHz (24KB Static RAM) ... Passed.", "delay": 0.95, "sfx": "beep", "color": "#cccccc"},
		{"text": "Testing Ethernet Controller ( Thin-Net / 10Base-T : 00:00:0f:01:4a:92 ) ... Passed.", "delay": 0.90, "sfx": "", "color": "#cccccc"},
		{"text": "NeXT> b sd(0,0,0)sdmach", "delay": 1.35, "sfx": "hdd_click", "color": "#ffffff"},
		{"text": "Booting from SCSI disk sd(0,0,0) [QUANTUM LPS540S 540MB]...", "delay": 1.50, "sfx": "hdd_burst", "color": "#d0d0d0"},
		{"text": "NeXT Mach 3.3: Thu Feb 16 19:04:22 PST 1995; root(rcbuilder):mk-159.19.obj~2/RELEASE_M68K", "delay": 1.15, "sfx": "hdd_click", "color": "#ffffff"},
		{"text": "FPU version 0x41 (Motorola 68040 internal FPU)", "delay": 0.70, "sfx": "", "color": "#b8b8b8"},
		{"text": "NextBus Slot 0: NeXT Turbo Color Video (1120x832 16-bit 4096-Color Display PostScript)", "delay": 0.95, "sfx": "", "color": "#b8b8b8"},
		{"text": "sd0 at sc0 target 0 lun 0: QUANTUM LPS540S rev 5900 (516MB)", "delay": 1.10, "sfx": "hdd_click", "color": "#b8b8b8"},
		{"text": "Checking 4.3BSD UFS filesystems (/dev/rsd0a) ... clean.", "delay": 1.30, "sfx": "hdd_burst", "color": "#cccccc"},
		{"text": "Starting Network Information Service (NetInfo: nibindd, netinfod)...", "delay": 1.15, "sfx": "hdd_click", "color": "#cccccc"},
		{"text": "Starting Display PostScript Window Server (/usr/lib/NextStep/WindowServer)...", "delay": 1.40, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "Launching Workspace Manager.app & NeXT Dock...", "delay": 1.55, "sfx": "hdd_click", "color": "#ffffff"}
	]

	p.chrome_style = "nextstep_black"
	p.desktop_bg_color = Color("555555")
	p.desktop_secondary_color = Color("444444")
	p.panel_bg_color = Color("aaaaaa")
	p.panel_text_color = Color("000000")
	p.window_bg_color = Color("aaaaaa")
	p.window_text_color = Color("000000")
	p.window_border_color = Color("000000")
	p.titlebar_active_color = Color("0d0d0d")
	p.titlebar_active_gradient_end = Color("222222")
	p.titlebar_inactive_color = Color("666666")
	p.titlebar_text_color = Color("ffffff")
	p.accent_color = Color("000000")

	p.terminal_title = "Terminal  /Users/jobs  (csh)"
	p.terminal_bg_color = Color("ffffff")
	p.terminal_fg_color = Color("000000")
	p.terminal_prompt = "slab:1> "
	p.terminal_welcome_banner = (
		"NeXTSTEP Release 3.3 (Motorola 68040)\n"
		+ "Display PostScript WindowServer active. Objective-C Runtime v4.\n"
		+ "Type 'hostinfo', 'ps -aux', 'ls', 'nidump passwd .', or 'help'."
	)
	p.terminal_commands = {
		"uname -a": "NeXTSTEP slab 3.3 NeXT_Mach MC68040",
		"hostinfo": (
			"Mach kernel version:\n"
			+ "   NeXT Mach 3.3: Thu Feb 16 19:04:22 PST 1995\n"
			+ "Kernel configured for a single processor only.\n"
			+ "1 processor is physically available.\n"
			+ "Processor type: MC680x0 (slots: 0)\n"
			+ "Processor active: 0 (Motorola 68040 @ 33MHz)\n"
			+ "Primary memory available: 32.00 megabytes."
		),
		"ls": "Apps/     Library/  Mailboxes/  ProjectBuilder_DoomEd/  WorldWideWeb.app/",
		"ps -aux": (
			"USER     PID %CPU %MEM   SZ  RSS TT STAT  TIME COMMAND\n"
			+ "root       1  0.0  0.8  420  260 ?  S     0:01 /etc/init\n"
			+ "root      54  0.1  1.4  680  440 ?  S     0:02 /usr/etc/netinfod local\n"
			+ "root     112  1.8 14.2 5840 4520 ?  S     0:14 /usr/lib/NextStep/WindowServer\n"
			+ "jobs     128  0.6  9.8 4120 3100 ?  S     0:05 /NextApps/Workspace.app/Workspace\n"
			+ "jobs     141  0.4  6.2 2840 1980 ?  S     0:02 /NextApps/Terminal.app/Terminal"
		),
		"nidump passwd .": (
			"root:*:0:1::0:0:System Administrator:/:/bin/csh\n"
			+ "me::20:20::0:0:NeXT User:/Users/me:/bin/csh\n"
			+ "jobs:*:101:20::0:0:Steve Jobs:/Users/jobs:/bin/csh"
		)
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "Terminal  /Users/jobs  (csh)",
			"type": "terminal",
			"pos": Vector2(140, 56),
			"size": Vector2(540, 340),
			"content": ""
		},
		{
			"id": "workspace",
			"title": "File Viewer — /NextApps",
			"type": "files",
			"pos": Vector2(530, 370),
			"size": Vector2(435, 275),
			"content": (
				"Shelf: [ / ] [ /Users/jobs ] [ /NextApps ] [ /NextDeveloper ]\n"
				+ "===========================================================\n"
				+ "  |> Workspace.app          |> InterfaceBuilder.app\n"
				+ "  |> Terminal.app           |> ProjectBuilder.app\n"
				+ "  |> Mail.app (NeXTMail)    |> WorldWideWeb.app (CERN)\n"
				+ "  |>Yap.app (PostScript)    |> Grab.app\n"
				+ "-----------------------------------------------------------\n"
				+ "Disk: 516 MB SCSI (198 MB Free) • Optical Drive Ready"
			)
		},
		{
			"id": "ib_inspector",
			"title": "Interface Builder — Inspector",
			"type": "text",
			"pos": Vector2(125, 420),
			"size": Vector2(385, 225),
			"content": (
				"[ Attributes | Connections | Size | Help ]\n"
				+ "--------------------------------------------------\n"
				+ "Class  : NXWindow (Application Kit)\n"
				+ "Outlet : delegate -> DoomMapController\n"
				+ "Action : renderBSPView:\n\n"
				+ "Display PostScript Backing Store: Buffered\n"
				+ "DSP56001 SoundKit Synthesis: Online"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_ws", "label": "Workspace", "glyph": "[NeXT]", "target_window_id": "workspace"},
		{"id": "icon_term", "label": "Terminal", "glyph": "[>_]", "target_window_id": "terminal"},
		{"id": "icon_ib", "label": "Interface\nBuilder", "glyph": "[IB]", "target_window_id": "ib_inspector"}
	]

	p.fan_base_freq = 112.0
	p.fan_noise_level = 0.24
	p.hdd_seek_interval_range = Vector2(2.5, 5.8)
	return p


# ==============================================================================
# 3. SUN SOLARIS 8 (SUNOS 5.8) - SUN ULTRA 60 CREATOR3D (2000)
# ==============================================================================
static func _build_solaris_8() -> OSProfile:
	var p := OSProfile.new()
	p.id = "solaris_8"
	p.category = "UNIX & Alt-OS"
	p.display_name = "Sun Solaris 8 (Ultra 60 Creator3D)"
	p.short_name = "Solaris 8"
	p.release_year = "2000"
	p.has_crt = true
	p.aspect_ratio = "4:3"
	p.vendor = "Sun Microsystems, Inc."
	p.architecture_summary = "SPARCv9 (64-Bit) • SunOS 5.8 • Solaris CDE 1.4 / OpenWindows"
	p.hardware_profile = "Sun Ultra 60 • Dual 450MHz UltraSPARC-II • 1024MB ECC • UPA Creator3D"
	p.description = (
		"Dot-com era enterprise & engineering powerhouse. Boots via Sun's Forth-based OpenBoot "
		+ "PROM ('ok boot disk') into 64-bit SunOS 5.8 and Solaris CDE with signature Sun plum/violet "
		+ "and slate-grey Motif borders."
	)

	p.bios_header = (
		"Sun Ultra 60 UPA/PCI (2 X UltraSPARC-II 450MHz), Keyboard Present\n"
		+ "OpenBoot 3.23, 1024 MB memory installed, Serial #11849204."
	)
	p.boot_bg_color = Color("080910")
	p.boot_text_color = Color("dce4f0")
	p.boot_logs = [
		{"text": "Ethernet address 8:0:20:a8:41:1c, Host ID: 80a8411c.", "delay": 1.00, "sfx": "fan_spinup", "color": "#ffffff"},
		{"text": "Initializing 1024MB ECC Memory ... Done.", "delay": 1.35, "sfx": "beep", "color": "#88e0b0"},
		{"text": "ok boot disk", "delay": 1.20, "sfx": "hdd_click", "color": "#ffd077"},
		{"text": "Boot device: /pci@1f,4000/scsi@3/disk@0,0:a  File and args: kernel/sparcv9/unix", "delay": 1.45, "sfx": "hdd_burst", "color": "#dce4f0"},
		{"text": "SunOS Release 5.8 Version Generic_108528-13 64-bit", "delay": 1.15, "sfx": "hdd_click", "color": "#77ccff"},
		{"text": "Copyright 1983-2000 Sun Microsystems, Inc.  All rights reserved.", "delay": 0.85, "sfx": "", "color": "#b0c0d8"},
		{"text": "cpu0: SUNW,UltraSPARC-II (upaid 0 impl 0x11 ver 0xa0 clock 450 MHz)", "delay": 0.80, "sfx": "", "color": "#dce4f0"},
		{"text": "cpu1: SUNW,UltraSPARC-II (upaid 1 impl 0x11 ver 0xa0 clock 450 MHz)", "delay": 0.80, "sfx": "", "color": "#dce4f0"},
		{"text": "glm0: Symbios 53c875 Ultra-Wide SCSI at pci@1f,4000/scsi@3", "delay": 1.05, "sfx": "hdd_click", "color": "#b0c0d8"},
		{"text": "sd0 at glm0: target 0 lun 0 (SEAGATE ST318203LSUN18G)", "delay": 1.15, "sfx": "hdd_burst", "color": "#b0c0d8"},
		{"text": "ffb0 at root: UPA 0x1e 0x0 (SUNW,ffb2+ Creator3D Series 3 Double-Buffered)", "delay": 0.95, "sfx": "", "color": "#ffcc77"},
		{"text": "configuring IPv4 interfaces: hme0 (100Mbps Full-Duplex).", "delay": 1.00, "sfx": "", "color": "#b0c0d8"},
		{"text": "The system is coming up.  Please wait.", "delay": 1.35, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "starting rpc services: rpcbind keyserv ypbind done.", "delay": 1.05, "sfx": "hdd_click", "color": "#b0c0d8"},
		{"text": "Starting Solaris Common Desktop Environment (dtlogin / Xsun)...", "delay": 1.60, "sfx": "hdd_burst", "color": "#88e0b0"}
	]

	p.chrome_style = "motif_cde"
	p.desktop_bg_color = Color("4a4868")
	p.desktop_secondary_color = Color("34324c")
	p.panel_bg_color = Color("a2a0b4")
	p.panel_text_color = Color("14121c")
	p.window_bg_color = Color("b4b2c4")
	p.window_text_color = Color("111018")
	p.window_border_color = Color("dcdaf0")
	p.titlebar_active_color = Color("6b4c7a")
	p.titlebar_active_gradient_end = Color("845f96")
	p.titlebar_inactive_color = Color("7c7a8e")
	p.titlebar_text_color = Color("ffffff")
	p.accent_color = Color("6b4c7a")

	p.terminal_title = "dtterm - ultra60:/export/home/admin"
	p.terminal_bg_color = Color("fdf8ed")
	p.terminal_fg_color = Color("18141c")
	p.terminal_prompt = "ultra60% "
	p.terminal_welcome_banner = (
		"Sun Microsystems Inc.   SunOS 5.8       Generic February 2000\n"
		+ "Sun Ultra 60 UPA/PCI (2 X UltraSPARC-II 450MHz)\n"
		+ "Type 'psrinfo -v', 'prtconf', 'df -k', 'showrev -a', or 'help'."
	)
	p.terminal_commands = {
		"uname -a": "SunOS ultra60 5.8 Generic_108528-13 sun4u sparc SUNW,Ultra-60",
		"psrinfo -v": (
			"Status of processor 0 as of: 10/21/00 02:14:00\n"
			+ "  Processor has been on-line since 10/21/00 01:00:12.\n"
			+ "  The sparcv9 processor operates at 450 MHz,\n"
			+ "        and has a sparcv9 floating point processor.\n"
			+ "Status of processor 1 as of: 10/21/00 02:14:00\n"
			+ "  The sparcv9 processor operates at 450 MHz,\n"
			+ "        and has a sparcv9 floating point processor."
		),
		"prtconf": (
			"System Configuration:  Sun Microsystems  sun4u\n"
			+ "Memory size: 1024 Megabytes\n"
			+ "System Peripherals (Software Nodes):\n"
			+ "SUNW,Ultra-60\n"
			+ "    packages (driver not attached)\n"
			+ "    SUNW,UltraSPARC-II (driver not attached)\n"
			+ "    SUNW,ffb@1e,0 (ffb0 - Creator3D)\n"
			+ "    pci@1f,4000 (scsi@3 -> sd0 SEAGATE 18GB)"
		),
		"df -k": (
			"Filesystem            kbytes    used   avail capacity  Mounted on\n"
			+ "/dev/dsk/c0t0d0s0    4128448 1240812 2846352    31%    /\n"
			+ "/proc                      0       0       0     0%    /proc\n"
			+ "swap                 1892416      32 1892384     1%    /tmp\n"
			+ "/dev/dsk/c0t0d0s7   12480112 3102400 9252910    26%    /export/home"
		),
		"showrev -a": "Hostname: ultra60\nHostid: 80a8411c\nRelease: 5.8\nKernel architecture: sun4u\nApplication architecture: sparc\nWindow System: Solaris CDE 1.4 / X11R6.4"
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "dtterm - ultra60:/export/home/admin",
			"type": "terminal",
			"pos": Vector2(120, 50),
			"size": Vector2(550, 345),
			"content": ""
		},
		{
			"id": "sam",
			"title": "perfmeter — ultra60",
			"type": "monitor",
			"pos": Vector2(530, 360),
			"size": Vector2(440, 265),
			"content": (
				"Solaris CDE Performance Meter (ultra60)\n"
				+ "==============================================\n"
				+ "cpu  (2x UltraSPARC-II 450MHz) :  12%\n"
				+ "pkts (hme0 100Base-TX)         :  48 pkt/s\n"
				+ "page (VM Paging Daemon)        :   0 pg/s\n"
				+ "disk (c0t0d0 SUN18G 10K)       :   4 xfer/s\n"
				+ "load (1/5/15 min average)      :  0.14"
			)
		},
		{
			"id": "dtpad",
			"title": "Text Editor — /etc/motd",
			"type": "text",
			"pos": Vector2(110, 415),
			"size": Vector2(400, 210),
			"content": (
				"Sun Microsystems Solaris 8 (2/00) — Sun Ultra 60\n"
				+ "-------------------------------------------------\n"
				+ "- Creator3D UPA Framebuffer running at 1280x1024.\n"
				+ "- Sun Forte C/C++ 6.0 & Java2 SDK 1.2.2 installed\n"
				+ "  in /opt/SUNWspro."
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_term", "label": "dtterm", "glyph": "[>_]", "target_window_id": "terminal"},
		{"id": "icon_perf", "label": "perfmeter", "glyph": "[SUN]", "target_window_id": "sam"},
		{"id": "icon_pad", "label": "dtpad", "glyph": "[TXT]", "target_window_id": "dtpad"}
	]

	p.fan_base_freq = 142.0
	p.fan_noise_level = 0.31
	p.hdd_seek_interval_range = Vector2(2.2, 5.5)
	return p


# ==============================================================================
# 4. RED HAT LINUX 6.2 ("ZOOT") - ENLIGHTENMENT DR16 / GNOME 1.0 (2000)
# ==============================================================================
static func _build_redhat_62() -> OSProfile:
	var p := OSProfile.new()
	p.id = "redhat_62"
	p.category = "UNIX & Alt-OS"
	p.display_name = "Red Hat Linux 6.2 (Zoot / Enlightenment)"
	p.short_name = "Red Hat 6.2"
	p.release_year = "2000"
	p.has_crt = true
	p.aspect_ratio = "4:3"
	p.has_energy_star_badge = true
	p.vendor = "Red Hat, Inc. (Durham, NC)"
	p.architecture_summary = "i686 • Linux 2.2.14-5.0 • GNOME 1.0.55 + Enlightenment 0.15.5"
	p.hardware_profile = "AMD Athlon 750MHz (Slot-A Pluto) • Asus K7M • 256MB PC100 • Riva TNT2 Ultra"
	p.description = (
		"Classic Y2K-era Linux distribution before Fedora and RHEL existed. Boots via LILO into "
		+ "Linux kernel 2.2.14 with Red Hat's classic '[  OK  ]' SysV init scripts, paired with "
		+ "Rasterman's futuristic BrushedMetal Enlightenment window manager and GNOME 1.0."
	)

	p.bios_header = (
		"Award Medallion BIOS v6.0, An Energy Star Ally\n"
		+ "ASUS K7M ACPI BIOS Revision 1009 (AMD-751 Irongate Chipset)"
	)
	p.boot_bg_color = Color("040406")
	p.boot_text_color = Color("cccccc")
	p.boot_logs = [
		{"text": "AMD Athlon(tm) Processor 750MHz (Slot-A 512KB L2 Cache)", "delay": 1.00, "sfx": "fan_spinup", "color": "#ffffff"},
		{"text": "Memory Test : 262144K OK", "delay": 1.40, "sfx": "beep", "color": "#ffffff"},
		{"text": "Detecting Primary Master ... Maxtor 52049H4 (20.4 GB UDMA/66)", "delay": 1.15, "sfx": "hdd_click", "color": "#c0c0c0"},
		{"text": "Floppy disk(s) seek      ... Drive A: 1.44M, 3.5 in.", "delay": 1.65, "sfx": "floppy", "color": "#c0c0c0"},
		{"text": "", "delay": 0.45, "sfx": "", "color": ""},
		{"text": "LILO boot: linux", "delay": 1.25, "sfx": "hdd_click", "color": "#ffffff"},
		{"text": "Loading linux...............", "delay": 1.45, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "Linux version 2.2.14-5.0 (root@porky.devel.redhat.com) (gcc version egcs-2.91.66)", "delay": 0.90, "sfx": "", "color": "#88d8ff"},
		{"text": "Welcome to Red Hat Linux", "delay": 0.85, "sfx": "", "color": "#ff4444"},
		{"text": "                Press 'I' to enter interactive startup.", "delay": 0.75, "sfx": "", "color": "#cccccc"},
		{"text": "Checking root filesystem (/dev/hda1: clean, 68412/1280000 files)       [  OK  ]", "delay": 1.20, "sfx": "hdd_burst", "color": "#66ee77"},
		{"text": "Activating swap partitions (/dev/hda5)                                 [  OK  ]", "delay": 0.80, "sfx": "hdd_click", "color": "#66ee77"},
		{"text": "Bringing up interface eth0 (3c59x 100BaseTX)                           [  OK  ]", "delay": 1.00, "sfx": "", "color": "#66ee77"},
		{"text": "Starting portmapper & NFS lockd                                        [  OK  ]", "delay": 0.85, "sfx": "", "color": "#66ee77"},
		{"text": "Starting sendmail & gpm mouse services                                 [  OK  ]", "delay": 0.95, "sfx": "hdd_click", "color": "#66ee77"},
		{"text": "Starting XFree86 3.3.6 (SVGA / RIVA TNT2 Ultra) & GNOME/Enlightenment  [  OK  ]", "delay": 1.60, "sfx": "hdd_burst", "color": "#66ee77"}
	]

	p.chrome_style = "gnome_human"
	p.desktop_bg_color = Color("283c52")
	p.desktop_secondary_color = Color("1b2838")
	p.panel_bg_color = Color("c6c6c6")
	p.panel_text_color = Color("111111")
	p.window_bg_color = Color("dcdcdc")
	p.window_text_color = Color("111111")
	p.window_border_color = Color("4a6480")
	p.titlebar_active_color = Color("3c6898")
	p.titlebar_active_gradient_end = Color("264466")
	p.titlebar_inactive_color = Color("78828c")
	p.titlebar_text_color = Color("ffffff")
	p.accent_color = Color("cc0000")

	p.terminal_title = "gnome-terminal — [root@zoot /root]#"
	p.terminal_bg_color = Color("000000")
	p.terminal_fg_color = Color("d8d8d8")
	p.terminal_prompt = "[root@zoot /root]# "
	p.terminal_welcome_banner = (
		"Red Hat Linux release 6.2 (Zoot)\n"
		+ "Kernel 2.2.14-5.0 on an i686 (AMD Athlon 750MHz)\n"
		+ "Type 'uname -a', 'cat /etc/redhat-release', 'rpm -qa', 'free', or 'help'."
	)
	p.terminal_commands = {
		"uname -a": "Linux zoot.localdomain 2.2.14-5.0 #1 Tue Mar 7 21:07:39 EST 2000 i686 unknown",
		"cat /etc/redhat-release": "Red Hat Linux release 6.2 (Zoot)",
		"rpm -qa": (
			"kernel-2.2.14-5.0\n"
			+ "glibc-2.1.3-15\n"
			+ "XFree86-3.3.6-20\n"
			+ "enlightenment-0.15.5-48\n"
			+ "gnome-core-1.0.55-12\n"
			+ "xmms-1.0.1-4\n"
			+ "gimp-1.0.4-6\n"
			+ "netscape-communicator-4.72-6"
		),
		"free": (
			"             total       used       free     shared    buffers     cached\n"
			+ "Mem:        257612      68420     189192      28412      12400      31200\n"
			+ "-/+ buffers/cache:      24820     232792\n"
			+ "Swap:       522072          0     522072"
		),
		"ls": "Desktop/  GNUstep/  XF86Config  anaconda-ks.cfg  quake3-linux-x86.sh*"
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "gnome-terminal — [root@zoot /root]#",
			"type": "terminal",
			"pos": Vector2(125, 58),
			"size": Vector2(545, 345),
			"content": ""
		},
		{
			"id": "sysmon",
			"title": "GTop — System Process & Memory Viewer",
			"type": "monitor",
			"pos": Vector2(530, 380),
			"size": Vector2(440, 265),
			"content": (
				"Red Hat Linux 6.2 (Zoot) // Linux 2.2.14-5.0\n"
				+ "===============================================\n"
				+ "CPU (AMD Athlon 750MHz)  : [|||.................]  14%\n"
				+ "RAM (256MB PC100 SDRAM)  : [||||................]  66 MB\n"
				+ "XFree86 3.3.6 (SVGA)     : 1024x768 @ 16bpp\n"
				+ "Window Manager           : Enlightenment 0.15.5"
			)
		},
		{
			"id": "about",
			"title": "LinuxConf 1.17r2 — Control Panel",
			"type": "files",
			"pos": Vector2(115, 420),
			"size": Vector2(395, 225),
			"content": (
				"[ Config | Control | Status | Help ]\n"
				+ "-----------------------------------------------\n"
				+ "+ Networking (Client tasks, Host name, DNS)\n"
				+ "+ User accounts (Normal, Special, PPP/SLIP)\n"
				+ "+ File systems (Access local drive, NFS)\n"
				+ "+ Boot mode (LILO defaults, Runlevel 5)"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_term", "label": "GNOME\nTerminal", "glyph": "[>_]", "target_window_id": "terminal"},
		{"id": "icon_gtop", "label": "GTop\nMonitor", "glyph": "[CPU]", "target_window_id": "sysmon"},
		{"id": "icon_lconf", "label": "LinuxConf", "glyph": "[CFG]", "target_window_id": "about"}
	]

	p.fan_base_freq = 124.0
	p.fan_noise_level = 0.26
	p.hdd_seek_interval_range = Vector2(2.6, 6.2)
	return p


# ==============================================================================
# 5. FREEBSD 4.11-STABLE (BEASTIE LOADER / WINDOWMAKER, 2004)
# ==============================================================================
static func _build_freebsd_411() -> OSProfile:
	var p := OSProfile.new()
	p.id = "freebsd_411"
	p.category = "UNIX & Alt-OS"
	p.display_name = "FreeBSD 4.11-STABLE (WindowMaker)"
	p.short_name = "FreeBSD 4.11"
	p.release_year = "2004"
	p.has_crt = true
	p.aspect_ratio = "4:3"
	p.has_energy_star_badge = true
	p.vendor = "The FreeBSD Project (Berkeley UNIX)"
	p.architecture_summary = "i386 • FreeBSD 4.11-STABLE • SoftUpdates UFS • WindowMaker 0.80"
	p.hardware_profile = "Supermicro P3TDDE • Dual Pentium III-S 1.4GHz Tualatin • 1GB ECC • Adaptec 29160"
	p.description = (
		"Rock-solid 4.4BSD-Lite UNIX server & workstation legendknown for multi-year uptimes, "
		+ "the ASCII Beastie Daemon boot menu, Marshall Kirk McKusick's SoftUpdates UFS filesystem, "
		+ "the '/usr/ports' source tree, and the NeXT-inspired WindowMaker desktop."
	)

	p.bios_header = (
		"AMIBIOS (C) 2001 American Megatrends, Inc.\n"
		+ "Supermicro P3TDDE Serverboard (VIA Apollo Pro266T) BIOS Rev 1.0b"
	)
	p.boot_bg_color = Color("040508")
	p.boot_text_color = Color("d8dce4")
	p.boot_logs = [
		{"text": "Processor : 2x Intel(R) Pentium(R) III CPU - S 1400MHz (512KB Tualatin)", "delay": 1.00, "sfx": "fan_spinup", "color": "#ffffff"},
		{"text": "Memory Test : 1048576K OK (DDR ECC Registered)", "delay": 1.40, "sfx": "beep", "color": "#ffffff"},
		{"text": "Adaptec AIC-7892 Ultra160 SCSI BIOS v2.57.2 — Scanning SCSI ID 0...", "delay": 1.35, "sfx": "hdd_burst", "color": "#ffd077"},
		{"text": "   SCSI ID 0: FUJITSU MAN3184MP 18.4GB 10,000 RPM Ultra160", "delay": 0.90, "sfx": "hdd_click", "color": "#e0e0e0"},
		{"text": "", "delay": 0.45, "sfx": "", "color": ""},
		{"text": "FreeBSD/i386 bootstrap loader, Revision 0.8   ( , )   Daemon Ready", "delay": 0.95, "sfx": "hdd_click", "color": "#ff5555"},
		{"text": "Loading /boot/defaults/loader.conf            /(   )\\  Welcome to FreeBSD!", "delay": 0.85, "sfx": "", "color": "#ff5555"},
		{"text": "/kernel text=0x24a120 data=0x32140            ^^   ^^  1. Boot FreeBSD [default]", "delay": 1.25, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "Copyright (c) 1992-2004 The FreeBSD Project.", "delay": 0.85, "sfx": "", "color": "#77bbff"},
		{"text": "Copyright (c) 1979, 1980, 1983, 1986, 1988, 1989, 1991, 1992, 1993, 1994", "delay": 0.55, "sfx": "", "color": "#a8b8c8"},
		{"text": "        The Regents of the University of California. All rights reserved.", "delay": 0.70, "sfx": "", "color": "#a8b8c8"},
		{"text": "FreeBSD 4.11-STABLE #0: Thu Oct 21 01:12:44 PDT 2004", "delay": 0.90, "sfx": "", "color": "#ffffff"},
		{"text": "CPU: Intel(R) Pentium(R) III CPU family 1400MHz (1399.82-MHz 686-class CPU)", "delay": 0.85, "sfx": "", "color": "#d8dce4"},
		{"text": "da0 at ahc0 bus 0 target 0 lun 0: <FUJITSU MAN3184MP 0108> Fixed Direct Access SCSI-3", "delay": 1.15, "sfx": "hdd_click", "color": "#d8dce4"},
		{"text": "Mounting root from ufs:/dev/da0s1a (SoftUpdates enabled)", "delay": 1.25, "sfx": "hdd_burst", "color": "#88ee99"},
		{"text": "Starting network: lo0 fxp0 (Intel Pro/100B 100baseTX <full-duplex>).", "delay": 1.00, "sfx": "", "color": "#d8dce4"},
		{"text": "Starting standard daemons: inetd cron sshd sendmail usbd.", "delay": 1.05, "sfx": "hdd_click", "color": "#d8dce4"},
		{"text": "Starting XFree86 4.4.0 & WindowMaker (wmaker)...", "delay": 1.55, "sfx": "hdd_burst", "color": "#77bbff"}
	]

	p.chrome_style = "nextstep_black"
	p.desktop_bg_color = Color("2b3c54")
	p.desktop_secondary_color = Color("1d293b")
	p.panel_bg_color = Color("a8aeb8")
	p.panel_text_color = Color("111111")
	p.window_bg_color = Color("c8ccd4")
	p.window_text_color = Color("111111")
	p.window_border_color = Color("18202c")
	p.titlebar_active_color = Color("1b2838")
	p.titlebar_active_gradient_end = Color("344d6c")
	p.titlebar_inactive_color = Color("6e7682")
	p.titlebar_text_color = Color("ffffff")
	p.accent_color = Color("aa2222")

	p.terminal_title = "xterm — beastie.bsd.org (tcsh)"
	p.terminal_bg_color = Color("0c1016")
	p.terminal_fg_color = Color("e0e6f0")
	p.terminal_prompt = "root@beastie:~ # "
	p.terminal_welcome_banner = (
		"FreeBSD 4.11-STABLE (BEASTIE_SMP) #0: Thu Oct 21 01:12:44 PDT 2004\n"
		+ "Welcome to FreeBSD! Type 'uname -a', 'uptime', 'df -h', 'sockstat', or 'help'."
	)
	p.terminal_commands = {
		"uname -a": "FreeBSD beastie.bsd.org 4.11-STABLE FreeBSD 4.11-STABLE #0: i386",
		"uptime": " 2:14AM  up 418 days, 19:42, 2 users, load averages: 0.04, 0.02, 0.00",
		"df -h": (
			"Filesystem    Size   Used  Avail Capacity  Mounted on\n"
			+ "/dev/da0s1a   496M    84M   372M    18%    /\n"
			+ "/dev/da0s1e   496M    14M   442M     3%    /var\n"
			+ "/dev/da0s1f    15G   4.2G   9.6G    30%    /usr"
		),
		"sockstat": (
			"USER     COMMAND    PID   FD PROTO  LOCAL ADDRESS         FOREIGN ADDRESS\n"
			+ "root     sshd       142    3 tcp4   *:22                  *:*\n"
			+ "www      httpd      198   16 tcp4   *:80                  *:*\n"
			+ "root     syslogd     94    4 udp4   *:514                 *:*"
		),
		"ls": "KERNCONF.SMP  ports-supfile  xorg.conf"
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "xterm — root@beastie:~",
			"type": "terminal",
			"pos": Vector2(130, 52),
			"size": Vector2(545, 345),
			"content": ""
		},
		{
			"id": "wmmem",
			"title": "WindowMaker DockApps // systat -vmstat",
			"type": "monitor",
			"pos": Vector2(535, 370),
			"size": Vector2(435, 270),
			"content": (
				"FreeBSD 4.11-STABLE // Uptime: 418 Days\n"
				+ "==============================================\n"
				+ "[wmcpuload]  CPU0/CPU1 Tualatin :  6%\n"
				+ "[wmmemload]  Active/Wired RAM   : 184 / 1024 MB\n"
				+ "[wmnet]      fxp0 (100BaseTX)   : 14.2 KB/s\n"
				+ "[ports]      /usr/ports/x11-wm/windowmaker"
			)
		},
		{
			"id": "ports",
			"title": "XEmacs — /usr/src/sys/i386/conf/BEASTIE_SMP",
			"type": "text",
			"pos": Vector2(120, 420),
			"size": Vector2(395, 220),
			"content": (
				"machine         i386\n"
				+ "cpu             I686_CPU\n"
				+ "ident           BEASTIE_SMP\n"
				+ "options         SMP                 # Symmetric MultiProcessor\n"
				+ "options         APIC_IO             # Symmetric (APIC) I/O\n"
				+ "options         SOFTUPDATES         # Fast UFS SoftUpdates"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_xterm", "label": "xterm", "glyph": "[>_]", "target_window_id": "terminal"},
		{"id": "icon_systat", "label": "systat", "glyph": "[BSD]", "target_window_id": "wmmem"},
		{"id": "icon_kern", "label": "Kernel\nConfig", "glyph": "[SRC]", "target_window_id": "ports"}
	]

	p.fan_base_freq = 135.0
	p.fan_noise_level = 0.28
	p.hdd_seek_interval_range = Vector2(2.4, 5.8)
	return p


# ==============================================================================
# 6. SCO OPENSERVER 5.0.5 - COMPAQ PROLIANT 1600 (1999)
# ==============================================================================
static func _build_sco_openserver() -> OSProfile:
	var p := OSProfile.new()
	p.id = "sco_openserver"
	p.category = "UNIX & Alt-OS"
	p.display_name = "SCO OpenServer 5.0.5 (SCO Panorama)"
	p.short_name = "SCO UNIX 5.0.5"
	p.release_year = "1999"
	p.has_crt = true
	p.aspect_ratio = "4:3"
	p.vendor = "The Santa Cruz Operation, Inc."
	p.architecture_summary = "i386 SVR3.2 v5.0.5 • HTFS • SCO Panorama (IXI X.desktop / Motif)"
	p.hardware_profile = "Compaq ProLiant 1600 • Dual Pentium II 450MHz • 512MB ECC • Smart-2SL RAID"
	p.description = (
		"Late-90s enterprise back-office UNIX workhorse running on a Compaq ProLiant tower. "
		+ "Features the SCO `Boot:` prompt, `hwconfig` hardware summary table, `scoadmin`, and "
		+ "the Motif-based SCO Panorama (IXI X.desktop) graphical environment."
	)

	p.bios_header = (
		"Compaq System ROMBIOS (P08 02/18/1999) — Compaq ProLiant 1600 Server\n"
		+ "(C) Copyright 1982, 1999 Compaq Computer Corporation. All Rights Reserved."
	)
	p.boot_bg_color = Color("05080a")
	p.boot_text_color = Color("d0dce0")
	p.boot_logs = [
		{"text": "Processor 1: Intel Pentium(R) II 450MHz — Processor 2: Initialized", "delay": 1.00, "sfx": "fan_spinup", "color": "#ffffff"},
		{"text": "524288 KB System ECC Memory OK", "delay": 1.40, "sfx": "beep", "color": "#88eeaa"},
		{"text": "Compaq Smart-2SL Array Controller (v4.04) — 1 Logical Drive Initialized", "delay": 1.35, "sfx": "hdd_burst", "color": "#ffd077"},
		{"text": "Floppy Diskette Drive A: 1.44 MB 3.5-inch OK", "delay": 1.60, "sfx": "floppy", "color": "#c8d0d8"},
		{"text": "", "delay": 0.45, "sfx": "", "color": ""},
		{"text": "SCO OpenServer(TM) Release 5", "delay": 0.90, "sfx": "hdd_click", "color": "#55ccff"},
		{"text": "Boot: hd(40)unix", "delay": 1.35, "sfx": "hdd_burst", "color": "#ffffff"},
		{"text": "Loading kernel hd(40)unix .text .data .bss ...", "delay": 1.45, "sfx": "hdd_burst", "color": "#d0dce0"},
		{"text": "name=vec base=0x000000000 limit=0x0000000FF type=1 flags=0x000", "delay": 0.65, "sfx": "", "color": "#9ab0b8"},
		{"text": "%serial    0x03F8-0x03FF      4   -   unit=0 type=Standard nports=1", "delay": 0.55, "sfx": "", "color": "#9ab0b8"},
		{"text": "%floppy    0x03F2-0x03F7      6   2   unit=0 type=135ds18", "delay": 0.55, "sfx": "", "color": "#9ab0b8"},
		{"text": "%ida       0x4000-0x40FF     11   -   Compaq Smart-2SL RAID lun=0", "delay": 1.05, "sfx": "hdd_click", "color": "#d0dce0"},
		{"text": "Checking HTFS root filesystem (/dev/root)... clean.", "delay": 1.25, "sfx": "hdd_burst", "color": "#88eeaa"},
		{"text": "SYSTEM INITIALIZATION COMPLETE — Entering Multiuser Mode (Run-Level 2)", "delay": 1.15, "sfx": "hdd_click", "color": "#ffffff"},
		{"text": "Starting SCO Login Manager (scologin) & X.desktop (Panorama)...", "delay": 1.55, "sfx": "hdd_burst", "color": "#55ccff"}
	]

	p.chrome_style = "motif_cde"
	p.desktop_bg_color = Color("345864")
	p.desktop_secondary_color = Color("243e47")
	p.panel_bg_color = Color("a8b0b8")
	p.panel_text_color = Color("111518")
	p.window_bg_color = Color("b8c0c8")
	p.window_text_color = Color("111518")
	p.window_border_color = Color("dde4ec")
	p.titlebar_active_color = Color("2b6878")
	p.titlebar_active_gradient_end = Color("3d8598")
	p.titlebar_inactive_color = Color("7a848c")
	p.titlebar_text_color = Color("ffffff")
	p.accent_color = Color("2b6878")

	p.terminal_title = "scoterm — proliant:/usr/root"
	p.terminal_bg_color = Color("10181c")
	p.terminal_fg_color = Color("dce8ee")
	p.terminal_prompt = "# "
	p.terminal_welcome_banner = (
		"SCO OpenServer(TM) Release 5 (proliant) (tty01)\n"
		+ "(C) 1976-1998 The Santa Cruz Operation, Inc.\n"
		+ "Type 'uname -X', 'hwconfig', 'scoadmin', 'df -v', or 'help'."
	)
	p.terminal_commands = {
		"uname -a": "SCO_SV proliant 3.2 5.0.5 i386",
		"uname -x": (
			"System = SCO_SV\nNode = proliant\nRelease = 3.2v5.0.5\n"
			+ "KernelID = 98/07/02\nMachine = Pentium II\nNumCPU = 2"
		),
		"hwconfig": (
			"name=fpu      vec=13 dma=- type=80387-compatible\n"
			+ "name=serial   base=0x3F8 offset=0x7 vec=4 dma=- unit=0\n"
			+ "name=floppy   base=0x3F2 offset=0x5 vec=6 dma=2 unit=0 type=135ds18\n"
			+ "name=ida      base=0x4000 vec=11 Compaq Smart-2SL RAID\n"
			+ "name=net0     base=0x5000 vec=10 Compaq Netelligent 10/100TX"
		),
		"df -v": (
			"Mount Dir  Filesystem         blocks      used      free   %used\n"
			+ "/          /dev/root        16777216   4120840  12656376     25%\n"
			+ "/stand     /dev/boot           40960     12840     28120     31%"
		),
		"scoadmin": "SCOadmin Manager: [Account Manager] [Filesystem Manager] [Hardware/Kernel Manager] [Networks]"
	}

	p.default_windows = [
		{
			"id": "terminal",
			"title": "scoterm — proliant:/usr/root",
			"type": "terminal",
			"pos": Vector2(120, 54),
			"size": Vector2(545, 345),
			"content": ""
		},
		{
			"id": "sam",
			"title": "SCOadmin — System Administration",
			"type": "monitor",
			"pos": Vector2(535, 365),
			"size": Vector2(435, 265),
			"content": (
				"SCO OpenServer Release 5.0.5 // Compaq ProLiant 1600\n"
				+ "====================================================\n"
				+ "[Folder] Account Manager\n"
				+ "[Folder] Filesystem Manager (HTFS / EAFS)\n"
				+ "[Folder] Hardware / Kernel Manager (Link Kit)\n"
				+ "[Folder] Printers & UUCP Communications\n"
				+ "----------------------------------------------------\n"
				+ "Smart-2SL RAID Logical Drive 0: OPTIMAL"
			)
		},
		{
			"id": "dtpad",
			"title": "SCO Edit — /etc/default/boot",
			"type": "text",
			"pos": Vector2(115, 415),
			"size": Vector2(395, 215),
			"content": (
				"DEFBOOTSTR=hd(40)unix swap=hd(41) dump=hd(41) root=hd(42)\n"
				+ "AUTOBOOT=YES\n"
				+ "TIMEOUT=60\n"
				+ "MAPKEY=YES\n"
				+ "SERIAL8=NO"
			)
		}
	]

	p.desktop_icons = [
		{"id": "icon_term", "label": "scoterm", "glyph": "[>_]", "target_window_id": "terminal"},
		{"id": "icon_adm", "label": "SCOadmin", "glyph": "[SCO]", "target_window_id": "sam"},
		{"id": "icon_edit", "label": "SCO Edit", "glyph": "[TXT]", "target_window_id": "dtpad"}
	]

	p.fan_base_freq = 144.0
	p.fan_noise_level = 0.32
	p.hdd_seek_interval_range = Vector2(2.2, 5.4)
	return p

