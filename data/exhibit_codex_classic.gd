extends RefCounted
## Archival Museum Exhibit Packages (Part II: 1985–1999 Classic Systems).
## Provides historical context, engineering analysis, Wikipedia-style Infobox technical
## specifications, period-correct usage case dossiers, and media gallery slots.

const OSProfile = preload("res://data/os_profile.gd")


static func populate(p: OSProfile) -> bool:
	match p.id:
		"datapoint_2200":
			_populate_datapoint_2200(p)
			return true
		"macosx_g4":
			_populate_macosx_g4(p)
			return true
		"sco_openserver":
			_populate_sco_openserver(p)
			return true
		"win98_se":
			_populate_win98_se(p)
			return true
		"os2_warp":
			_populate_os2_warp(p)
			return true
		"mac_sys75":
			_populate_mac_sys75(p)
			return true
		"nextstep_33":
			_populate_nextstep_33(p)
			return true
		"amiga_os31":
			_populate_amiga_os31(p)
			return true
		"apple_iie":
			_populate_apple_iie(p)
			return true
	return false


static func _populate_macosx_g4(p: OSProfile) -> void:
	p.exhibit_subtitle = "Apple's PowerPC G4 'Supercomputer' Tower & The Aqua / Darwin Revolution"
	p.era_classification = "Late-1990s / Early-2000s Apple Renaissance & UNIX Transition (1999–2002)"
	p.historical_overview = (
		"Unveiled by Steve Jobs at Seybold San Francisco on August 31, 1999, the Power Mac G4 ('Sawtooth' AGP Graphics) "
		+ "introduced the Motorola PowerPC 7400 processor with its 128-bit AltiVec 'Velocity Engine' vector unit—famously "
		+ "classified by the U.S. Government as a munitions-grade supercomputer capable of over 1 Gigaflop. Paired here with "
		+ "Mac OS X 10.2 ('Jaguar'), this machine bridged the gap between Classic Mac OS 9 publishing workflows and Apple's "
		+ "modern NeXTSTEP/FreeBSD-derived Darwin UNIX foundation."
	)
	p.historical_context = (
		"Designed by Jonathan Ive in translucent graphite and silver polycarbonate with signature cantilevered corner handles "
		+ "and a single-latch fold-down side door, the 1999 Power Mac G4 revolutionized desktop industrial design—allowing "
		+ "instant tool-free access to the motherboard while the system was running. When Mac OS X 10.2 Jaguar arrived in August "
		+ "2002, it introduced Quartz Extreme (accelerating the translucent Aqua interface on the AGP ATI Rage 128 Pro / Radeon "
		+ "GPU), Rendezvous (Bonjour) zero-config networking, and CUPS printing, marking the moment Mac OS X became the primary "
		+ "daily operating system for creative professionals."
	)
	p.engineering_innovations = (
		"• PowerPC 7400 (G4) & AltiVec 'Velocity Engine': Dedicated 128-bit SIMD vector processing unit executing four 32-bit "
		+ "floating-point operations per clock cycle, accelerating Adobe Photoshop filters, Final Cut Pro transitions, and "
		+ "RC5 cryptography by up to 400%.\n"
		+ "• Apple Core99 ('Sawtooth') Uni-North Architecture: Replaced old ADB/serial ports with dual 400 Mbps IEEE-1394 "
		+ "FireWire busses, AGP 2x graphics, 100BASE-TX Ethernet, and an internal Airport 802.11b wireless card slot.\n"
		+ "• Darwin XNU Kernel (Mach 3.0 + FreeBSD 4.4): Combined Carnegie Mellon Mach IPC/threads with a POSIX FreeBSD userland "
		+ "and I/O Kit C++ device drivers.\n"
		+ "• Aqua GUI & Quartz 2D / Extreme: Native PDF display model with drop shadows, genie minimization, gel 'lickable' "
		+ "traffic-light buttons, and hardware OpenGL compositing."
	)
	p.cultural_legacy = (
		"Apple's television commercials showing the graphite Power Mac G4 surrounded by a perimeter of U.S. Army tanks "
		+ "('The first personal computer classified as a weapon') became marketing legend. The G4 tower + Mac OS X Jaguar "
		+ "combination laid the direct architectural foundation for every modern Mac, iPhone, and iPad."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Apple Computer, Inc. (Cupertino, CA)",
		"Release Date": "August 31, 1999 (Power Mac G4) • August 24, 2002 (Mac OS X 10.2)",
		"System Model": "Power Mac G4 ('Sawtooth' • PowerMac3,1 Graphite Tower)",
		"Processor (CPU)": "Motorola PowerPC 7400 (G4 • 32-bit RISC with AltiVec SIMD)",
		"Clock Rate & Cache": "450 MHz • 64 KB L1 + 1 MB Backside 2:1 SRAM L2 • 100 MHz Bus",
		"Co-Processor / DSP": "128-bit AltiVec 'Velocity Engine' Vector Unit (4+ GFLOPS)",
		"System Bus & Chipset": "Apple Uni-North ASIC (AGP 2x + 100MHz Memory) + KeyLargo I/O",
		"Memory (RAM)": "512 MB PC100 SDRAM (4 DIMM slots, expandable to 2 GB)",
		"Graphics / Video": "ATI Rage 128 Pro 16 MB SDRAM (AGP 2x • VGA & ADC/DVI-D)",
		"Audio Subsystem": "Apple Screamer 16-bit 44.1 kHz Stereo DMA + Internal Speaker",
		"Storage & Media": "27 GB Ultra ATA/66 7200 RPM + Hitachi DVD-ROM / Iomega Zip 100",
		"Operating System": "Mac OS X 10.2.8 ('Jaguar' • Darwin 6.8) + Classic Mac OS 9.2.2",
		"Kernel & Filesystem": "XNU Hybrid Kernel (Mach 3.0 + BSD) • HFS+ (Mac OS Extended)",
		"GUI / Window System": "Aqua • Quartz Extreme Compositor • Finder & Dock",
		"Default Shell": "TENEX C Shell (/bin/tcsh • switched to bash in 10.3)",
		"Original List Price": "$2,499 USD (450 MHz Configuration) • OS X 10.2: $129 USD",
		"Predecessor": "Power Macintosh G3 (Blue & White, Jan 1999) / Mac OS X 10.1",
		"Successor": "Power Mac G4 (Mirrored Drive Doors) & Power Mac G5 (2003)"
	}
	p.usage_cases = [
		{
			"title": "Madison Avenue Print Design, Prepress & QuarkXPress / Photoshop Studio",
			"role": "Senior Art Director & Digital Prepress Specialist (2002)",
			"software": "Adobe Photoshop 7.0 (Native Carbon), Illustrator 10, QuarkXPress 5.0 (Classic), Font Reserve",
			"scenario": "Working on an Apple Studio Display 17\" CRT in matching translucent graphite. The designer applies real-time AltiVec Gaussian Blur and Unsharp Mask filters to a 300 MB CMYK magazine cover in Photoshop 7.0 while QuarkXPress 5.0 runs seamlessly side-by-side inside the rootless 'Classic' Mac OS 9 compatibility layer."
		},
		{
			"title": "Non-Linear MiniDV Indie Film Editing via FireWire 400",
			"role": "Independent Documentary Filmmaker",
			"software": "Apple Final Cut Pro 3.0, QuickTime 6 Pro, iDVD 2, Peak DV",
			"scenario": "Connecting a Canon XL1 3CCD MiniDV camcorder directly to the G4's built-in 400 Mbps FireWire port. Final Cut Pro 3 controls the tape transport via FireWire timecode and renders real-time Velocity Engine dissolves without requiring a $10,000 Avid hardware card."
		},
		{
			"title": "UNIX Open-Source Development with Project Builder & Fink",
			"role": "NeXTSTEP / BSD Developer Migrating to Cocoa",
			"software": "Apple Project Builder, Interface Builder, Terminal.app (tcsh), Fink (apt-get), XDarwin",
			"scenario": "Dragging Cocoa NSButton outlets in Interface Builder while compiling open-source UNIX utilities via 'fink install' in a translucent Aqua Terminal window."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. 1999 Apple Power Mac G4 'Sawtooth' in Graphite & Silver with Studio Display",
		"Jony Ive's landmark polycarbonate tower with corner handles, fold-down side door, and silver Apple logo.",
		"Fig 2. Fold-Down Side Door Interior: PowerPC 7400 Heatsink, Uni-North & AGP Slot",
		"Ingenious cable-managed hinged door exposing the PowerPC G4 processor module, 4 PC100 RAM slots, and ATI Rage 128 Pro.",
		"Fig 3. Mac OS X 10.2 'Jaguar' Aqua Desktop with Pinstripes, Traffic-Light Buttons & Dock",
		"Iconic translucent pinstripes, red/yellow/green gel window controls, bottom magnifying Dock, and tcsh Terminal."
	)


static func _populate_sco_openserver(p: OSProfile) -> void:
	p.exhibit_subtitle = "The Workhorse Commercial x86 UNIX of 1990s Retail, Banking & Industry"
	p.era_classification = "Late-1990s Commercial SVR3.2 Multiuser Server Era (1999)"
	p.historical_overview = (
		"Long before the controversial SCO Group lawsuits of the 2000s, the **Santa Cruz Operation (SCO)**—founded in 1979 "
		+ "by Doug and Larry Michels in Santa Cruz, California—was the pioneer and market leader of UNIX on Intel x86 hardware. "
		+ "SCO OpenServer Release 5.0.5 (1999), running on a Compaq ProLiant 1600 Dual Pentium III server, was the invisible "
		+ "backbone of late-1990s commerce: it ran the point-of-sale and inventory back-offices of McDonald's, Walgreens, "
		+ "AutoZone, Pizza Hut, and thousands of regional bank branches."
	)
	p.historical_context = (
		"Evolving from Microsoft/SCO XENIX in the 1980s and AT&T UNIX System V Release 3.2 (SVR3.2), SCO OpenServer 5 was "
		+ "engineered specifically for extreme multiuser serial and telnet density on x86 servers. A single Compaq ProLiant "
		+ "equipped with DigiBoard multi-port RS-232 serial cards could drive 64 Wyse green-screen dumb terminals across a "
		+ "warehouse or retail store with rock-solid predictability, while providing the graphical **SCO PanoRama (IXI X.desktop)** "
		+ "Motif environment on the local server console."
	)
	p.engineering_innovations = (
		"• HTFS (High Throughput File System) & DTFS: Introduced in OpenServer 5, HTFS added transaction intent logging (journaling), "
		+ "versioned undelete checkpoints, and support for large filesystems alongside transparent LZ compression in DTFS.\n"
		+ "• SCOadmin & Custom Package Manager: Unified dual-mode administration suite that rendered identically in graphical "
		+ "OSF/Motif on X11 or in full-screen color CHARM (Character Motif) over an 80x25 serial terminal.\n"
		+ "• Compaq SMART-2DH Array & EISA/PCI Architecture: Hardware RAID-5 controller with battery-backed write cache "
		+ "reporting drive health directly into SCO's 'hwconfig' kernel driver table.\n"
		+ "• Binary Compatibility (iBCS2): Executed legacy 286/386 XENIX, COFF, and ELF SVR3/SVR4 commercial business binaries seamlessly."
	)
	p.cultural_legacy = (
		"SCO OpenServer 5.0.5 represents the classic era of commercial ' shrink-wrapped' x86 UNIX before Linux and FreeBSD "
		+ "captured the commodity server market. Because so many vertical-market COBOL, Informix, and Progress 4GL applications "
		+ "were certified exclusively on OpenServer 5.0.5, many of these systems remained in daily retail and manufacturing "
		+ "production well into the 2010s."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "The Santa Cruz Operation, Inc. (SCO) • Compaq Computer Corp.",
		"Release Date": "January 1999 (SCO OpenServer Release 5.0.5)",
		"System Model": "Compaq ProLiant 1600 Pedestal / Rack Server",
		"Processor (CPU)": "Dual Intel Pentium III 500 MHz (Katmai, Slot 1 + SCO SMP License)",
		"Clock Rate & Cache": "2x 500 MHz • 512 KB L2 Cache per CPU • 100 MHz Front Side Bus",
		"Co-Processor / DSP": "Dual Integrated x87 FPU",
		"System Bus & Chipset": "Intel 440BX • 5x 32-bit PCI + 4x EISA Bus Master Slots",
		"Memory (RAM)": "512 MB 100 MHz ECC Registered SDRAM",
		"Graphics / Video": "Cirrus Logic GD5446 Onboard SVGA (SCO Xgi X11R5 Server)",
		"Audio Subsystem": "PC Server Speaker + Sound Blaster 16 ISA",
		"Storage & Media": "3x 9.1 GB Compaq Wide-Ultra SCSI-3 Hot-Plug RAID-5 (SMART-2DH)",
		"Operating System": "SCO OpenServer Enterprise System Release 5.0.5",
		"Kernel & Filesystem": "AT&T UNIX SVR3.2 v5.0.5 (/unix) • HTFS (Journaled) & EAFS boot",
		"GUI / Window System": "SCO PanoRama Desktop (IXI X.desktop + OSF/Motif PMWM)",
		"Default Shell": "AT&T Bourne Shell (/bin/sh) & KornShell (/bin/ksh)",
		"Original List Price": "OS + 10-User Enterprise + SMP: $2,490 USD • Server: $4,600",
		"Predecessor": "SCO UNIX System V/386 Release 3.2v4.2 (Open Desktop 3.0)",
		"Successor": "SCO OpenServer 5.0.7 (2003) / UnixWare 7"
	}
	p.usage_cases = [
		{
			"title": "Auto Parts Chain Store Inventory, Point-of-Sale & DigiBoard Serial Hub",
			"role": "Regional Retail IT Field Engineer (1999)",
			"software": "SCOadmin, Informix-SE / 4GL, Wyse 60 Terminal Emulation, hwconfig, custom",
			"scenario": "Tucked under the back counter of an auto parts store, the Compaq ProLiant 1600 drives twelve counter barcode terminals and dot-matrix invoice printers over a 16-port DigiBoard serial concentrator. The field engineer logs into the local VGA console to check 'hwconfig' and run an overnight lone-tar tape backup to the Tandberg QIC/DAT drive."
		},
		{
			"title": "Y2K Remediation & COBOL / Progress 4GL Accounting Verification",
			"role": "Enterprise Y2K Compliance Consultant (Autumn 1999)",
			"software": "Micro Focus COBOL, Progress RDBMS v8, scoterm, sysadmsh, sar",
			"scenario": "Applying SCO Year-2000 supplements (OSS497B) via '/etc/custom' and validating two-digit-to-four-digit date rollovers in the company's general ledger before December 31, 1999."
		},
		{
			"title": "Branch Office UUCP & Dial-Up PPP Concentrator",
			"role": "Corporate Telecommunications Administrator",
			"software": "SCO Morning Star PPP, UUCP, Sendmail, SCO PanoRama Desktop",
			"scenario": "Polling nightly sales batches from 80 retail stores over USRobotics Courier V.Everything modems using automated UUCP cron scripts and monitoring line status in scoterm."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. Compaq ProLiant 1600 Tower with Hot-Plug Wide-Ultra SCSI Bays",
		"Compaq's iconic opal-beige server chassis featuring lockable hot-swap drive sleds and Compaq Insight Manager LEDs.",
		"Fig 2. Dual Pentium III Slot 1 Riser, PCI/EISA Backplane & Compaq SMART-2DH RAID",
		"Slide-out processor cage and battery-backed SCSI array controller engineered for 99.99% commercial uptime.",
		"Fig 3. SCO PanoRama Desktop (Motif PMWM) with SCOadmin & scoterm",
		"Classic steel-blue Motif bevels, SCOadmin System Administration folder, and root Bourne shell console."
	)


static func _populate_win98_se(p: OSProfile) -> void:
	p.exhibit_subtitle = "The Pinnacle of Classic 9x PC Computing on Pentium III & 3dfx Voodoo3"
	p.era_classification = "Late-1990s Consumer PC & 3D Accelerator Golden Age (May 1999)"
	p.historical_overview = (
		"Microsoft Windows 98 Second Edition (Version 4.10.2222 A), released on May 5, 1999, is universally celebrated as "
		+ "the definitive culmination of the MS-DOS-based Windows 9x lineage. Running here on a classic 1999 beige tower "
		+ "powered by an Intel Pentium III 500 MHz ('Katmai') processor, 128 MB of PC100 RAM, a 3dfx Voodoo3 3000 16 MB AGP "
		+ "graphics accelerator, and a Sound Blaster Live! PCI card, it represents the golden age of late-90s PC gaming, "
		+ "dial-up / early broadband Internet culture, and effortless real-mode DOS compatibility."
	)
	p.historical_context = (
		"Following the original June 1998 launch of Windows 98, Microsoft released Second Edition to resolve early USB and "
		+ "WDM driver bugs while introducing **Internet Connection Sharing (ICS)** (allowing a household to share a single "
		+ "56k modem or early cable/DSL connection over a 10BASE-T hub), DirectX 6.1, Windows Media Player 6.2, and improved "
		+ "IEEE-1394 FireWire and DVD-ROM support. Unlike its troubled successor Windows Me (2000), Windows 98 SE retained full "
		+ "'Restart in MS-DOS mode' support, making it the beloved standard for gamers from 1999 through 2003."
	)
	p.engineering_innovations = (
		"• Hybrid 16/32-Bit VMM32 + MS-DOS 7.10 Architecture: Combined preemptive 32-bit Win32 multitasking for modern applications "
		+ "with direct real-mode and V86-mode hardware access for legacy MS-DOS games.\n"
		+ "• Mature WDM (Windows Driver Model) & Plug-and-Play USB: Finally delivered reliable hot-plugging for USB mice, "
		+ "scanners, and Force Feedback joysticks without manual IRQ/DMA jumper gymnastics.\n"
		+ "• 3dfx Voodoo3 3000 AGP (Avenger ASIC): 166 MHz dual-TMU 2D/3D chip delivering native 60+ FPS in **3dfx Glide**, "
		+ "Direct3D, and OpenGL with zero external pass-through VGA cable required.\n"
		+ "• FAT32 File System & DriveSpace 3: Supported multi-gigabyte Ultra ATA hard drives with 4 KB cluster sizes."
	)
	p.cultural_legacy = (
		"From the classic `#008080` Teal desktop background and chiseled `#C0C0C0` 3D gray buttons to Ken Kato's shimmering "
		+ "startup chime, ICQ's 'Uh-oh!' message alert, Napster MP3 trading, and late-night matches of Unreal Tournament and "
		+ "Half-Life on 3dfx Glide, Windows 98 SE is the quintessential nostalgic centerpiece of 1990s personal computing."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Microsoft Corporation (Redmond, WA) • Custom Intel ATX PC",
		"Release Date": "May 5, 1999 (Build 4.10.2222 A)",
		"System Model": "Enlight EN-7237 Beige Mid-Tower ATX (ASUS P3B-F Motherboard)",
		"Processor (CPU)": "Intel Pentium III 500 MHz (Katmai, 250nm, Slot 1 SECC2)",
		"Clock Rate & Cache": "500 MHz • 32 KB L1 + 512 KB Half-Speed L2 Cache • 100 MHz FSB",
		"Co-Processor / DSP": "Integrated x87 FPU + MMX + 70 New SSE ('Katmai') Instructions",
		"System Bus & Chipset": "Intel 440BX AGPset + PIIX4E Southbridge (AGP 2x / PCI / ISA)",
		"Memory (RAM)": "128 MB Micron PC100 SDRAM (CAS 2)",
		"Graphics / Video": "3dfx Voodoo3 3000 16 MB SDRAM AGP 2x (166 MHz • Glide / D3D)",
		"Audio Subsystem": "Creative Sound Blaster Live! (EMU10K1 DSP + SoundFont Synth)",
		"Storage & Media": "13.6 GB IBM Deskstar 7200 RPM IDE + 40x Creative CD-ROM + 3.5\" FDD",
		"Operating System": "Microsoft Windows 98 Second Edition (4.10.2222 A)",
		"Kernel & Filesystem": "VMM32.VXD (16/32-bit Hybrid) over MS-DOS 7.10 • FAT32",
		"GUI / Window System": "Windows Explorer 4.72 • Classic Win32 3D Gray & Gradient Titlebars",
		"Default Shell": "MS-DOS Prompt (COMMAND.COM)",
		"Original List Price": "Windows 98 SE Retail Upgrade: $89 USD (Full OEM: $179) • PC: $1,599",
		"Predecessor": "Windows 98 First Edition (4.10.1998, June 1998) / Windows 95 OSR2",
		"Successor": "Windows Millennium Edition (Me, Sept 2000) & Windows XP (2001)"
	}
	p.usage_cases = [
		{
			"title": "3dfx Glide Gaming — Unreal Tournament, Half-Life & Quake III Arena",
			"role": "Late-90s PC Gamer & Clan Member (1999)",
			"software": "Unreal Tournament ('99), Half-Life: Opposing Force, GameSpy Arcade, ICQ 99b",
			"scenario": "Booting past the Award Modular BIOS and spinning Windows 98 splash screen into the teal desktop. The user closes ICQ 99b in the system tray to save RAM, launches Unreal Tournament in native 3dfx Glide API at 1024x768 16-bit color, and marvels at the spinning 3dfx splash logo and silky 60 FPS framerate."
		},
		{
			"title": "Dial-Up / Early Cable Internet, Winamp Skins & FrontPage Web Authoring",
			"role": "Home Webmaster & MP3 Collector",
			"software": "Internet Explorer 5.0, Winamp 2.24, mIRC 5.6, CuteFTP, Microsoft Plus! 98",
			"scenario": "Downloading custom Winamp skins and GeoCities HTML templates while chatting on EFnet in mIRC. Between downloads, the user switches desktop themes in Microsoft Plus! 98 between 'Mystery', 'Science', and 'More Windows'."
		},
		{
			"title": "Real-Mode MS-DOS 7.10 Gaming with Sound Blaster 16 Emulation",
			"role": "Retro DOS Game Enthusiast",
			"software": "MS-DOS 7.10 (AUTOEXEC.BAT / CONFIG.SYS), SB16 Emulation (SBEINIT.COM), DOOM II, Duke Nukem 3D",
			"scenario": "Selecting 'Shut Down -> Restart in MS-DOS mode' from the Start Menu. With 'SET BLASTER=A220 I5 D1 H5 P330' loaded automatically by the Sound Blaster Live! DOS driver, classic 1994 protected-mode DOS4GW games run at full speed with General MIDI wavetable music."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. Classic 1999 Enlight EN-7237 Beige ATX Mid-Tower & ViewSonic 17\" CRT",
		"The ubiquitous late-90s PC tower featuring 40x CD-ROM, 3.5-inch Sony floppy drive, and Altec Lansing ACS45 speakers.",
		"Fig 2. ASUS P3B-F Intel 440BX Motherboard, Slot 1 Pentium III & 3dfx Voodoo3 3000 AGP",
		"The legendary ASUS P3B-F board paired with the passive aluminum heatsink of the 3dfx Voodoo3 3000 AGP card.",
		"Fig 3. Windows 98 Second Edition '#008080' Teal Desktop, Start Menu & MS-DOS Prompt",
		"Chiseled #C0C0C0 gray bevels, navy-to-cerulean gradient active titlebars, My Computer icon column, and COMMAND.COM."
	)


static func _populate_os2_warp(p: OSProfile) -> void:
	p.exhibit_subtitle = "IBM's True 32-Bit Object-Oriented Desktop & Enterprise Banking OS"
	p.era_classification = "Mid-1990s 32-Bit Protected-Mode PC Operating System War (September 1996)"
	p.historical_overview = (
		"IBM OS/2 Warp 4 (Codename: 'Merlin'), released in September 1996, was the most ambitious desktop version of IBM's "
		+ "flagship 32-bit PC operating system. Born in 1987 as a joint venture between IBM and Microsoft before their bitter "
		+ "1991 split, OS/2 offered crash-proof preemptive multitasking, the High Performance File System (HPFS), the "
		+ "revolutionary object-oriented **Workplace Shell (WPS)**, and—new in Warp 4—built-in **VoiceType** continuous speech "
		+ "recognition and a native Java 1.02 runtime baked directly into the operating system."
	)
	p.historical_context = (
		"From 1994 to 1996, IBM waged a massive battle against Microsoft Windows 95 for the soul of the x86 desktop. "
		+ "Engineers and power users revered OS/2 Warp because a misbehaving DOS or Win16 application ran inside a hardware-isolated "
		+ "Virtual DOS Machine (VDM) and could never crash the system ('Crash Protection'). While Windows 95 won the consumer OEM "
		+ "pre-install war, OS/2 Warp 4 became an immovable titan in banking, finance, and transportation—powering over 70% of "
		+ "the world's automated teller machines (ATMs), French SNCF rail ticketing, and Wall Street settlement terminals for decades."
	)
	p.engineering_innovations = (
		"• Workplace Shell (WPS) & SOM (System Object Model): Every file, folder, printer, and system setting was a true "
		+ "CORBA-compliant SOM class instance supporting drag-and-drop manipulation, shadows, and persistent state.\n"
		+ "• Superior Virtual DOS Machines (VDMs) & Win-OS/2: famously ran DOS and Windows 3.1 applications faster and with "
		+ "more free conventional memory (over 620 KB) than native MS-DOS itself.\n"
		+ "• IBM WarpCenter (Top-Docked SmartCenter): Acquired from Lotus SmartSuite, providing one-click object trays, "
		+ "virtual desktop switching, real-time free RAM/CPU gauges, and lockup recovery.\n"
		+ "• Built-in IBM VoiceType Dictation: Allowed users to navigate windows and dictate text by voice out of the box in 1996."
	)
	p.cultural_legacy = (
		"OS/2 Warp 4's rich lavender-and-slate Workplace Shell, tabbed notebook property sheets, and deep orchestral synth "
		+ "startup swell represent a fascinating alternate history of the PC—showing what happened when IBM mainframe software "
		+ "disciplines were applied to the personal computer."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "International Business Machines Corp. (Armonk, NY / Boca Raton, FL)",
		"Release Date": "September 25, 1996 (Internal Revision 9.023 • FixPak XR_M015)",
		"System Model": "IBM PC 300PL (Type 6562) Commercial Desktop",
		"Processor (CPU)": "Intel Pentium Pro 200 MHz / Pentium MMX 200 MHz",
		"Clock Rate & Cache": "200 MHz • 256 KB Integrated On-Package Full-Speed L2 Cache",
		"Co-Processor / DSP": "Out-of-Order P6 x87 FPU + IBM Mwave DSP (Audio/Modem/Speech)",
		"System Bus & Chipset": "Intel 440FX ('Natoma') PCIset • 32-bit PCI + ISA Shared Slots",
		"Memory (RAM)": "64 MB 60ns EDO DRAM",
		"Graphics / Video": "Matrox Millennium II 4 MB WRAM PCI (OS/2 GRADD 32-bit Driver)",
		"Audio Subsystem": "Crystal CS4236B / Sound Blaster 16 (MMPM/2 + VoiceType Mic)",
		"Storage & Media": "4.3 GB IBM Ultrastar Wide SCSI-2 + 12x CD-ROM + 3.5\" 1.44MB FDD",
		"Operating System": "IBM OS/2 Warp 4 (Version 4.00 • Codename 'Merlin')",
		"Kernel & Filesystem": "OS2KRNL 32-Bit Protected-Mode Preemptive • HPFS (High Perf FS)",
		"GUI / Window System": "Presentation Manager (PMSHELL.EXE) • Workplace Shell + WarpCenter",
		"Default Shell": "OS/2 Command Processor (CMD.EXE) with REXX Scripting",
		"Original List Price": "OS/2 Warp 4 Boxed: $249 USD (Upgrade: $149) • IBM 300PL: $2,150",
		"Predecessor": "OS/2 Warp 3 ('Red Spine' / 'Blue Spine' Connect, 1994–1995)",
		"Successor": "OS/2 Warp Server for e-business (1999) / ArcaOS"
	}
	p.usage_cases = [
		{
			"title": "Enterprise Banking Branch Server, SNA Mainframe Gateway & ATM Controller",
			"role": "Senior Financial Systems Specialist at a Global Retail Bank (1997)",
			"software": "IBM Communications Manager/2 (3270 SNA), DB2/2, REXX, OS/2 WarpCenter",
			"scenario": "Running 24/7 inside a bank branch vault room. The IBM PC 300PL maintains persistent SNA Token-Ring sessions to an IBM S/390 mainframe while servicing four Diebold ATMs and twelve teller workstations via DB2/2 stored procedures written in Object REXX."
		},
		{
			"title": "Multitasking Power-User Desktop — Lotus SmartSuite, Java & DOS Games",
			"role": "Corporate Software Engineer & OS/2 TeamOS/2 Advocate",
			"software": "Lotus Word Pro 96 for OS/2, Mesa 2, Netscape 2.02 for OS/2, Win-OS/2, DOOM",
			"scenario": "Formatting a high-density floppy disk in the background while compiling C++ code in IBM VisualAge, dictating a memo via VoiceType microphone, and running DOOM inside a resizable desktop window—all without a single hiccup in mouse cursor responsiveness."
		},
		{
			"title": "System Configuration & REXX Automation via Tabbed Settings Notebooks",
			"role": "Enterprise Desktop Administrator",
			"software": "System Setup Folder, CONFIG.SYS, EPM (Enhanced Editor), PSTAT, CHKDSK",
			"scenario": "Right-clicking desktop objects to open OS/2's signature spiral-bound 'Settings Notebooks', dragging a font palette swatch directly onto an OS/2 Window titlebar to restyle it live, and automating network logons with a 20-line REXX script."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. IBM PC 300PL Horizontal Desktop Chassis with IBM P70 Trinitron Monitor",
		"Classic IBM Pearl-White commercial desktop with mechanical buckling-spring/dome keyboard and VoiceType headset.",
		"Fig 2. Intel 440FX Board, Pentium Pro 200MHz Ceramic Dual-Cavity Chip & Matrox WRAM",
		"The gold-capped ceramic Pentium Pro package containing both CPU and 256KB L2 cache dies side-by-side.",
		"Fig 3. OS/2 Warp 4 Workplace Shell with Top-Docked WarpCenter & OS/2 Window",
		"Signature #3A4B6E slate-violet desktop, #634F7D royal purple titlebars, desktop folder objects, and top WarpCenter bar."
	)


static func _populate_mac_sys75(p: OSProfile) -> void:
	p.exhibit_subtitle = "The Ultimate 68040 Macintosh with AT&T DSP Audio/Video & System 7.5.3"
	p.era_classification = "Mid-1990s Classic 68k Macintosh & Desktop Publishing Era (1993–1995)"
	p.historical_overview = (
		"The Apple Macintosh Quadra 840AV, running Macintosh System 7.5.3, stands as the fastest and most technologically "
		+ "audacious Motorola 68000-series Macintosh ever engineered. Clocked at 40 MHz on a Motorola 68040 processor and "
		+ "augmented by a dedicated 66.7 MHz **AT&T DSP3210 Digital Signal Processor**, the 'Cyclone' Quadra 840AV brought "
		+ "real-time NTSC/PAL video capture, 16-bit 48 kHz CD-quality stereo audio, Plaintalk speech recognition, and telecom "
		+ "answering-machine capabilities to the desktop in 1993–1995."
	)
	p.historical_context = (
		"Just before Apple transitioned to the PowerPC architecture in 1994, the Advanced Technology Group (ATG) created "
		+ "the AV Macintosh line (Centris 660AV and Quadra 840AV). Meanwhile, System 7.5.3 (Unified Release) represents the "
		+ "zenith of Classic 68k Mac OS—combining QuickDraw GX typography, the collapsible bottom-left Control Strip, WindowShade "
		+ "(double-clicking a pinstriped titlebar to roll up the window with a 'whoosh' sound), AppleGuide interactive coaching, "
		+ "and OpenTransport TCP/IP networking."
	)
	p.engineering_innovations = (
		"• Dual-Processor MC68040 @ 40 MHz + AT&T DSP3210 @ 66.7 MHz: While the 68040 ran the Finder and QuickDraw, the "
		+ "32-bit floating-point AT&T DSP handled real-time audio mixing, GeoPort V.32bis modem modulation in software, and video frame grabbing.\n"
		+ "• Apple MUNI (Macintosh Universal NuBus Interface) & PSC: A dedicated 8-channel Peripheral Subsystem Controller (PSC) "
		+ "performed DMA transfers for SCSI, Ethernet, Sound, and DSP without interrupting the 68040 CPU.\n"
		+ "• Live Video-In & Video-Out Compositing: Two independent framebuffers allowed live S-Video television/VCR feeds to "
		+ "play at 30 FPS inside a draggable Macintosh Finder window.\n"
		+ "• System 7.5.3 MultiFinder & Extension Manager: Cooperative multitasking with the iconic 'Happy Mac' startup icon "
		+ "and the horizontal parade of Startup Extension icons across the bottom of the screen."
	)
	p.cultural_legacy = (
		"To graphic designers, musicians, and 68k assembly programmers, the Quadra 840AV is the 'Holy Grail' of classic "
		+ "Macintoshes. Its harmonious C-major Quadra startup chime, Chicago 12pt bitmap menu font, and platinum pinstriped "
		+ "window chrome define the golden age of Apple's pre-Jobs-return industrial and interface design."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Apple Computer, Inc. (Cupertino, CA)",
		"Release Date": "July 1993 (Quadra 840AV) • May 1996 (System 7.5.3 Revision 2)",
		"System Model": "Macintosh Quadra 840AV (Codename: 'Cyclone' • M9020 Tower)",
		"Processor (CPU)": "Motorola MC68040 (32-bit CISC with Integrated FPU & MMU)",
		"Clock Rate & Cache": "40 MHz • 8 KB On-Die L1 Cache (4 KB Instruction + 4 KB Data)",
		"Co-Processor / DSP": "AT&T DSP3210 Digital Signal Processor @ 66.7 MHz (33 MFLOPS)",
		"System Bus & Chipset": "40 MHz System Bus • Apple PSC (8-ch DMA) • 3x NuBus 90 Slots",
		"Memory (RAM)": "64 MB 60ns 72-pin SIMMs (Expandable to 128 MB)",
		"Graphics / Video": "2 MB VRAM Onboard CIVIC II (24-bit 832x624 + Live NTSC/PAL I/O)",
		"Audio Subsystem": "Apple Singer2 Codec (16-bit 48 kHz Stereo via DSP3210 + PlainTalk)",
		"Storage & Media": "1.0 GB Quantum Empire SCSI-2 HD + Sony 2x Caddy CD-ROM + SuperDrive",
		"Operating System": "Macintosh System 7.5.3 (System 7.5 Version 7.5.3 Rev 2)",
		"Kernel & Filesystem": "Classic Mac Toolbox ROM ($067C 2MB) + System File • HFS Standard",
		"GUI / Window System": "Macintosh Finder 7.5.5 • QuickDraw • Platinum Pinstripe Chrome",
		"Default Shell": "MPW (Macintosh Programmer's Workshop 3.4) Worksheet",
		"Original List Price": "$4,699 USD (1993 Base Tower with 16MB RAM / 500MB HD)",
		"Predecessor": "Macintosh Quadra 800 (Feb 1993) / Macintosh IIfx",
		"Successor": "Power Macintosh 8100/80AV (PowerPC 601, March 1994)"
	}
	p.usage_cases = [
		{
			"title": "Desktop Publishing, Aldus PageMaker & Scitex Drum Scanner Prepress",
			"role": "Magazine Layout Artist & Typography Specialist (1995)",
			"software": "Aldus PageMaker 5.0, Adobe Photoshop 3.0.5, Adobe Type Manager (ATM), ResEdit",
			"scenario": "Laying out a 64-page glossy publication with PostScript Type 1 fonts smoothed by ATM. The artist captures reference stills directly from a Sony Hi8 camcorder plugged into the Quadra 840AV's S-Video input port using the Apple Video Player desk accessory."
		},
		{
			"title": "Pro Tools III NuBus Digital Audio & MIDI Sequencing Studio",
			"role": "Recording Studio Engineer & Film Composer",
			"software": "Opcode Studio Vision Pro, Digidesign Sound Designer II, Apple PlainTalk",
			"scenario": "Driving external MIDI synthesizers while recording 16-bit 48 kHz stereo masters through the Quadra's onboard AT&T DSP3210 and NuBus Digidesign DSP Farm cards."
		},
		{
			"title": "68040 Macintosh Toolbox Development in MPW & ResEdit",
			"role": "Classic Mac OS Shareware Author",
			"software": "MPW Shell 3.4 (Worksheet), ResEdit 2.1.3, MacsBug 6.5.2, Greg's Buttons",
			"scenario": "Editing 'WIND', 'MENU', and 'cicn' resource forks visually in ResEdit 2.1.3, highlighting a build command in the MPW Worksheet window and pressing Command-Return to compile a native 68k Control Panel (CDEV)."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. Apple Macintosh Quadra 840AV Mini-Tower with AudioVision 14\" Display",
		"Sculpted platinum tower featuring the 2x CD-ROM caddy slot, Apple AudioVision monitor with integrated stereo speakers/mic.",
		"Fig 2. Quadra 840AV Logic Board: Motorola MC68040 @ 40MHz & AT&T DSP3210",
		"High-density surface-mount board with gold-capped 40MHz 68040, 66.7MHz AT&T DSP3210, S-Video DAV slot, and 3 NuBus slots.",
		"Fig 3. Macintosh System 7.5.3 Finder with Pinstriped Titlebars, Apple Menu & Control Strip",
		"Classic lilac-periwinkle desktop pattern, horizontal titlebar pinstripes with left close box, and bottom-left Control Strip."
	)


static func _populate_nextstep_33(p: OSProfile) -> void:
	p.exhibit_subtitle = "Steve Jobs' Object-Oriented UNIX Workstation That Birthed the World Wide Web"
	p.era_classification = "Early-to-Mid 1990s Object-Oriented UNIX & Web Genesis Era (1995)"
	p.historical_overview = (
		"Created by **NeXT Computer, Inc.** after Steve Jobs' 1985 departure from Apple, the **NeXTstation Turbo Color** "
		+ "running **NeXTSTEP Release 3.3** (1995) is one of the most consequential computer systems in human history. "
		+ "On a NeXT machine running NeXTSTEP at CERN in 1990, Sir Tim Berners-Lee invented the World Wide Web, writing the "
		+ "very first web browser (`WorldWideWeb.app`) and the first HTTP server in just weeks thanks to NeXTSTEP's revolutionary "
		+ "Objective-C **Application Kit** and **Interface Builder**."
	)
	p.historical_context = (
		"Housed in Frog Design's sleek matte-black magnesium 'Pizza Box' slab alongside the 17-inch Sony Trinitron MegaPixel "
		+ "Color Display, the NeXTstation Turbo Color combined a 33 MHz Motorola 68040 with a 25 MHz Motorola DSP56001 digital "
		+ "signal processor. In December 1996, Apple acquired NeXT for $429 million—bringing Steve Jobs back to Cupertino and "
		+ "transforming NeXTSTEP 3.3 directly into **Mac OS X**, **iOS**, and the modern `NS*` (NeXTSTEP) Cocoa APIs used by "
		+ "millions of developers today."
	)
	p.engineering_innovations = (
		"• Display PostScript (DPS) Unified Imaging Model: Co-developed with Adobe, every pixel drawn on screen—from window "
		+ "scrollbars to rotated typography—used the exact same PostScript interpreter that drove high-resolution laser printers.\n"
		+ "• Objective-C, AppKit & Interface Builder: Allowed developers to graphically wire UI controls ('Outlets' and 'Actions') "
		+ "to Objective-C objects and save live serialized object graphs as `.nib` (NeXT Interface Builder) files.\n"
		+ "• Mach 2.5 Kernel + 4.3BSD UNIX + NetInfo: Pioneered loadable kernel servers, hierarchical network directory management, "
		+ "and fat multi-architecture binaries (m68k, i386, SPARC, PA-RISC in a single executable!).\n"
		+ "• Workspace Manager, Shelf & Vertical Application Dock: Introduced the persistent right-side application dock, "
		+ "the multi-column Miller Browser file viewer, and the Tear-Off black vertical menus."
	)
	p.cultural_legacy = (
		"Beyond birthing the World Wide Web at CERN, John Carmack and id Software famously developed *DOOM* and *Quake* on "
		+ "a NeXTstation Turbo Color using NeXTSTEP 3.3's Objective-C tools (`DoomEd` and `QuakeEd`). Every time a modern macOS "
		+ "or iOS programmer writes `NSString`, `NSObject`, or `NSView`, they are writing NeXTSTEP code."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "NeXT Computer, Inc. (Redwood City, CA)",
		"Release Date": "February 1995 (NeXTSTEP 3.3) • 1992 (NeXTstation Turbo Color)",
		"System Model": "NeXTstation Turbo Color ('Pizza Box' Magnesium Slab • N1200)",
		"Processor (CPU)": "Motorola MC68040 (32-bit CISC with Integrated IEEE-754 FPU)",
		"Clock Rate & Cache": "33 MHz Turbo • 8 KB On-Die L1 Cache",
		"Co-Processor / DSP": "Motorola DSP56001 @ 25 MHz (24-bit Digital Signal Processor)",
		"System Bus & Chipset": "NeXT Custom Turbo DMA Channel Controller + 25 MHz System Bus",
		"Memory (RAM)": "128 MB 72-pin Parity SIMMs (Maximum Turbo Configuration)",
		"Graphics / Video": "1.5 MB VRAM Onboard 16-bit 4096-Color PostScript (1120x832 @ 68Hz)",
		"Audio Subsystem": "DSP56001 16-bit 44.1 kHz Stereo DAC + SoundBox Speaker/Mic in CRT",
		"Storage & Media": "1.05 GB Quantum SCSI-2 Internal HD + 2.88 MB Sony Floppy Drive",
		"Operating System": "NeXTSTEP Release 3.3 (Mach 2.5 / 4.3BSD UNIX)",
		"Kernel & Filesystem": "Carnegie Mellon Mach 2.5 + BSD • 4.3BSD UFS with Long Filenames",
		"GUI / Window System": "Display PostScript • NeXT Workspace Manager • Tear-Off Menus & Dock",
		"Default Shell": "Berkeley C Shell (/bin/csh) inside Terminal.app",
		"Original List Price": "$7,995 USD (NeXTstation Turbo Color) • NeXTSTEP 3.3 OS: $795",
		"Predecessor": "NeXTcube (68030 + Magneto-Optical Drive, 1988) / NeXTSTEP 3.2",
		"Successor": "OPENSTEP 4.2 (1997) → Apple Rhapsody → Mac OS X 10.0 (2001)"
	}
	p.usage_cases = [
		{
			"title": "Rapid Objective-C GUI Prototyping in Interface Builder & Project Builder",
			"role": "Lead Object-Oriented Software Architect (1995)",
			"software": "Project Builder, Interface Builder, Workspace Manager, Digital Librarian, Yap",
			"scenario": "Control-dragging a connection line from a 'Slider' control to a custom 'PostScriptView' object inside Interface Builder, clicking 'Test Interface' to try it live without compiling, and searching full-text indexed UNIX manuals and Shakespeare plays in 'Digital Librarian'."
		},
		{
			"title": "3D Game Level Design & BSP Map Compilation (id Software Workflow)",
			"role": "3D Game Engine Programmer & Level Designer",
			"software": "DoomEd / QuakeEd (Objective-C), Terminal.app, gdb, Display PostScript",
			"scenario": "Drawing convex 3D sector polygons and assigning texture flats inside a custom Objective-C level editor on the crisp 1120x832 MegaPixel Color Display while compiling BSP trees in a background Mach thread."
		},
		{
			"title": "Multimedia Electronic Mail (NeXTMail) with Inline Voice & PostScript",
			"role": "University Department Chair & Academic Researcher",
			"software": "Mail.app (NeXTMail), Preview.app, Edit.app, Grab.app",
			"scenario": "Composing a rich multimedia email in NeXTMail—long before HTML email existed—by dragging a high-resolution PostScript diagram onto the page and recording a spoken voice annotation via the MegaPixel monitor's built-in microphone."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. NeXTstation Turbo Color Magnesium 'Pizza Box' & 17\" MegaPixel Color Display",
		"Matte-black die-cast magnesium slab, rainbow NeXT cube logo by Paul Rand, and cantilevered 1120x832 Trinitron monitor.",
		"Fig 2. NeXTstation Turbo Logic Board: MC68040 @ 33MHz, Motorola DSP56001 & Turbo ASIC",
		"Automated robotic factory PCB from Fremont, California featuring the 68040, 24-bit DSP56001, and 128MB SIMM banks.",
		"Fig 3. NeXTSTEP 3.3 Workspace Manager with Black Titlebars, Vertical Dock & File Viewer",
		"Architectural #555555 neutral gray background, pitch-black active titlebars, 4-level gray bevels, and right-side Dock."
	)


static func _populate_amiga_os31(p: OSProfile) -> void:
	p.exhibit_subtitle = "Commodore's Preemptive Multimedia Legend with Dedicated Custom Co-Processors"
	p.era_classification = "Early-1990s Custom-Chipset Multimedia & Demoscene Era (1990–1994)"
	p.historical_overview = (
		"The **Commodore Amiga 3000** running **AmigaOS 3.1 (Kickstart 40.68 / Workbench 40.42)** represents the high-end "
		+ "workstation pinnacle of Jay Miner's visionary Amiga architecture. While contemporary 1990–1993 PCs struggled with "
		+ "single-tasking MS-DOS and PC speaker beeps, the Amiga 3000 combined a 25 MHz 32-bit Motorola 68030 CPU, a 68882 "
		+ "floating-point unit, a built-in 'Amber' flicker-fixer scan-doubler, Ultra-fast 32-bit Zorro III expansion slots, and "
		+ "the legendary custom co-processor chipset (**Agnus, Denise, and Paula**) executing preemptive multitasking in just "
		+ "256 KB of RAM."
	)
	p.historical_context = (
		"Introduced by Commodore Business Machines in June 1990 and upgraded to AmigaOS 3.1 in 1993–1994, the Amiga 3000 was "
		+ "the machine that democratized broadcast television production and 3D computer animation. Equipped with NewTek's "
		+ "**Video Toaster**, Amiga 3000s produced the CGI visual effects for *Babylon 5*, *seaQuest DSV*, and local TV news "
		+ "stations across the globe, while fueling the European demoscene and tracker music revolution."
	)
	p.engineering_innovations = (
		"• Custom DMA Co-Processor Chipset (Agnus / Denise / Paula): 'Agnus' housed the Copper (a beam-synchronized display "
		+ "co-processor capable of changing color palettes mid-scanline) and the Blitter; 'Paula' delivered 4-channel 8-bit "
		+ "DMA stereo sample playback with near-zero CPU overhead.\n"
		+ "• Exec Microkernel & Autoconfig (Zorro III): Carl Sassenrath's 'Exec' provided real-time preemptive multitasking via "
		+ "zero-copy message passing in a 512 KB ROM, while Zorro III cards auto-configured memory addresses without dip switches.\n"
		+ "• Amber Deinterlacer ASIC ('Flicker Fixer'): Buffered interlaced 15 kHz NTSC/PAL broadcast video fields in dual-port "
		+ "VRAM and output rock-steady 31 kHz non-interlaced VGA to a Commodore 1950 multiscan monitor.\n"
		+ "• ARexx System-Wide Scripting & Datatypes: Allowed every Amiga application to expose an IPC command port and load "
		+ "any file format transparently via object-oriented Datatype descriptors."
	)
	p.cultural_legacy = (
		"AmigaOS 3.1's steel-gray, blue, and white 3D gadtools bevels, Topaz 8pt font, and pull-down screen titlebars (which "
		+ "could be dragged vertically down the monitor like a window shade to reveal another resolution behind them!) remain "
		+ "unmatched in responsiveness and creative charm."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Commodore Business Machines, Inc. (West Chester, PA)",
		"Release Date": "June 1990 (Amiga 3000 Hardware) • 1994 (AmigaOS 3.1 ROM 40.68)",
		"System Model": "Commodore Amiga 3000 (A3000/25 Low-Profile Workstation)",
		"Processor (CPU)": "Motorola MC68030 (32-bit CISC with Integrated Instruction/Data MMU)",
		"Clock Rate & Cache": "25 MHz • 256-Byte I-Cache + 256-Byte D-Cache (Burst Mode)",
		"Co-Processor / DSP": "Motorola MC68882 FPU @ 25 MHz + ECS Chipset (Agnus/Denise/Paula)",
		"System Bus & Chipset": "32-bit Zorro III Bus + Video Slot • Ramsey + Super DMAC + Amber",
		"Memory (RAM)": "2 MB 32-bit Chip RAM (DMA) + 16 MB 32-bit ZIP Fast RAM (18 MB Total)",
		"Graphics / Video": "ECS Super Denise (8373) + Amber 31kHz Flicker-Fixer (HAM-6 4096 Colors)",
		"Audio Subsystem": "MOS 8364 'Paula' 4-Channel 8-Bit DMA Stereo PCM (28 kHz + Low-Pass)",
		"Storage & Media": "105 MB Quantum ProDrive LPS SCSI-2 (WD33C93A) + 880 KB Chinon DF0:",
		"Operating System": "AmigaOS 3.1 (Kickstart ROM 40.68 / Workbench 40.42)",
		"Kernel & Filesystem": "Exec Preemptive Multitasking Microkernel • Amiga FastFileSystem (FFS)",
		"GUI / Window System": "Intuition + GadTools 3D • Workbench 3.1 + Draggable Screen Bars",
		"Default Shell": "AmigaShell / AmigaDOS CLI (1.Workbench3.1:>)",
		"Original List Price": "$3,299 USD (25MHz Model with Commodore 1950 Multiscan Monitor)",
		"Predecessor": "Commodore Amiga 2000 (1987) / Workbench 1.3 & 2.04",
		"Successor": "Commodore Amiga 4000 (68040 + AGA, Oct 1992)"
	}
	p.usage_cases = [
		{
			"title": "Broadcast 3D CGI Raytracing & Video Toaster Production",
			"role": "3D Broadcast Animator & Video Editor (1993)",
			"software": "NewTek LightWave 3D 3.5, Video Toaster, Deluxe Paint IV AGA, AmigaShell",
			"scenario": "Modeling a metallic starship in LightWave 3D Modeler and rendering raytraced frames to HAM-6 / 24-bit IFF files while the 68882 FPU crunches reflections. Using the Amiga's draggable screens, the artist pulls the LightWave screen halfway down the monitor to check Deluxe Paint IV running simultaneously behind it."
		},
		{
			"title": "4-Channel MOD Tracker Music Composition & Demoscene Coding",
			"role": "Demoscene Musician & 680x0 Assembly Coder",
			"software": "ProTracker 3.15, Asm-One 680x0 Macro Assembler, Directory Opus 4",
			"scenario": "Sequencing 4-channel 8-bit IFF-8SVX drum and bassline samples in ProTracker while Paula's hardware DMA channels play the track with zero jitter. In another screen, Directory Opus 4 manages LhA archives downloaded from an Amiga BBS."
		},
		{
			"title": "Cross-Application Workflow Automation with ARexx & MultiView",
			"role": "Amiga Desktop Power User",
			"software": "ARexx (RX), MultiView, Shell, S:Startup-Sequence, Guru Meditation Handler",
			"scenario": "Writing an ARexx script that commands ImageFX to batch-process a directory of IFF ILBM pictures and sends IPC messages straight into PageStream DTP to place them onto a layout page automatically."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. Commodore Amiga 3000 Sculpted Desktop Unit & 1950 Multiscan Monitor",
		"Clean off-white horizontal workstation with flush Chinon 3.5\" floppy bay, embossed Commodore badge, and 2-button tank mouse.",
		"Fig 2. Amiga 3000 Motherboard: MC68030/68882 @ 25MHz, Zorro III Daughterboard & Paula/Agnus",
		"Custom VLSI silicon including 2MB Agnus, Super Denise, 8364 Paula audio chip, Amber deinterlacer, and WD33C93A SCSI.",
		"Fig 3. AmigaOS 3.1 Workbench with 3D GadTools Windows, Topaz Font & AmigaShell",
		"Signature #959595 gray backdrop, #5B83AC steel-blue active window frames, Ram Disk / Workbench drawer icons, and CLI."
	)


static func _populate_apple_iie(p: OSProfile) -> void:
	p.exhibit_subtitle = "The Definitive 8-Bit 65C02 Personal Computer with 80-Column P31 Green Phosphor"
	p.era_classification = "Mid-1980s 8-Bit Home, Classroom & Small Business Era (March 1985)"
	p.historical_overview = (
		"The **Apple IIe Enhanced**, introduced in March 1985 as an upgrade to the 1983 Apple //e, is the longest-lived and "
		+ "most iconic machine in the entire Apple II family created by Steve Wozniak. Powered by the CMOS **WDC/MOS 65C02** "
		+ "microprocessor running at 1.023 MHz, 128 KB of bank-switched RAM (via the Auxiliary Slot Extended 80-Column Text Card), "
		+ "twin 5.25-inch Disk II drives (driven by Wozniak's legendary 8-chip state-machine controller in Slot 6), and an "
		+ "Apple Monitor // P31 green phosphor CRT, it defined computer literacy for an entire generation."
	)
	p.historical_context = (
		"By 1985, the original 1977 Apple II architecture had evolved to support lowercase letters, crisp 80x24 text, "
		+ "'Double Hi-Res' 560x192 graphics, and the hierarchical **ProDOS 8** operating system (replacing the 1978 flat-catalog "
		+ "DOS 3.3). The 1985 'Enhanced' upgrade swapped four chips on the motherboard: replacing the NMOS 6502 with the CMOS "
		+ "65C02 (adding 27 new opcodes), updating the Monitor and Applesoft BASIC ROMs, and adding the **MouseText** graphical "
		+ "character set that allowed character-mode programs like *AppleWorks* to draw window borders, folders, and scrollbars!"
	)
	p.engineering_innovations = (
		"• Steve Wozniak's Disk II Controller Card (Slot 6): Eliminated expensive hardware head-zero optical sensors and "
		+ "western digital LSI controllers by using a 256-byte PROM state machine and Group Coded Recording (GCR). To find "
		+ "Track 0 at boot, the stepper motor intentionally stepped outward 40 times—producing the unforgettable machine-gun "
		+ "'BRRRRR-CLACK!' against the physical stop.\n"
		+ "• Seven Open Peripheral Expansion Slots + Auxiliary Slot: Exposed the entire 65C02 address and data bus directly "
		+ "to add-in cards (Super Serial Card in Slot 2, 80-Column/64KB RAM in Aux, Mouse Card in Slot 4, Disk II in Slot 6).\n"
		+ "• ProDOS 8 (Professional Disk Operating System): Introduced hierarchical subdirectories, SOS-compatible MLI "
		+ "(Machine Language Interface) system calls, and an automatic `/RAM` 64 KB RAM disk in auxiliary memory.\n"
		+ "• Built-in Applesoft BASIC & $FF69 System Monitor (`CALL -151`): Instant-on ROM programming environment."
	)
	p.cultural_legacy = (
		"With over six million Apple II systems sold before production finally ended in November 1993, the Apple //e Enhanced "
		+ "remains an immortal monument to open, hackable 8-bit hardware engineering—where flipping open the top lid revealed "
		+ "every socketed IC and schematics were printed right in the owner's manual."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Apple Computer, Inc. (Cupertino, CA)",
		"Release Date": "March 1985 (Apple //e Enhanced • Original //e launched Jan 1983)",
		"System Model": "Apple IIe Enhanced (A2S2064 • Sloped Beige Keyboard Chassis)",
		"Processor (CPU)": "WDC / MOS 65C02 (8-Bit CMOS Microprocessor)",
		"Clock Rate & Cache": "1.023 MHz (14.31818 MHz Master Crystal ÷ 14) • Zero Wait-State RAM",
		"Co-Processor / DSP": "Apple IOU & MMU Custom ASICs (Optional Z80 SoftCard / Mockingboard)",
		"System Bus & Chipset": "1 MHz 6502 Bus • 7x 50-pin Peripheral Slots + 1x 60-pin Aux Slot",
		"Memory (RAM)": "128 KB Total (64 KB Motherboard + 64 KB Extended 80-Column Card)",
		"Graphics / Video": "40/80-Col Text (MouseText) • Lo-Res (40x48) • Double Hi-Res (560x192)",
		"Audio Subsystem": "1-Bit Toggle Piezo/Cone Speaker ($C030 Soft-Switch)",
		"Storage & Media": "Dual 5.25\" Apple Disk II / DuoDisk (140 KB per side GCR) in Slot 6",
		"Operating System": "Apple ProDOS 8 v1.9 + ROM Applesoft Floating-Point BASIC",
		"Kernel & Filesystem": "ProDOS MLI (Machine Language Interface) • ProDOS SOS Hierarchical FS",
		"GUI / Window System": "80x24 P31 Green Phosphor Text + MouseText UI (AppleWorks / II Desktop)",
		"Default Shell": "Applesoft BASIC Interpreter (`]` Prompt) & System Monitor (`*`)",
		"Original List Price": "$1,395 USD (System with DuoDisk, Extended 80-Col Card & Monitor //)",
		"Predecessor": "Apple II Plus (1979) / Original Apple //e (1983)",
		"Successor": "Apple IIGS (16-bit 65C816, Sept 1986) & Apple IIe Platinum (1987)"
	}
	p.usage_cases = [
		{
			"title": "Integrated Office Productivity in AppleWorks 1.3 (Word Processor, DB & Spreadsheet)",
			"role": "Small Business Owner & High School Journalism Teacher (1985)",
			"software": "AppleWorks 1.3 (Rupert Lissner), ProDOS 8, ImageWriter II Dot-Matrix Printer",
			"scenario": "Flipping the rear rocker switch on: 'BEEP!' followed by the loud 'BRRRRR-CLACK!' of Slot 6 Drive 1 homing to Track 00. AppleWorks loads its classic file-folder card interface using 80-column MouseText characters, storing documents in the instant 64 KB `/RAM` drive before printing to a noisy ImageWriter II."
		},
		{
			"title": "Classroom Educational Computing — The Oregon Trail, Logo & Print Shop",
			"role": "Elementary & Middle School Computer Lab Student",
			"software": "The Oregon Trail (MECC), Broderbund The Print Shop, Terrapin Logo, Where in the World is Carmen Sandiego?",
			"scenario": "Inserting a 5.25-inch floppy with a notched write-enable sleeve into Drive 1 and closing the lever. The green P31 phosphor glow illuminates the computer lab as students ford rivers on the Oregon Trail and print dot-matrix birthday banners."
		},
		{
			"title": "Applesoft BASIC & 65C02 Machine Language Hacking via CALL -151",
			"role": "Bedroom Hobbyist Programmer & Nibble Magazine Reader",
			"software": "Applesoft BASIC (]), Apple System Monitor (CALL -151), Merlin 8/16 Assembler",
			"scenario": "Typing 'HGR' and 'HCOLOR=3' to plot vector shapes in 280x192 high-resolution graphics, then dropping into Wozniak's hexadecimal System Monitor with 'CALL -151' to inspect memory locations and toggle the speaker at '$C030'."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. Apple //e Enhanced Sloped Chassis with DuoDisk & Apple Monitor // (Green CRT)",
		"Iconic beige unit with integrated mechanical keyboard, tilting 12-inch Monitor // on top, and dual 5.25\" Disk II drives.",
		"Fig 2. Apple //e Motherboard: WDC 65C02, 7 Expansion Slots, Aux 80-Col Card & Slot 6 Disk II",
		"Fully socketed logic board showcasing Wozniak's 8-chip Disk II controller in Slot 6 and the Extended 80-Column RAM card.",
		"Fig 3. P31 Monochrome Green Phosphor Screen: ProDOS 8 Catalog, MouseText & Applesoft `]`",
		"Luminous #33FF55 P31 phosphor text displaying ProDOS volume directory `/USERS.DISK` and Applesoft BASIC listings."
	)


# ==============================================================================
# 9. DATAPOINT 2200 - DATAPOINT DOS 2.1 (1972)
# GENESIS OF THE WORKSTATION & DIRECT ANCESTOR OF INTEL 8008 / X86
# ==============================================================================
static func _populate_datapoint_2200(p: OSProfile) -> void:
	p.exhibit_subtitle = "Genesis of the Personal Workstation & Direct Architectural Ancestor of the Intel 8008 / x86 Architecture"
	p.era_classification = "Pioneering Workstation & Pre-Microprocessor Discrete Computing Era (1970–1973)"
	p.historical_overview = (
		"The Datapoint 2200 marks the historical genesis of the modern personal workstation. "
		+ "Conceived in 1969–1970 and first delivered in 1971 by Computer Terminal Corporation "
		+ "(CTC) of San Antonio, Texas—founded by Phil Ray and Gus Roche—the Datapoint 2200 was engineered intentionally to occupy the "
		+ "exact footprint of an IBM Selectric typewriter. Rather than serving as merely an interactive 'glass teletype' terminal, the 2200 "
		+ "was a self-contained, fully programmable 8-bit general-purpose computer integrating an internal curved 7-inch green CRT display "
		+ "(12 lines by 80 characters), a mechanical keyboard with numeric keypad, dual Philips digital cassette tape drives, and a discrete "
		+ "TTL processor board. In 1972, CTC released Datapoint DOS (version 2.1) alongside an external Diablo Series 30 top-loading 2.5MB "
		+ "removable cartridge disk drive, ushering in the era of disk-oriented desktop business computing."
	)
	p.historical_context = (
		"The architectural journey of the Datapoint 2200 encompasses three of the most foundational milestones in computing history:\n\n"
		+ "1. THE PREDECESSOR: CTOS (CASSETTE TAPE OPERATING SYSTEM, 1971):\n"
		+ "When first deployed in 1971, the 2200 operated under CTOS (Cassette Tape Operating System). CTOS utilized the twin built-in "
		+ "Philips digital cassette decks: Drive A held the operating system bootstrap, editor, and 8-bit macro assembler, while Drive B "
		+ "held user data, payroll ledgers, and source programs. Recording at 7.5 inches per second with 128-byte data blocks protected by "
		+ "16-bit CRC error verification, CTOS proved that desktop interactive computing was viable without punch cards. However, sequential "
		+ "tape seeking remained an operational bottleneck for random-access accounting. The arrival of Datapoint DOS 2.1 in 1972 paired "
		+ "with Diablo 2.5MB hard disks transformed the platform—introducing dynamic sector allocation, overlay execution, and the "
		+ "definitive 'CATALOG' directory structure.\n\n"
		+ "2. THE FUTURE: DATASHARE (1973) & THE GENESIS OF ARCNET (1977):\n"
		+ "In 1973, CTC software visionary Vic Poor and his engineering group unveiled Datashare—a revolutionary multi-user timesharing "
		+ "operating system. Datashare converted a single Datapoint 2200 desktop unit into a centralized business timesharing host running "
		+ "the compiled DATABUS commercial language, simultaneously driving up to 16 remote slave terminals (Datapoint 3600 and 3360) "
		+ "over serial asynchronous lines. Small and regional enterprises could now operate distributed, concurrent transaction processing "
		+ "without leasing multimillion-dollar IBM System/360 mainframes. As business operations scaled beyond a single disk hub, CTC "
		+ "invented ARCNET (Attached Resource Computer Network) in 1977—the world's first commercially available local area network (LAN), "
		+ "interconnecting Datapoint 2200 and 5500 workstations with shared disk resources years before commercial Ethernet deployments.\n\n"
		+ "3. THE GENESIS OF THE INTEL 8008 AND MODERN X86 ARCHITECTURE:\n"
		+ "To miniaturize the machine's bulky discrete TTL processor board, CTC founders Phil Ray and Gus Roche developed an elegant 8-bit "
		+ "register architecture (accumulators A, B, C, D, E, H, L, stack pointer, and flags) and contracted both Intel (Project 1201, led "
		+ "by Ted Hoff, Stan Mazor, and Federico Faggin) and Texas Instruments (TMX 1795) to fabricate single-chip microprocessors matching "
		+ "CTC's instruction set. When both semiconductor vendors suffered fabrication delays relative to CTC's immediate shipping deadlines, "
		+ "CTC built the 2200's processor using ~100 discrete MSI/SSI 7400-series TTL ICs. Intel subsequently released the completed silicon "
		+ "in April 1972 as the Intel 8008. The Intel 8008's instruction set was directly derived from the Datapoint 2200; the 8008 gave birth "
		+ "to the Intel 8080 (1974), which begat the Intel 8086 (1978), which became the x86 architecture that powers the modern computing world."
	)
	p.engineering_innovations = (
		"• Discrete TTL 8-Bit Architecture & The x86 Gene: Implemented an entire 8-bit general-purpose CPU across approximately 100 MSI TTL "
		+ "integrated circuits. The instruction set, register architecture, and 8-level pushdown stack commissioned for this design became the "
		+ "Intel 8008 and founded the unbroken x86 architectural lineage.\n"
		+ "• IBM Selectric Typewriter Form Factor: Engineered as an all-in-one desktop workstation integrating CPU, RAM, display, keyboard, "
		+ "and dual storage transports within a single desktop footprint that fit standard office typewriter desks.\n"
		+ "• Predecessor CTOS & Dual Philips Cassette Decks: Dual integrated digital tape drives storing 130 KB per cassette with automatic "
		+ "tape-mark searching, 128-byte block structures, and 16-bit CRC checksum parity.\n"
		+ "• Datapoint DOS 2.1 & Diablo Series 30 Hard Disk: Pioneered 2.5MB top-loading removable cartridge disk storage (2400 RPM, 408 cylinders) "
		+ "with dynamic directory allocation (`CATALOG`), system overlays, and indexed ISAM file access.\n"
		+ "• Genesis of Datashare (1973) & ARCNET (1977): Architectural foundation for the first commercial desktop multi-terminal timesharing "
		+ "system (Datashare) and the first commercial token-passing local area network (ARCNET)."
	)
	p.cultural_legacy = (
		"The Datapoint 2200 represents the dawn of personal workstation computing. "
		+ "Recognized by technical archivist and computing historian consensus as the architectural parent of the x86 microprocessor family "
		+ "and the pioneer of distributed business data processing, it proved that computing power belonged on the operator's desk rather "
		+ "than locked inside a glass mainframe room."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Computer Terminal Corporation (CTC • San Antonio, TX)",
		"Release Date": "1972 (Datapoint DOS 2.1 • Hardware launched 1971 with CTOS)",
		"System Model": "Datapoint 2200 Type II Workstation (Typewriter Form Factor)",
		"Processor (CPU)": "CTC 8-Bit Discrete MSI TTL Processor (~100 7400-Series ICs)",
		"Clock Rate & Cache": "3.33 MHz Master Clock (approx. 250,000–500,000 instructions/sec)",
		"Co-Processor / Architecture": "Architectural Progenitor of Intel 8008 (Project 1201) & x86",
		"System Bus & Chipset": "CTC Parallel 8-Bit Bus • Recirculating Logic & I/O Strobes",
		"Memory (RAM)": "16 KB Total (Original Type I: 2–8 KB Shift Registers; Type II: 16 KB RAM)",
		"Graphics / Video": "Integrated 7-inch Curved CRT • 12 Lines × 80 Characters Monochrome",
		"Audio Subsystem": "Internal Piezoelectric Alert Beeper / Solenoid Clicker (2400 Hz)",
		"Storage & Media": "Dual Philips Cassette Decks (130 KB/tape) + Diablo 2.5MB Cartridge Disk",
		"Operating System": "Datapoint DOS 2.1 (Disk Operating System)",
		"Kernel & Filesystem": "CTC DOS Executive • Diablo Sector Allocation • CATALOG Directory",
		"GUI / Window System": "Terse 12×80 P31 Green Phosphor Character Terminal Interface",
		"Default Shell": "Datapoint DOS Command Executive (`: ` Prompt)",
		"Original List Price": "$6,000–$14,000 USD (equivalent to ~$45,000–$105,000 in modern USD)",
		"Predecessor": "Datapoint 3300 (Glass Teletype, 1969) / CTOS Cassette Tape OS (1971)",
		"Successor": "Datapoint 5500 / 6600, Datashare Timesharing (1973), ARCNET (1977)"
	}
	p.usage_cases = [
		{
			"title": "The Genesis of the Personal Workstation — Decentralized Branch Office Ledger (1972)",
			"role": "Commercial Loan & Branch Accounting Clerk (Chase Manhattan Bank / Insurance Agency)",
			"software": "Datapoint DOS 2.1, DATABUS Business Compiler, Diablo 2.5MB Disk Subsystem",
			"scenario": "Powering on the 2200 as the CRT glows with green P31 phosphor. The operator inputs the current system date '10/22/72' at the terse DOS prompt, mounts the Diablo 2.5MB accounting pack, and enters loan transactions into DATABUS. Transaction records are validated locally on disk rather than batched overnight via courier punch cards."
		},
		{
			"title": "From CTOS Cassettes to Diablo Hard Disk Filing — Batch Migration & File Cataloging",
			"role": "Corporate Systems Administrator & CTC Field Engineer (1972)",
			"software": "CTOS (Cassette Tape Operating System), Datapoint DOS Migration Utility, Macro Assembler",
			"scenario": "Migrating archived accounting reels from Philips digital cassette tapes into the new Diablo removable disk cartridge. Inserting Drive A's master CTOS tape and Drive B's transaction ledger, streaming sequential 128-byte CRC records into Diablo Sector Drive 0, and invoking 'CATALOG' to inspect the newly indexed files."
		},
		{
			"title": "The Datashare Multi-Terminal Revolution (1973) — The Blueprint for Timesharing & ARCNET",
			"role": "Senior Systems Programmer & Multi-User Timesharing Architect",
			"software": "Datashare Timesharing Executive (1973), DATABUS 16-User Multi-Terminal System, Modems",
			"scenario": "Configuring the Datapoint 2200 as a central business timesharing host. Connecting multiple Datapoint 3600 slave terminals over current-loop wiring across an entire department floor, allowing simultaneous invoice generation and credit checks on a single shared Diablo disk, foreshadowing the 1977 launch of ARCNET."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. Datapoint 2200 Workstation Chassis: 12x80 CRT, Dual Cassettes & Diablo Disk Drive",
		"All-in-one typewriter-footprint console featuring integrated 7\" green CRT, keyboard, and twin tape decks beside the Diablo 2.5MB disk unit.",
		"Fig 2. CTC 8-Bit Discrete MSI Processor Board & Shift Register Memory Architecture",
		"Historical circuit schematic and logic board containing ~100 TTL chips—the direct architectural blueprint for the Intel 8008 and x86.",
		"Fig 3. Terse Datapoint DOS 2.1 Console Screen: Date Prompt, CATALOG Listing & `:` Shell",
		"Authentic 12-line by 80-column P31 green phosphor terminal interface showing the bootstrap sequence and disk directory."
	)


static func _build_default_image_slots(
	os_id: String,
	sys_title: String,
	sys_caption: String,
	hw_title: String,
	hw_caption: String,
	sw_title: String,
	sw_caption: String
) -> Array[Dictionary]:
	return [
		{
			"slot_id": "system",
			"title": sys_title,
			"caption": sys_caption,
			"asset_path": "res://assets/exhibits/%s/system.png" % os_id,
			"plate_type": "chassis"
		},
		{
			"slot_id": "hardware",
			"title": hw_title,
			"caption": hw_caption,
			"asset_path": "res://assets/exhibits/%s/hardware.png" % os_id,
			"plate_type": "motherboard"
		},
		{
			"slot_id": "software",
			"title": sw_title,
			"caption": sw_caption,
			"asset_path": "res://assets/exhibits/%s/software.png" % os_id,
			"plate_type": "software_ui"
		}
	]

