extends RefCounted
## Archival Museum Exhibit Packages (Part I: 2000–2011 Workstations & Modern Systems).
## Provides historical context, engineering analysis, Wikipedia-style Infobox technical
## specifications, period-correct usage case dossiers, and media gallery slots.

const OSProfile = preload("res://data/os_profile.gd")


static func populate(p: OSProfile) -> bool:
	match p.id:
		"ubuntu_704":
			_populate_ubuntu_704(p)
			return true
		"ubuntu_1004":
			_populate_ubuntu_1004(p)
			return true
		"evga_sr2":
			_populate_evga_sr2(p)
			return true
		"freebsd_411":
			_populate_freebsd_411(p)
			return true
		"winxp_alienware":
			_populate_winxp_alienware(p)
			return true
		"plan9":
			_populate_plan9(p)
			return true
		"sgi_irix":
			_populate_sgi_irix(p)
			return true
		"beos_r5":
			_populate_beos_r5(p)
			return true
		"hpux_cde":
			_populate_hpux_cde(p)
			return true
		"redhat_62":
			_populate_redhat_62(p)
			return true
		"solaris_8":
			_populate_solaris_8(p)
			return true
	return false


static func _populate_ubuntu_704(p: OSProfile) -> void:
	p.exhibit_subtitle = "Canonical's Mainstream Desktop Linux Breakthrough on Dell OptiPlex GX620"
	p.era_classification = "Mid-2000s Consumer Open-Source Desktop Era (April 2007)"
	p.historical_overview = (
		"Ubuntu 7.04 ('Feisty Fawn'), released on April 19, 2007 by Canonical Ltd., represents the high-water mark "
		+ "of classic GNOME 2 desktop Linux. Arriving just three months after Microsoft's resource-heavy Windows Vista, "
		+ "Feisty Fawn captured global attention by offering plug-and-play hardware detection, guided proprietary codec "
		+ "installation, zero-configuration Wi-Fi via NetworkManager, and dazzling hardware-accelerated Compiz/Beryl 3D "
		+ "desktop cube effects on modest x86 corporate hardware such as the Dell OptiPlex GX620."
	)
	p.historical_context = (
		"Founded by South African entrepreneur Mark Shuttleworth in 2004, Canonical sought to transform Debian GNU/Linux "
		+ "from a server and hacker distribution into a cohesive, six-month release-cycle operating system ('Linux for Human Beings'). "
		+ "Through the famous 'ShipIt' program, Canonical mailed millions of free pressed Live/Install CD-ROMs worldwide. "
		+ "By release 7.04, Ubuntu had overtaken Mandriva, SUSE, and Fedora on DistroWatch. Less than a month after 7.04's "
		+ "release, Dell announced it would pre-install Ubuntu 7.04 on consumer Dimension desktops and Inspiron laptops—a "
		+ "watershed moment for retail Linux adoption."
	)
	p.engineering_innovations = (
		"• Kernel & HAL/udev Stack: Built on Linux 2.6.20.3 with the Completely Fair Queuing (CFQ) I/O scheduler, "
		+ "KVM (Kernel-based Virtual Machine) debuting in mainline Linux, and dynamic '/dev' device node population via udev.\n"
		+ "• GNOME 2.18 & Clearlooks 'Human' Theme: Engineered around GTK+ 2.10 with Murrine/Clearlooks warm ochre-and-brown "
		+ "gradients, Tangerine vector icons, and dual-panel workspace ergonomics.\n"
		+ "• On-Demand Codec & Driver Assistants: Introduced the Restricted Drivers Manager (automatically enabling NVIDIA/ATI "
		+ "GLX drivers and Broadcom wireless firmware) and a GStreamer wizard that automatically fetched MP3/DivX decoders.\n"
		+ "• Windows Migration Assistant: Integrated into the Ubiquity live installer to import Internet Explorer bookmarks, "
		+ "AIM/MSN contacts, and desktop wallpapers directly from existing NTFS partitions during dual-boot setup."
	)
	p.cultural_legacy = (
		"Ubuntu 7.04 is fondly remembered by Linux veterans as the pinnacle of the 'brown Ubuntu' aesthetic—complete with "
		+ "its warm marimba login chime and djembe drum readiness beat—before the 2010 transition to the purple-and-aubergine "
		+ "'Ambiance' theme and Unity shell. It established Ubuntu as the default gateway distribution for a generation of "
		+ "computer science students, web developers, and open-source advocates."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Canonical Ltd. / Dell Inc. (Hardware)",
		"Release Date": "April 19, 2007 (Support ended Oct 2008)",
		"System Model": "Dell OptiPlex GX620 Small Mini-Tower (BTX)",
		"Processor (CPU)": "Intel Core 2 Duo E6400 (Conroe, 65nm) / Pentium D",
		"Clock Rate & Cache": "2.13 GHz Dual-Core • 2 MB Shared L2 • 1066 MT/s FSB",
		"Co-Processor / DSP": "Integrated x87 FPU & SSE3 / EM64T Vector Engine",
		"System Bus & Chipset": "Intel 945G Express (Lakeport) + ICH7 Southbridge • PCIe x16",
		"Memory (RAM)": "1024 MB DDR2-533 SDRAM (Dual-Channel, expandable to 4 GB)",
		"Graphics / Video": "Intel GMA 950 / NVIDIA GeForce 7300 GT 256 MB (X.Org 7.2 + AIGLX)",
		"Audio Subsystem": "ADI 198x AC'97 / ALSA 1.0.13 + ESD (Enlightened Sound Daemon)",
		"Storage & Media": "160 GB Seagate Barracuda 7200.9 SATA-II + 16x DVD±RW",
		"Operating System": "Ubuntu 7.04 (Codename: 'Feisty Fawn')",
		"Kernel & Filesystem": "Linux 2.6.20-15-generic (i686 SMP) • ext3 with dir_index",
		"GUI / Window System": "X.Org R7.2 • GNOME 2.18.1 • Metacity / Compiz 0.3.6",
		"Default Shell": "GNU bash 3.2.13 (/bin/bash)",
		"Original List Price": "OS: Free (ShipIt CD) • Dell OptiPlex GX620: $849 USD",
		"Predecessor": "Ubuntu 6.10 (Edgy Eft, October 2006)",
		"Successor": "Ubuntu 7.10 (Gutsy Gibbon, October 2007)"
	}
	p.usage_cases = [
		{
			"title": "University Computer Science Lab & LAMP Web Development Workstation",
			"role": "Undergraduate CS Student & Part-Time Ruby on Rails / PHP Developer (2007)",
			"software": "GNOME Terminal, Vim 7.0, Apache 2.2, MySQL 5.0, Firefox 2.0.0.3, Pidgin IM",
			"scenario": "Booted via GRUB 0.97 from a dual-boot Dell OptiPlex tower in a dorm room. The operator runs a local LAMP stack and Subversion repository, compiling C assignments with GCC 4.1.2 while chatting on IRC (#ubuntu on Freenode) via XChat and streaming Creative Commons Ogg Vorbis tracks in Rhythmbox."
		},
		{
			"title": "Compiz Desktop Effects & Windows Vista Counter-Demonstration",
			"role": "Linux User Group (LUG) Installfest Volunteer (Spring 2007)",
			"software": "Desktop Effects (Compiz 0.3.6), GLXgears, Synaptic Package Manager, GParted Live",
			"scenario": "At a Saturday afternoon campus Installfest, a volunteer enables 'Desktop Effects' with two clicks. Rotating the 4-sided 3D Desktop Cube with wobbly windows and rain shaders on a $600 PC with 512MB RAM convinces passersby frustrated by Windows Vista's hardware requirements to take home a beige ShipIt CD sleeve."
		},
		{
			"title": "Small Office OpenDocument Migration & Network File Server",
			"role": "Independent IT Consultant & Systems Integrator",
			"software": "OpenOffice.org 2.2 Writer/Calc, Evolution 2.10 Groupware, Samba 3.0, CUPS",
			"scenario": "Deployed across a dozen refurbished Dell OptiPlex GX620 workstations in a municipal library. Users write documents in OpenOffice.org 2.2, mount Windows Server shares seamlessly through Nautilus GVFS, and print to networked HP LaserJet 4000 printers via CUPS."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. Dell OptiPlex GX620 BTX Mini-Tower & 19\" UltraSharp 1907FP LCD",
		"The corporate workhorse Dell OptiPlex GX620 in dark gray/silver BTX styling paired with an UltraSharp 4:3 flat-panel monitor.",
		"Fig 2. Intel 945G BTX Motherboard, Core 2 Duo LGA775 & SATA-II Architecture",
		"Internal BTX airflow tunnel cooling the LGA775 processor, dual-channel DDR2 DIMMs, and ICH7 SATA controller.",
		"Fig 3. GNOME 2.18 'Human' Desktop with Dual Panels & Synaptic Package Manager",
		"Ubuntu 7.04's signature warm brown wallpaper, top Applications/Places/System bar, and Clearlooks-glossy window borders."
	)


static func _populate_freebsd_411(p: OSProfile) -> void:
	p.exhibit_subtitle = "The Legendary Dot-Com & ISP Backbone OS on Supermicro Dual-Pentium III"
	p.era_classification = "Early-2000s Carrier-Grade BSD Server & Workstation Era (January 2005)"
	p.historical_overview = (
		"FreeBSD 4.11-STABLE represents the final, ultra-hardened release of the legendary FreeBSD 4-STABLE branch—arguably "
		+ "the most rock-solid UNIX server and workstation operating system of the late 1990s and early 2000s. Descended "
		+ "directly from UC Berkeley's 4.4BSD-Lite, the FreeBSD 4.x series powered Yahoo!, Hotmail, Apache.org, Walnut Creek "
		+ "CDROM, and thousands of ISP colocation cages, achieving multi-year uptimes under extreme TCP/IP network loads."
	)
	p.historical_context = (
		"Throughout the dot-com boom and its aftermath (2000–2005), FreeBSD 4.x was revered by systems administrators "
		+ "for its unified VM/buffer cache designed by John Dyson and Matthew Dillon, its Kqueue event notification subsystem "
		+ "created by Jonathan Lemon, and its pioneering 'Jails' OS-level virtualization. While FreeBSD 5.x introduced fine-grained "
		+ "SMPng kernel locking, many high-traffic data centers and greybeard UNIX engineers refused to migrate off the 4.x "
		+ "branch until 4.11-STABLE concluded its lifecycle in 2007."
	)
	p.engineering_innovations = (
		"• Kqueue / kevent Scalable I/O: Provided O(1) stateful event notification for tens of thousands of concurrent "
		+ "sockets, solving the C10k problem years before Linux epoll.\n"
		+ "• UFS1 with Soft Updates: Kirk McKusick's Soft Updates tracked metadata dependencies in memory as a directed "
		+ "acyclic graph, delivering near-memory filesystem write speeds while guaranteeing disk consistency without journaling overhead.\n"
		+ "• FreeBSD Jails (chroot on steroids): Partitioned a single kernel into isolated virtual UNIX userlands with "
		+ "dedicated IP addresses—the direct conceptual ancestor of modern containers.\n"
		+ "• The Ports Collection (/usr/ports): Over 12,000 software packages compiled from source tuned to specific CPU flags "
		+ "via simple 'make install clean' invocations."
	)
	p.cultural_legacy = (
		"Featuring Marshall Kirk McKusick's cheerful red BSD Daemon ('Beastie') in sneakers holding a pitchfork on the "
		+ "Forth-based ASCII boot loader menu, FreeBSD 4.11 embodies classic Berkeley UNIX craftsmanship. Its TCP/IP stack, "
		+ "kqueue, and userland utilities were adopted directly into Apple's Darwin / Mac OS X, Sony's PlayStation 3/4 OS, "
		+ "and Netflix's Open Connect CDN appliances."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "The FreeBSD Project • Supermicro Computer, Inc.",
		"Release Date": "January 25, 2005 (4.x Branch debuted March 2000)",
		"System Model": "Supermicro SuperServer P3TDDE 2U / Tower Workstation",
		"Processor (CPU)": "Dual Intel Pentium III-S 1.40 GHz (Tualatin, 130nm)",
		"Clock Rate & Cache": "2x 1400 MHz SMP • 512 KB On-Die Full-Speed L2 per CPU",
		"Co-Processor / DSP": "Dual Integrated x87 FPU + SSE SIMD Units",
		"System Bus & Chipset": "ServerWorks ServerSet III HE-SL / VIA Apollo Pro266T • 64-bit PCI",
		"Memory (RAM)": "2048 MB Registered ECC PC133 SDRAM",
		"Graphics / Video": "Matrox Millennium G450 DualHead 32 MB DDR (XFree86 4.4.0)",
		"Audio Subsystem": "Creative Sound Blaster PCI128 (Ensoniq ES1371 • pcm0 driver)",
		"Storage & Media": "2x 36.7 GB Fujitsu MAP3367NP Ultra160 SCSI (10,000 RPM) on Adaptec ahd0",
		"Operating System": "FreeBSD 4.11-RELEASE-p14 (i386)",
		"Kernel & Filesystem": "4.4BSD-Lite2 Monolithic SMP Kernel • UFS1 + Soft Updates",
		"GUI / Window System": "XFree86 4.4.0 • WindowMaker 0.91.0 (NeXTSTEP-style Dock & Clip)",
		"Default Shell": "TENEX C Shell (tcsh 6.13.00) / Almquist sh",
		"Original List Price": "OS: Free (BSD License / 4-CD Set $39) • Server: $2,850 USD",
		"Predecessor": "FreeBSD 4.10-RELEASE (May 2004)",
		"Successor": "FreeBSD 5.4 / 6.0-RELEASE (2005)"
	}
	p.usage_cases = [
		{
			"title": "ISP NOC Engineering Workstation & Colocation Bastion Host",
			"role": "Senior Network Operations Center (NOC) UNIX Administrator (2004)",
			"software": "WindowMaker 0.91, xterm, OpenSSH 3.8, BIND 9, ipfw + dummynet, MRTG, tcpdump",
			"scenario": "Running WindowMaker on a sharp Matrox G450 CRT in a chilledNOC facility. Six docked xterm windows monitor BGP peerings, 'top' shows 412 days of uninterrupted uptime, and the administrator compiles a custom security patch from '/usr/ports/security/openssh-portable' while shaping bandwidth pipes with dummynet."
		},
		{
			"title": "High-Concurrency Apache + mod_perl Web Cluster Node",
			"role": "Systems Architect at a High-Traffic E-Commerce Portal",
			"software": "Apache 1.3.33, mod_perl, PostgreSQL 7.4, FreeBSD Jails, kqueue, systat -vmstat",
			"scenario": "Serving 3,500 dynamic HTTP requests per second off twin 10,000 RPM Ultra160 SCSI spindles. Each customer tenant is isolated inside its own '/usr/sbin/jail' environment while Soft Updates eliminates synchronous disk metadata bottlenecks."
		},
		{
			"title": "Academic Network Protocol Research & Traffic Simulation Lab",
			"role": "Graduate Networking Researcher",
			"software": "FreeBSD Kernel Source (/usr/src/sys/netinet), GDB, Ethereal, Dummynet",
			"scenario": "Modifying TCP NewReno and SACK congestion control algorithms directly in '/usr/src/sys/netinet/tcp_input.c', recompiling the custom kernel in under four minutes on Dual Tualatin Pentium IIIs, and simulating trans-oceanic packet loss with ipfw dummynet."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. Supermicro Dual-Tualatin Workstation & Beastie Forth Bootloader",
		"Heavy-duty beige/charcoal server chassis with hot-swap Ultra160 SCSI bays and the iconic ASCII BSD Daemon boot screen.",
		"Fig 2. Dual Socket-370 Pentium III-S (Tualatin 512KB) & Adaptec 29160 SCSI HBA",
		"Symmetric multiprocessing board featuring dual copper heatsink blowers, 64-bit PCI slots, and ECC SDRAM banks.",
		"Fig 3. WindowMaker 0.91 Workspace with Docked NeXT-Style Applets & root xterms",
		"Slate-blue WindowMaker workspace with floating clip, CPU/network dockapps, and green-on-black tcsh terminals."
	)


static func _populate_winxp_alienware(p: OSProfile) -> void:
	p.exhibit_subtitle = "High-Octane 2003 PC Gaming & Enthusiast Modding on the Alienware Area-51"
	p.era_classification = "Early-2000s Enthusiast Gaming Rig & NT5 Consumer Unification Era (2003–2004)"
	p.historical_overview = (
		"Few machines capture the exuberant, neon-lit spirit of early-2000s PC enthusiasm like the 2003 Alienware Area-51 "
		+ "housed in its unmistakable 'Predator' Series-1 full-tower chassis (custom-molded over a Chieftec Dragon steel frame) "
		+ "running Windows XP Professional Service Pack 2. Powered by an Intel Pentium 4 3.2 GHz Extreme Edition ('Gallatin' "
		+ "with 2 MB L3 cache), an ATI Radeon 9800 XT 256 MB AGP 8x card, and twin 10,000 RPM Western Digital Raptor SATA drives "
		+ "in a Promise FastTrak RAID-0 stripe, this was the $3,800 dream machine featured on the cover of Maximum PC and PC Gamer."
	)
	p.historical_overview += (
		" Windows XP itself unified Microsoft's rock-solid Windows NT/2000 32-bit kernel with consumer DirectX 9.0c gaming "
		+ "compatibility, wrapped in the vibrant blue-and-green 'Luna' visual style and custom AlienGUIse Stardock WindowBlinds themes."
	)
	p.historical_context = (
		"Founded in 1996 by Nelson Gonzalez and Alex Aguila in Miami, Florida, Alienware pioneered the boutique pre-built "
		+ "gaming PC market. By 2003, impending blockbusters like Half-Life 2, Doom 3, and Far Cry demanded programmable "
		+ "DirectX 9.0 Pixel Shader 2.0 hardware and high-bandwidth FSB memory. At the same time, Windows XP Service Pack 2 "
		+ "(August 2004) matured XP into an enduring classic by introducing the Windows Security Center, an enabled-by-default "
		+ "stateful firewall, NX-bit Data Execution Prevention (DEP), and Bluetooth/WPA Wi-Fi support."
	)
	p.engineering_innovations = (
		"• Pentium 4 Extreme Edition ('Gallatin'): Repackaged Intel's Xeon MP die for Socket 478 enthusiasts, adding a massive "
		+ "2 MB on-die L3 cache to offset the deep 20-stage NetBurst pipeline over an 800 MT/s quad-pumped FSB.\n"
		+ "• ATI Radeon 9800 XT (R360) & DirectX 9.0c: 8 pixel pipelines and 4 vertex engines with 256-bit DDR interface, "
		+ "delivering hardware floating-point shaders (HLSL) and SmartShader 2.0.\n"
		+ "• Dual WD Raptor WD360GD RAID-0: Enterprise 10,000 RPM mechanics adapted to first-generation SATA-150, yielding "
		+ "4.5 ms seek times and ferocious acoustic voice-coil chatter during level loads.\n"
		+ "• Windows NT 5.1 Kernel + uxtheme.dll: Preemptive multitasking, hardware memory protection, Fast User Switching, "
		+ "ClearType sub-pixel font rendering, and skinnable GDI+ window chrome."
	)
	p.cultural_legacy = (
		"Windows XP went on to become one of the longest-lived operating systems in history, remaining in widespread use "
		+ "for well over a decade. Paired with the Martian-Green or Cyborg-Silver Alienware Predator case, cold-cathode lighting, "
		+ "Winamp 2.91 ('It really whips the llama's ass!'), Ventrilo voice chat, and 3DMark03 benchmarking, this exhibit "
		+ "preserves the golden age of LAN party culture."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Alienware Corporation (Miami, FL) • Microsoft Corp.",
		"Release Date": "Autumn 2003 (Hardware) • August 2004 (Windows XP SP2)",
		"System Model": "Alienware Area-51 Extreme ('Predator' Series-1 Full Tower)",
		"Processor (CPU)": "Intel Pentium 4 Extreme Edition 3.20 GHz (Gallatin, 130nm)",
		"Clock Rate & Cache": "3.20 GHz (Hyper-Threading) • 512 KB L2 + 2 MB L3 • 800 MHz FSB",
		"Co-Processor / DSP": "SSE2 SIMD + Creative EMU10K2 Hardware 3D Audio DSP",
		"System Bus & Chipset": "Intel 875P ('Canterwood') + ICH5R • Dual-Channel PAT • AGP 8x",
		"Memory (RAM)": "2048 MB Corsair XMS Pro DDR-400 (PC-3200 Low-Latency CAS 2)",
		"Graphics / Video": "ATI Radeon 9800 XT 256 MB DDR (256-bit, 412/730 MHz, AGP 8x)",
		"Audio Subsystem": "Sound Blaster Audigy 2 ZS Platinum Pro (24-bit/192kHz, EAX 4.0 HD)",
		"Storage & Media": "2x 36.7 GB WD Raptor 10,000 RPM SATA RAID-0 (73.4 GB) + Plextor 8x DVD",
		"Operating System": "Microsoft Windows XP Professional Service Pack 2 (Build 2600)",
		"Kernel & Filesystem": "Windows NT 5.1 Hybrid Kernel (32-bit x86) • NTFS 3.1",
		"GUI / Window System": "Explorer.exe • Luna Visual Style (Blue/Olive/Silver) + AlienGUIse",
		"Default Shell": "Windows Command Prompt (cmd.exe)",
		"Original List Price": "$3,799 USD (With NEC MultiSync 22\" CRT & Klipsch 5.1 Speakers)",
		"Predecessor": "Windows 2000 Professional / Windows Me (2000)",
		"Successor": "Windows Vista Ultimate (January 2007)"
	}
	p.usage_cases = [
		{
			"title": "Overnight BYOC LAN Party — Counter-Strike 1.6, Battlefield 1942 & Doom 3",
			"role": "Competitive Clan Player & Hardware Overclocker (2004)",
			"software": "Steam (2003 Olive UI), Counter-Strike 1.6, Doom 3, Ventrilo 2.1, Fraps, Winamp 2.91",
			"scenario": "Hauled into a convention hall alongside a 70-pound 21-inch Trinitron CRT. Five 80mm Panaflo chassis fans roar at 3,400 RPM while the dual 10K RPM Raptors load 'de_dust2' before anyone else in the server spawns. Winamp 2.91 plays MP3s in the background with zero frame drops thanks to Hyper-Threading and hardware EAX 4.0 audio."
		},
		{
			"title": "3DMark03 Overclocking & Maximum PC Benchmark Shootout",
			"role": "Enthusiast Hardware Reviewer",
			"software": "Futuremark 3DMark03, CPU-Z 1.21, ATI Catalyst Control Center, MotherBoard Monitor 5",
			"scenario": "Pushing the Intel 875P Front Side Bus in AMIBIOS to 215 MHz while monitoring copper heatsink temperatures and ATI Overdrive clocks, chasing a 7,200+ score in 3DMark03's 'Mother Nature' pixel shader test."
		},
		{
			"title": "Digital Video Editing & Machinima Production Suite",
			"role": "Independent Machinima Creator & DV Video Editor",
			"software": "Sony Vegas Video 4.0, Adobe Premiere Pro 1.0, VirtualDub, RAD Video Tools",
			"scenario": "Capturing uncompressed AVI game footage to the 120 MB/s RAID-0 Raptor array, cutting timelines over IEEE-1394 FireWire on the Audigy 2 ZS breakout box, and encoding DivX 5.11 high-resolution trailers overnight."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. Alienware Area-51 'Predator' Full-Tower Chassis in Saucer Silver / Conspiracy Blue",
		"The iconic molded ABS front bezel with glowing alien head emblem, curved vents, and NEC 22\" Diamondtron CRT.",
		"Fig 2. Intel 875P Canterwood Board, P4 Extreme Edition & ATI Radeon 9800 XT Copper Cooler",
		"Inside the custom-wired chassis: Corsair XMS LED memory modules, copper AGP 8x Radeon 9800 XT, and dual SATA Raptors.",
		"Fig 3. Windows XP Luna Desktop with AlienAdrenaline Telemetry & Winamp 2.91",
		"Signature royal-blue taskbar with green 'start' button, Bliss horizon palette, and active system monitoring."
	)


static func _populate_plan9(p: OSProfile) -> void:
	p.exhibit_subtitle = "Bell Labs' Pure Distributed UNIX Successor ('Everything is a File Server')"
	p.era_classification = "Bell Labs Computing Sciences Research OS (4th Edition, 2002)"
	p.historical_overview = (
		"Created by the original UNIX pioneers at Bell Labs' Computing Sciences Research Center (CSRC)—including Ken Thompson, "
		+ "Dennis Ritchie, Rob Pike, Dave Presotto, and Phil Winterbottom—Plan 9 from Bell Labs was designed from a clean sheet "
		+ "starting in the late 1980s to answer a bold question: What would UNIX look like if it were built for a world of "
		+ "networked graphics terminals, central CPU servers, and dedicated file servers rather than a 1970s time-sharing PDP-11?"
	)
	p.historical_context = (
		"By the mid-1980s, UNIX had grown bloated with overlapping networking APIs (BSD sockets, System V STREAMS), complex "
		+ "ioctl() calls, and monolithic X11 window servers. The Bell Labs team realized that UNIX's core insight—representing "
		+ "resources as files—had stopped too soon. In Plan 9, EVERY system interface (network connections, graphics windows, "
		+ "processes, audio, environment variables, and authentication) is exported as a hierarchical file tree speaking a "
		+ "single network-transparent protocol: 9P (revised to 9P2000 in the 4th Edition release of April 2002)."
	)
	p.engineering_innovations = (
		"• Per-Process Mutable Namespaces: Unlike UNIX's global '/' root tree, each Plan 9 process constructs its own private "
		+ "view of the filesystem using union directories and 'bind'/'mount' without superuser privileges.\n"
		+ "• The 9P2000 Protocol: A compact 17-message file protocol allowing a user on an x86 terminal to bind a remote "
		+ "MIPS or Alpha CPU server's '/proc' and '/net' directly over local '/net', running remote binaries transparently.\n"
		+ "• UTF-8 Invented for Plan 9: Ken Thompson and Rob Pike designed UTF-8 on a restaurant placemat in September 1992 "
		+ "and implemented it across the entire Plan 9 system within days—making Plan 9 the first native Unicode OS.\n"
		+ "• Rio, Acme & Rc: Rob Pike's minimalist 'rio' window manager (where windows are literally file servers multiplexing "
		+ "'/dev/cons' and '/dev/mouse'), the 'acme' programmer's environment using three-button mouse chording, and Tom Duff's clean 'rc' shell."
	)
	p.cultural_legacy = (
		"While Plan 9 remained primarily a research and academic jewel rather than a commercial desktop juggernaut, its "
		+ "inventions reshaped modern computing: UTF-8 is now the universal encoding of the Web; Linux's '/proc' filesystem, "
		+ "unshare() namespaces (the foundation of Docker/Kubernetes), WSL2's 9P file sharing, and the Go programming language "
		+ "all trace their lineage directly to Plan 9 and its bunny mascot, Glenda."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Bell Labs / Lucent Technologies (Murray Hill, NJ)",
		"Release Date": "April 2002 (4th Edition • 1st Edition released 1992)",
		"System Model": "Bell Labs '9pc' Diskless/Fossil x86 Graphics Terminal",
		"Processor (CPU)": "Intel Pentium III 733 MHz (Coppermine) + Remote CPU Servers",
		"Clock Rate & Cache": "733 MHz • 256 KB Advanced Transfer L2 Cache • 133 MHz FSB",
		"Co-Processor / DSP": "Integrated x87 FPU (Kernel 9pcf)",
		"System Bus & Chipset": "Intel 440BX AGPset • 32-bit PCI Bus",
		"Memory (RAM)": "256 MB PC100 ECC SDRAM",
		"Graphics / Video": "3dfx Voodoo3 / Matrox G400 (Hardware cursor + /dev/draw raster)",
		"Audio Subsystem": "Sound Blaster 16 ISA/PCI (/dev/audio & /dev/volume)",
		"Storage & Media": "Local Fossil + Venti Archival Content-Addressed Block Store",
		"Operating System": "Plan 9 from Bell Labs (Fourth Edition)",
		"Kernel & Filesystem": "9pcf Kernel • 9P2000 Protocol • Fossil + Venti SHA-1 Store",
		"GUI / Window System": "Rio Window System (/dev/wsys) + Acme Editor + Plumber",
		"Default Shell": "Tom Duff's Plan 9 Shell — rc (/bin/rc)",
		"Original List Price": "Free Open Source (Lucent Public License 1.02)",
		"Predecessor": "Research UNIX 10th Edition (1989) / Plan 9 3rd Ed. (2000)",
		"Successor": "Inferno / 9front Community Fork / Go Language Runtime"
	}
	p.usage_cases = [
		{
			"title": "Distributed Kernel Compilation & Plumbing in Acme at Murray Hill",
			"role": "Member of Technical Staff, Bell Labs CSRC (2002)",
			"software": "rio, acme, plumber, 8c / 8l (Ken Thompson's C Compiler), mk, sam",
			"scenario": "Sitting before a three-button mouse and high-resolution CRT. The researcher right-clicks a compiler error path inside 'acme'; the 'plumber' IPC daemon routes the message and opens the exact C source file at the offending line. Running 'mk' compiles the x86 kernel in three seconds flat using Ken Thompson's ultra-fast '8c' compiler."
		},
		{
			"title": "Transparent Cross-Continent Gateway Tunneling via /net.alt",
			"role": "Distributed Systems Researcher",
			"software": "import, bind, cpu, factotum, secstore, ip/ping",
			"scenario": "A laptop user outside a corporate firewall runs 'import -a gateway /net' to bind the remote machine's network stack over their local '/net'. Instantly, every local program—without a single line of proxy code—routes its TCP/IP connections through the remote Bell Labs gateway."
		},
		{
			"title": "Immutable Daily Filesystem Snapshots with Fossil & Venti",
			"role": "Storage Systems Architect",
			"software": "fossil, venti, vac, history, yesterday",
			"scenario": "Every night at midnight, Fossil flushes deduplicated, SHA-1 content-addressed blocks to the Venti archival server. When a developer accidentally deletes a source file, they simply type 'diff /n/dump/2002/1020/sys/src/cmd/rio.c rio.c' or 'yesterday -c rio.c' to compare or restore from the immutable time-indexed dump tree."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. Bell Labs 9pc Terminal Workstation with Three-Button Mouse & Glenda Badge",
		"A no-nonsense engineering workstation configured with a true 3-button mouse essential for rio and acme chording.",
		"Fig 2. Plan 9 Distributed Architecture: Terminal, CPU Server & Fossil/Venti over 9P2000",
		"Diagram of the 9P2000 per-process namespace binding local graphics (/dev/draw) with remote compute and Venti SHA-1 storage.",
		"Fig 3. Rob Pike's 'rio' Window System & 'acme' Programmer's Environment",
		"Signature #777777 slate gray background, #FFFFEA pale yellow text panes, and #55AAAA teal window borders."
	)


static func _populate_sgi_irix(p: OSProfile) -> void:
	p.exhibit_subtitle = "Hollywood's Visual Effects Super-Workstation (Dual MIPS R14000A & VPro V12)"
	p.era_classification = "Turn-of-the-Millennium 64-Bit RISC Graphics Workstation Era (2001)"
	p.historical_overview = (
		"The Silicon Graphics Octane2 running IRIX 6.5.22 represents the zenith of dedicated 64-bit RISC visual computing "
		+ "before commodity x86 GPUs overtook the workstation market. Recognizable by its sculpted deep-blue 'Skins' polymer "
		+ "shell, the 75-pound Octane2 eschewed conventional buses altogether: its heart was the 'Crossbow' (Xbow) 8-port "
		+ "non-blocking crossbar switch connecting dual 600 MHz MIPS R14000A 64-bit processors directly to up to 8 GB of RAM "
		+ "and the massive VPro V12 Odyssey hardware OpenGL geometry/raster engine."
	)
	p.historical_context = (
		"Throughout the 1990s and early 2000s, Silicon Graphics (SGI) owned Hollywood, automotive CAD, and scientific visualization. "
		+ "From Jurassic Park and Star Wars: Episode I to The Lord of the Rings, feature film animation was sculpted on IRIX "
		+ "workstations. Released in 2000–2001 as an upgraded successor to the original emerald-green Octane, the Octane2 introduced "
		+ "VPro (Odyssey) graphics with hardware-accelerated OpenGL 1.2 imaging pipelines, 48-bit RGBA deep color, and real-time "
		+ "3D volumetric texture mapping."
	)
	p.engineering_innovations = (
		"• Crossbow (Xbow) Packetized Crossbar Interconnect: Replaced shared system buses with a peer-to-peer 1.6 GB/s per-link "
		+ "non-blocking switch ASIC, allowing uncompressed HD video streams to DMA directly from SCSI disks to the VPro framebuffer "
		+ "without touching CPU cache.\n"
		+ "• Dual MIPS R14000A 64-Bit RISC: Out-of-order superscalar processors with 4 MB DDR secondary cache each, executing "
		+ "up to four instructions per clock cycle.\n"
		+ "• VPro V12 Graphics ('Odyssey'): Dedicated Buzz ASIC combining geometry engine, rasterizer, and 128 MB of unified "
		+ "SDRAM supporting dual-head 1920x1200 @ 72Hz Sony Trinitron displays and hardware quad-buffered stereo 3D glasses.\n"
		+ "• IRIX 6.5 & XFS Filesystem: SGI's 64-bit SVR4/BSD UNIX featuring guaranteed-rate real-time I/O (GRIO) for uncompressed "
		+ "film playback, the high-throughput XFS 64-bit journaled filesystem, and the Indigo Magic (4Dwm) vector-icon desktop."
	)
	p.cultural_legacy = (
		"The SGI Octane2 is a prized centerpiece in vintage computing collections worldwide. Its Indigo Magic desktop—featuring "
		+ "the top-left vertical 'Toolchest', isometric 3D vector icons on the 'Desks Overview', 'gr_osview' real-time resource "
		+ "bars, and the resonant metallic gong startup chime—remains one of the most distinctive workstation UIs ever crafted."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Silicon Graphics, Inc. (Mountain View, CA)",
		"Release Date": "2001 (Octane2 V12 • IRIX 6.5.22 Maintenance Release)",
		"System Model": "SGI Octane2 (IP30 Architecture • 'Skins' Blue Chassis)",
		"Processor (CPU)": "Dual MIPS R14000A (64-bit Out-of-Order Superscalar RISC)",
		"Clock Rate & Cache": "2x 600 MHz • 64 KB L1 + 4 MB DDR SRAM L2 per CPU",
		"Co-Processor / DSP": "Dual MIPS R14010 Pipelined 64-Bit IEEE-754 FPU",
		"System Bus & Chipset": "SGI HEART Memory Controller + Crossbow (Xbow) 8-Port Crossbar",
		"Memory (RAM)": "2048 MB Proprietary 200-pin ECC SDRAM (1.6 GB/s Memory Bus)",
		"Graphics / Video": "SGI VPro V12 (Odyssey Buzz ASIC • 128 MB • 48-bit RGBA OpenGL)",
		"Audio Subsystem": "RAD PCI Digital Audio (24-bit ADAT Optical + AES/EBU + Analog)",
		"Storage & Media": "2x 73 GB Seagate Cheetah 10K RPM Ultra160 SCSI XFS XLV Stripe",
		"Operating System": "IRIX 6.5.22f (64-bit UNIX System V Release 4 / 4.3BSD)",
		"Kernel & Filesystem": "64-bit /unix (IP30) • SGI XFS Journaled + XLV Volume Manager",
		"GUI / Window System": "Xsgi X11R6 • Indigo Magic Desktop • 4Dwm (Motif) + Toolchest",
		"Default Shell": "IRIX TENEX C Shell (tcsh) / KornShell (ksh)",
		"Original List Price": "$24,995 USD (Dual 600MHz V12 Configuration)",
		"Predecessor": "SGI Octane (MXI / MXE, 1997) & SGI Indigo2 IMPACT",
		"Successor": "SGI Tezro (Quad R16000, 2003) & SGI Fuel"
	}
	p.usage_cases = [
		{
			"title": "Feature Film Creature Modeling & Subdivision Surface Rigging (Hollywood)",
			"role": "Senior Character Technical Director at a Major VFX Studio (2001)",
			"software": "Alias|Wavefront Maya 3.5 Unlimited, Pixar RenderMan (prman), fcheck, gr_osview",
			"scenario": "Working in a darkened animation suite on a 24-inch Sony GDM-FW900 widescreen Trinitron CRT. The animator tumbles a 500,000-polygon NURBS creature rig at 60 FPS using the VPro V12 hardware lighting engine while 'gr_osview' shows both 600MHz R14000A CPUs pegging 100% as test frames spool to the RenderMan farm."
		},
		{
			"title": "Uncompressed 2K Film Finishing & Color Grading Suite",
			"role": "Online Flame Compositor & Digital Intermediate Artist",
			"software": "Discreet Flame / Inferno, SGI mediad, XLV Striped Volume Manager",
			"scenario": "Streaming uncompressed 10-bit Cineon film scans from a fibre-channel SCSI disk array through the Xbow crossbar directly into the V12 framebuffer with Guaranteed-Rate I/O (GRIO), performing real-time keyers and color warps for a summer blockbuster trailer."
		},
		{
			"title": "Molecular Dynamics & Protein Crystallography Stereo 3D Visualization",
			"role": "Computational Biochemist at a National Research Laboratory",
			"software": "VMD (Visual Molecular Dynamics), PyMOL, CrystalEyes LCD Shutter Glasses, MIPSpro F90",
			"scenario": "Wearing CrystalEyes active LCD shutter glasses synchronized to the Octane2's 3-pin mini-DIN stereo emitter port at 120Hz. The scientist inspects real-time electrostatic potential surfaces of an enzyme active site compiled with SGI's optimizing MIPSpro Fortran 90 compiler."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. SGI Octane2 in 'Skins' Deep Indigo-Blue with Sony Trinitron Monitor",
		"The iconic industrial design of the Octane2 cube with front-accessible XIO/SCSI sleds and granite SGI keyboard/mouse.",
		"Fig 2. IP30 Dual-R14000A CPU Module, HEART ASIC & Crossbow (Xbow) Switch Fabric",
		"Compression-connector XIO modules plugging directly into the midplane Crossbow switch without ribbon cables.",
		"Fig 3. IRIX 6.5 Indigo Magic Desktop with Top-Left Toolchest & gr_osview Telemetry",
		"Royal slate-blue 4Dwm chrome, italic Helvetica window headers, Toolchest cascading menus, and real-time CPU/GFX bars."
	)


static func _populate_beos_r5(p: OSProfile) -> void:
	p.exhibit_subtitle = "Jean-Louis Gassée's Pervasive SMP 'Media OS' on Dual Pentium III"
	p.era_classification = "Y2K Alternative Multimedia Operating System Era (March 2000)"
	p.historical_overview = (
		"BeOS Release 5 Professional Edition (5.0.3), released in March 2000 by Be Incorporated of Menlo Park, California, "
		+ "was the ultimate realization of Jean-Louis Gassée's vision for a 'Media OS.' At a time when Windows 98 SE ran on a "
		+ "cooperative 16/32-bit DOS heritage and Mac OS 9 lacked preemptive multitasking or protected memory, BeOS was written "
		+ "from scratch in C++ for symmetric multiprocessing (SMP), pervasive multithreading, 64-bit journaled database storage, "
		+ "and sub-millisecond digital audio/video latency."
	)
	p.historical_context = (
		"Founded in 1990 by former Apple executive Jean-Louis Gassée and Steve Sakoman, Be Inc. originally built the dual-PowerPC "
		+ "BeBox ('The GeekPort Machine') before porting BeOS to Power Macintoshes and finally x86 PCs in 1998. In late 1996, "
		+ "Apple famously considered acquiring BeOS to become the foundation of Mac OS X, before choosing Steve Jobs' NeXTSTEP "
		+ "instead. In 2000, Be Inc. released BeOS R5 Personal Edition as a free 45 MB download that could boot directly from a "
		+ "loopback file inside Windows 98, sparking a devoted cult following among musicians, 3D animators, and programmers."
	)
	p.engineering_innovations = (
		"• Pervasive Multithreading: Every single window in the Application Server ran in its own independent thread (one thread "
		+ "for drawing, one for user events). Even if an application deadlocked, its window could still be dragged smoothly across the screen.\n"
		+ "• 64-Bit Be File System (BFS): Engineered by Dominic Giampaolo and Cyril Meurillon, BFS was a 64-bit journaled filesystem "
		+ "with native indexed metadata attributes—turning the entire hard disk into a real-time relational query engine (e.g., "
		+ "live desktop folders showing all 'Audio/MP3' files where 'Artist == Nine Inch Nails').\n"
		+ "• Yellow Tabbed Window Chrome: Window titlebars were compact tabs that could be slid horizontally along the top border "
		+ "or stacked together by holding Option.\n"
		+ "• Lockless Media Kit: Allowed dual 800 MHz Pentium III processors to decode six simultaneous MPEG-1/AVI video streams "
		+ "while recording 16 tracks of 24-bit audio without a single dropped sample."
	)
	p.cultural_legacy = (
		"Though Be Inc. folded in 2001 (with its assets sold to Palm Inc.), the BeOS spirit proved immortal: Dominic Giampaolo "
		+ "went on to design Apple's Spotlight search and APFS filesystem, and the open-source **Haiku** project continues "
		+ "developing a binary-compatible successor to BeOS R5 to this day."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Be Incorporated (Menlo Park, CA) • Tyan Computer Corp.",
		"Release Date": "March 2000 (BeOS Release 5 Pro / Patch 5.0.3)",
		"System Model": "Tyan Tiger 100 (S1832DL) Dual-Slot 1 SMP Workstation",
		"Processor (CPU)": "Dual Intel Pentium III 800 MHz (Coppermine, 180nm, Slot 1 SECC2)",
		"Clock Rate & Cache": "2x 800 MHz SMP • 256 KB On-Die L2 per CPU • 100 MHz FSB",
		"Co-Processor / DSP": "Dual x87 FPU + SSE SIMD Media Instructions",
		"System Bus & Chipset": "Intel 440BX AGPset + PIIX4E Southbridge",
		"Memory (RAM)": "512 MB PC100 ECC SDRAM (4x 128 MB DIMMs)",
		"Graphics / Video": "Matrox Millennium G400 MAX 32 MB SGRAM (Hardware 2D/3D accelerant)",
		"Audio Subsystem": "Echo Gina20 / Sound Blaster Live! (BeOS Media Kit <2ms latency)",
		"Storage & Media": "40 GB IBM Deskstar 75GXP 7200 RPM Ultra ATA/66",
		"Operating System": "BeOS Release 5 Professional Edition (v5.0.3)",
		"Kernel & Filesystem": "BeOS SMP Micro-Modular Kernel • 64-Bit Journaled BFS",
		"GUI / Window System": "BeOS app_server • Tracker & Deskbar (Yellow Tabbed Chrome)",
		"Default Shell": "GNU bash 2.03 (/bin/bash in /boot/home)",
		"Original List Price": "BeOS R5 Pro: $69.95 USD (Personal Ed: Free) • PC: $1,950",
		"Predecessor": "BeOS R4.5 ('Genki', June 1999)",
		"Successor": "BeOS R5.1 'Dano' (Leaked 2001) / Haiku OS (Open Source)"
	}
	p.usage_cases = [
		{
			"title": "Low-Latency Multitrack Audio Recording & Real-Time DSP Synthesis",
			"role": "Electronic Musician & Project Studio Producer (2000)",
			"software": "3dmiX, SoundPlay, Cortex Media Routing Graph, Pulse (CPU Meter)",
			"scenario": "Routing live multi-channel audio nodes in 'Cortex' while mixing 24 spatialized stereo tracks in '3dmiX'. Both Pentium III CPU bars in the Deskbar's 'Pulse' applet dance in unison as the system plays four videos, formats a floppy disk, and renders audio filters simultaneously with zero crackles."
		},
		{
			"title": "Database-Driven Email & Contact Management via BFS Live Queries",
			"role": "Tech Journalist & Power User",
			"software": "BeMail, People, Tracker Find (BFS Attribute Query), NetPositive ('Net+')",
			"scenario": "Instead of storing emails in a monolithic database blob, 'BeMail' saves each message as an individual BFS file with indexed attributes (MAIL:from, MAIL:subject, MAIL:status). Opening a saved Tracker query folder instantly displays every unread message from the past week in under 5 milliseconds."
		},
		{
			"title": "Native C++ Multithreaded GUI Programming with the BeBook",
			"role": "Independent Shareware Developer for BeBits.com",
			"software": "Metrowerks CodeWarrior for BeOS, The BeBook HTML Docs, Terminal, StyledEdit",
			"scenario": "Writing a clean 150-line C++ application subclassing 'BApplication', 'BWindow', and 'BView'. Thanks to BeOS's object-oriented POSIX/C++ kits, the app compiles in two seconds and automatically gains multithreaded window redrawing and drag-and-drop replicant support."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. Tyan Tiger 100 Dual-Slot 1 Pentium III Tower & BeOS Retail Box",
		"Beige ATX workstation housing twin Slot 1 Pentium III cartridges built specifically to showcase BeOS SMP.",
		"Fig 2. Tyan S1832DL Dual-Slot 1 440BX Motherboard & Matrox G400 MAX",
		"Twin SECC2 Pentium III 800MHz modules side-by-side above the rock-solid Intel 440BX northbridge and AGP 2x slot.",
		"Fig 3. BeOS R5 Tracker Desktop with Yellow Window Tabs & Top-Right Deskbar",
		"Iconic #336698 BeOS blue desktop, partial-width bright yellow window title tabs, and the blue feather Deskbar menu."
	)


static func _populate_hpux_cde(p: OSProfile) -> void:
	p.exhibit_subtitle = "Enterprise PA-RISC 64-Bit Engineering & Common Desktop Environment (CDE)"
	p.era_classification = "Y2K Mission-Critical UNIX Engineering Workstation Era (2000)"
	p.historical_overview = (
		"The Hewlett-Packard Visualize C3600 running HP-UX 11i v1 (B.11.11) with the Common Desktop Environment (CDE 2.1) "
		+ "exemplifies turn-of-the-millennium industrial UNIX engineering. Powered by HP's proprietary 64-bit PA-8600 processor "
		+ "with a massive 1.5 MB of on-chip L1 cache (eliminating off-chip L2 latency altogether) and aVisualize FXe OpenGL "
		+ "accelerator, the C3600 was a fixture in aerospace finite-element analysis, semiconductor EDA chip layout, and "
		+ "telecommunications network management."
	)
	p.historical_context = (
		"In 1993, the major UNIX vendors—HP, Sun, IBM, and USL—united under the COSE (Common Open Software Environment) "
		+ "initiative to end the fragmented ' Look-and-Feel' wars between OpenLook and OSF/Motif. The result was CDE (Common "
		+ "Desktop Environment), heavily based on HP's own Visual User Environment (VUE). With its chiseled 3D Motif bevels, "
		+ "bottom-centered 'Front Panel' with four virtual workspace switches, and the System Administration Manager (SAM), "
		+ "HP-UX CDE became the visual archetype of serious corporate UNIX."
	)
	p.engineering_innovations = (
		"• PA-RISC 2.0 (PA-8600) On-Die Cache Architecture: Instead of a small L1 and slow external SRAM L2, HP engineered "
		+ "a massive 1.5 MB (512 KB Instruction / 1024 KB Data) 4-way set-associative cache directly on the CPU die running "
		+ "at full 552 MHz core speed.\n"
		+ "• HP Runway System Bus & Astro/Elroy ASICs: High-bandwidth 64-bit split-transaction processor bus bridged to "
		+ "multiple independent PCI buses for zero-bottleneck Ultra2 LVD SCSI and gigabit networking.\n"
		+ "• HP-UX 11i LVM & OnlineJFS (Veritas VxFS): Allowed enterprise administrators to extend logical volumes and resize "
		+ "journaled filesystems online while mission-critical databases remained under full load.\n"
		+ "• HP Visualize FXe Geometry Accelerator: Dedicated PA-RISC-optimized OpenGL pipeline for wireframe and shaded CAD assemblies."
	)
	p.cultural_legacy = (
		"HP-UX and the PA-RISC architecture earned a reputation for tank-like physical and software reliability—many C3600 "
		+ "workstations ran continuously in semiconductor fabs and power plants for over 15 years without a hardware failure. "
		+ "Its chiseled Motif/CDE interface remains an enduring aesthetic touchstone of 1990s/2000s enterprise UNIX."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Hewlett-Packard Company (Palo Alto, CA)",
		"Release Date": "December 2000 (HP-UX 11i v1 / C3600 Workstation)",
		"System Model": "HP 9000 Visualize C3600 (Model 9000/785)",
		"Processor (CPU)": "HP PA-RISC 8600 (64-bit PA-RISC 2.0 4-Way Superscalar)",
		"Clock Rate & Cache": "552 MHz • 1.5 MB On-Die L1 Cache (512 KB I + 1 MB D)",
		"Co-Processor / DSP": "Dual On-Die Pipelined IEEE-754 Floating-Point Units",
		"System Bus & Chipset": "HP Runway 2.0 GB/s Bus • Astro Memory Controller + 4x Elroy PCI",
		"Memory (RAM)": "2048 MB ECC Registered SDRAM (Expandable to 8 GB)",
		"Graphics / Video": "HP Visualize-FXe PCI/AGP (24-bit OpenGL Hardware Geometry)",
		"Audio Subsystem": "Crystal CS4299 16-bit Workstation Audio + Internal Speaker",
		"Storage & Media": "2x 18.2 GB Seagate Ultra2 LVD SCSI (10,000 RPM) + 32x SCSI CD-ROM",
		"Operating System": "HP-UX 11i v1 (Release B.11.11 • 64-Bit Mode)",
		"Kernel & Filesystem": "/stand/vmunix Dynamic Kernel • Veritas VxFS (JFS) + HP LVM",
		"GUI / Window System": "X11R6 • OSF/Motif 2.1 • Common Desktop Environment (CDE 2.1)",
		"Default Shell": "HP-UX POSIX Shell (/usr/bin/sh) & KornShell (ksh)",
		"Original List Price": "$14,800 USD (Configured with 21\" HP P1110 Trinitron CRT)",
		"Predecessor": "HP Visualize C3000 / HP-UX 11.00 (1997–1999)",
		"Successor": "HP Visualize C8000 (PA-8800/8900) & HP Integrity (Itanium)"
	}
	p.usage_cases = [
		{
			"title": "Aerospace Turbine Blade Structural & Thermal FEA Simulation",
			"role": "Senior Mechanical Stress Analyst at an Aviation Propulsion Division",
			"software": "PTC Pro/ENGINEER 2000i2, ANSYS 5.7, HP-UX CDE dtterm, GlancePlus",
			"scenario": "Swapping between CDE workspaces 'One' and 'Two' on the bottom Front Panel. Workspace One holds a shaded 3D turbine assembly in Pro/ENGINEER on the Visualize-FXe card; Workspace Two runs an ANSYS 64-bit finite-element solver consuming 1.8 GB of ECC RAM while 'glance' monitors PA-8600 floating-point utilization."
		},
		{
			"title": "VLSI Microprocessor Layout & DRC Verification in Semiconductor Fab",
			"role": "IC Physical Design Engineer",
			"software": "Cadence Virtuoso IC, Synopsys Design Compiler, Mentor Calibre, RCS",
			"scenario": "Inspecting multi-million-transistor 180nm CMOS metal routing layers over X11 while submitting batch Design Rule Check (DRC) jobs to a rack of HP 9000 N-Class compute servers."
		},
		{
			"title": "Enterprise SAN & Logical Volume Administration via HP SAM",
			"role": "Senior UNIX Systems Administrator",
			"software": "SAM (System Administration Manager), ioscan, lvextend, swinstall",
			"scenario": "Hot-plugging a new Ultra2 LVD SCSI drive into the C3600 bay, running 'ioscan -fnC disk' to detect hardware paths without rebooting, and using the Motif-based 'sam' utility to extend '/dev/vg00/lvol3' live."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. HP 9000 Visualize C3600 Deskside Workstation in Dark Quartz Gray",
		"Industrial deskside chassis featuring status LCD panel on the front bezel and HP P1110 21-inch CRT.",
		"Fig 2. PA-RISC 8600 Ceramic LGA Module with 1.5MB On-Die Cache & Astro ASIC",
		"Massive ceramic processor module topped by a machined aluminum pin-fin heatsink and quad Elroy PCI bridges.",
		"Fig 3. HP-UX 11i Common Desktop Environment (CDE) with Motif Bevels & Front Panel",
		"Classic slate-teal workspace, salmon-coral active Motif window borders, and the bottom-docked CDE Front Panel."
	)


static func _populate_redhat_62(p: OSProfile) -> void:
	p.exhibit_subtitle = "The Dot-Com Boom Linux Standard with GNOME 1.0 & Enlightenment E16"
	p.era_classification = "Y2K Commercial Linux IPO & Early GNOME Desktop Era (March 2000)"
	p.historical_overview = (
		"Red Hat Linux 6.2 ('Zoot'), released in March 2000 at the absolute peak of the dot-com stock market euphoria, was "
		+ "the definitive Linux release of the turn of the millennium. Coming just months after Red Hat's historic August 1999 "
		+ "Wall Street IPO—and the founding of VA Linux Systems—Red Hat 6.2 paired the rock-solid Linux 2.2.14 kernel with "
		+ "GNOME 1.0.55 and Rasterman's futuristic, metallic-skinned **Enlightenment 0.15.5 (E16)** window manager."
	)
	p.historical_context = (
		"In 1999–2000, the Linux desktop underwent a dramatic transformation. Previously dominated by plain fvwm2 or twm "
		+ "configs, Red Hat invested heavily in Red Hat Advanced Development Labs (RHAD Labs) alongside Miguel de Icaza's "
		+ "GNOME project and Carsten 'Rasterman' Haitzler. Red Hat 6.2 boxed sets were sold on the shelves of CompUSA, Best Buy, "
		+ "and Borders Books. Meanwhile, in server rooms everywhere, Red Hat 6.2 became the standard baseline image for "
		+ "first-generation rackmount Linux clusters."
	)
	p.engineering_innovations = (
		"• Linux 2.2.14 SMP Kernel:Removed the single global Big Kernel Lock around networking and interrupts, making dual-CPU "
		+ "Pentium II/III workstations and Apache web servers scale efficiently.\n"
		+ "• RPM 3.0.4 (Red Hat Package Manager): Atomic binary and source package installation with cryptographic PGP signatures "
		+ "and dependency tracking—ending 'tarball dependency hell' for commercial software vendors like Oracle 8i and Loki Games.\n"
		+ "• GNOME 1.0 + Enlightenment (BlueSteel / BrushedMetal): Combined GTK+ 1.2 panel applets and the Midnight Commander "
		+ "(gmc) file manager with Enlightenment's alpha-blended, bevel-plated sci-fi window decorations.\n"
		+ "• Kudzu Hardware Probing & Linuxconf: Automatically detected newly inserted PCI sound and Ethernet cards during boot."
	)
	p.cultural_legacy = (
		"Red Hat Linux 6.2 was so stable and beloved by enterprise customers that when Red Hat later transitioned from consumer "
		+ "boxed sets to **Red Hat Enterprise Linux (RHEL)** in 2002, the very first RHEL release (RHEL 2.1) was built directly "
		+ "on the heritage established by the 6.2/7.2 series. Its brushed-metal Enlightenment desktop remains an icon of Y2K cyber-aesthetics."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Red Hat, Inc. (Durham, NC) • VA Linux Systems",
		"Release Date": "March 27, 2000",
		"System Model": "VA Linux 500 / Custom Dual-Slot 1 Intel 440BX Tower",
		"Processor (CPU)": "Dual Intel Pentium II 400 MHz (Deschutes, 250nm, Slot 1)",
		"Clock Rate & Cache": "2x 400 MHz SMP • 512 KB Half-Speed L2 Cache per CPU • 100 MHz FSB",
		"Co-Processor / DSP": "Dual Integrated x87 FPU + MMX Technology",
		"System Bus & Chipset": "Intel 440BX AGPset • 100 MHz Front Side Bus",
		"Memory (RAM)": "256 MB PC100 SDRAM",
		"Graphics / Video": "NVIDIA RIVA TNT2 Ultra 32 MB AGP (XFree86 3.3.6 SVGA Server)",
		"Audio Subsystem": "Creative Sound Blaster AWE64 Gold ISA (OSS sound.o driver)",
		"Storage & Media": "13.6 GB Western Digital Expert 7200 RPM IDE (hda) + 40x CD-ROM",
		"Operating System": "Red Hat Linux release 6.2 (Codename: 'Zoot')",
		"Kernel & Filesystem": "Linux 2.2.14-5.0smp (i686) • ext2 Filesystem • LILO 21.4",
		"GUI / Window System": "XFree86 3.3.6 • GNOME 1.0.55 + Enlightenment 0.15.5",
		"Default Shell": "GNU bash 1.14.7 ([root@zoot /root]#)",
		"Original List Price": "$39.95 USD (Standard Retail Box) / $79.95 Deluxe Workstation",
		"Predecessor": "Red Hat Linux 6.1 (Cartman, October 1999)",
		"Successor": "Red Hat Linux 7.0 (Guinness, September 2000)"
	}
	p.usage_cases = [
		{
			"title": "Y2K Open-Source Hacker Desktop — Slashdot, XMMS & Quake III Arena",
			"role": "Linux Enthusiast & University Lab Sysadmin (Spring 2000)",
			"software": "Enlightenment E16, GNOME Midnight Commander, XMMS, Netscape 4.72, Quake III Linux",
			"scenario": "Reading 'News for Nerds' on Slashdot in Netscape Communicator 4.72 while XMMS plays MP3s with an OpenGL spectrum analyzer plugin. After compiling the NVIDIA GLX module, the user launches Loki Games' native Linux port of Quake III Arena at 1024x768."
		},
		{
			"title": "Dot-Com Startup Web & Mail Infrastructure Setup",
			"role": "Lead Systems Engineer at a Year-2000 Internet Startup",
			"software": "Apache 1.3.12, Sendmail 8.9.3, MySQL, linuxconf, ipchains, RPM",
			"scenario": "Provisioning a freshly unboxed VA Linux rack server via LILO, configuring virtual hosts in '/etc/httpd/conf/httpd.conf', setting up packet filtering rules with 'ipchains', and verifying installed RPM packages with 'rpm -qa'."
		},
		{
			"title": "GTK+ & C Application Development with Glade & Emacs",
			"role": "Free Software Contributor on SourceForge.net",
			"software": "GNU Emacs 20.5, Glade GUI Builder, egcs-2.91.66 (GCC), CVS, GDB",
			"scenario": "Designing a new GNOME panel applet in Glade, compiling C source code with 'egcs', and committing patches over SSH to a newly hosted SourceForge.net CVS repository."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. VA Linux / Custom Dual Pentium II Tower & Red Hat 6.2 'Shadowman' Box",
		"Classic beige ATX full-tower adorned with a 'Powered by Red Hat Linux' badge alongside the retail boxed set.",
		"Fig 2. Dual Intel Pentium II 400MHz Slot 1 Cartridges, RIVA TNT2 & AWE64 Gold ISA",
		"Transition-era PC architecture combining AGP 2x graphics, PCI 10/100 3Com 3c905B Ethernet, and a full-length ISA sound card.",
		"Fig 3. GNOME 1.0 & Enlightenment E16 'BrushedMetal' Desktop with Footprint Panel",
		"Sci-fi metallic window frames, GNOME Midnight Commander desktop icons, and the iconic bottom Footprint menu bar."
	)


static func _populate_solaris_8(p: OSProfile) -> void:
	p.exhibit_subtitle = "Sun Microsystems' Dot-Com Powerhouse ('The Network Is The Computer')"
	p.era_classification = "Y2K Enterprise 64-Bit SPARC Workstation & Server Era (February 2000)"
	p.historical_overview = (
		"At the turn of the millennium, Sun Microsystems was the undisputed king of Internet infrastructure, captured by its "
		+ "famous slogan: 'We're the dot in .com.' The Sun Ultra 60 workstation—powered by dual 64-bit 450 MHz UltraSPARC II "
		+ "processors, Sun Creator3D UPA graphics, and running Solaris 8 (SunOS 5.8)—was the flagship deskside system for "
		+ "Java enterprise architects, Wall Street quantitative trading desks, and EDA chip designers."
	)
	p.historical_context = (
		"Released in February 2000, Solaris 8 was one of Sun Microsystems' most successful and enduring operating system "
		+ "releases. Following the transition from BSD-based SunOS 4.x to SVR4-based Solaris 2.x in the 1990s, Solaris 8 "
		+ "delivered a mature 64-bit SPARCv9 kernel, native IPv6 support, an improved high-scalability multithreading library "
		+ " enabling massive Java 2 Enterprise Edition (J2EE) workloads, and the signature purple-and-lavender Sun CDE 1.4 desktop."
	)
	p.engineering_innovations = (
		"• OpenBoot PROM 3.31 (Forth Interpreter): Sun's legendary firmware environment ('ok' prompt) with built-in Forth "
		+ "scripting, hardware device tree inspection ('show-devs', 'probe-scsi-all'), and network boot ('boot net') before "
		+ "the OS kernel even loads.\n"
		+ "• UltraSPARC II (SPARC V9) + VIS SIMD: 64-bit RISC processor with Visual Instruction Set (VIS) multimedia extensions "
		+ "connected via the 1.6 GB/s UPA (Ultra Port Architecture) packet-switched bus.\n"
		+ "• Sun Creator3D Series 3 (FFB2+): Dedicated UPA graphics card with 3DRAM—a revolutionary memory chip that integrated "
		+ "Z-buffer compare and alpha-blending logic cells directly inside the DRAM silicon.\n"
		+ "• Solaris 8 Kernel & procfs Tools: Pioneered rich process introspection utilities ('ptree', 'pfiles', 'pmap', 'truss') "
		+ "and UFS filesystem logging."
	)
	p.cultural_legacy = (
		"The Sun Ultra 60—with its distinctive purple Solaris sunburst badge, Type 6 optical keyboard with dedicated Stop-A "
		+ "(L1-A) and Compose keys, and 3-button optical mouse—represents the height of Sun Microsystems' hardware-software "
		+ "integration prior to the 2001 dot-com crash and the eventual Oracle acquisition in 2010."
	)
	p.technical_specs = {
		"Manufacturer / Vendor": "Sun Microsystems, Inc. (Palo Alto / Santa Clara, CA)",
		"Release Date": "February 2000 (Solaris 8 02/00 • Ultra 60 introduced 1998)",
		"System Model": "Sun Ultra 60 (sun4u Architecture • Dual-UPA Deskside)",
		"Processor (CPU)": "Dual Sun UltraSPARC II (64-bit SPARC V9 RISC + VIS)",
		"Clock Rate & Cache": "2x 450 MHz SMP • 32 KB L1 + 4 MB External SRAM E-Cache per CPU",
		"Co-Processor / DSP": "Dual On-Die IEEE-754 FPU + VIS 64-bit Media Instructions",
		"System Bus & Chipset": "Sun UPA (Ultra Port Architecture 112.5 MHz) + Psycho Dual-PCI",
		"Memory (RAM)": "2048 MB 50ns ECC Buffered EDO DIMMs (576-bit wide 4-way interleave)",
		"Graphics / Video": "Sun Creator3D Series 3 (FFB2+ UPA • 15 MB 3DRAM • 24-bit + Z)",
		"Audio Subsystem": "Sun CS4231 16-bit EB2 DMA Audio (/dev/audio) + Type 6 Bell",
		"Storage & Media": "2x 36.4 GB Seagate UltraSCSI (10,000 RPM) on dual glm0/glm1",
		"Operating System": "Sun Solaris 8 (SunOS 5.8 • 64-Bit sparcv9 Kernel)",
		"Kernel & Filesystem": "/platform/sun4u/kernel/sparcv9/unix • UFS with Logging",
		"GUI / Window System": "Xsun X11R6.4 • Sun CDE 1.4 / OpenWindows 3.6.2",
		"Default Shell": "SunOS Bourne Shell (/sbin/sh) & C Shell (/bin/csh)",
		"Original List Price": "$18,995 USD (Dual 450MHz, 2GB RAM, Creator3D & 21\" Sony CRT)",
		"Predecessor": "Sun Solaris 7 (November 1998) / Sun Ultra 30",
		"Successor": "Sun Solaris 9 (2002) & Solaris 10 (ZFS / DTrace, 2005)"
	}
	p.usage_cases = [
		{
			"title": "Wall Street Fixed-Income Trading Desk & Real-Time Risk Engine",
			"role": "Quantitative Financial Developer & Desk Strategist (2000)",
			"software": "Sun Forte C++ 6.0, Java 2 SDK 1.3 (HotSpot), Sybase ASE, Sun CDE, Applixware",
			"scenario": "Driving dual 21-inch Sun Sony Trinitron monitors on a Manhattan trading floor. Custom Motif/X11 pricing blotters stream live Reuters market ticks over UltraSPARC II SMP threads while HotSpot JVM engines calculate real-time bond yield curves."
		},
		{
			"title": "Enterprise J2EE Architecture & Sun Enterprise 10000 ('Starfire') Administration",
			"role": "Principal Solaris Infrastructure Architect",
			"software": "dtterm, truss, prstat, sar, iostat, Solstice DiskSuite, WebLogic Server",
			"scenario": "Using the Ultra 60 as an administration console for a 64-processor Sun Enterprise E10000 server domain. The architect inspects live system calls with 'truss -p', monitors per-CPU run queues with 'mpstat 2', and tests OpenBoot failover paths via Stop-A."
		},
		{
			"title": "SPARC Microprocessor RTL Simulation & EDA Verification",
			"role": "Senior Silicon Verification Engineer",
			"software": "Verilog-XL, Synopsys VCS, Sun WorkShop Visual Debugger, FrameMaker 5.5",
			"scenario": "Simulating millions of clock cycles of next-generation SPARCv9 RTL logic across the 576-bit interleaved ECC memory bus, while authoring architectural specifications in Adobe FrameMaker 5.5 on CDE."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. Sun Ultra 60 Tower with Purple Badge, Type 6 Keyboard & 21\" Sony CRT",
		"Putty-gray and violet Sun industrial design by Frog Design, paired with the Type 6 UNIX layout keyboard.",
		"Fig 2. Sun Ultra 60 System Board, Dual 450MHz UltraSPARC II Modules & Creator3D UPA",
		"Twin UltraSPARC II ceramic modules with 4MB external SRAM caches and the vertical Creator3D 3DRAM UPA card.",
		"Fig 3. Solaris 8 CDE 1.4 Desktop with Sun Lavender/Teal Palette & OpenBoot Console",
		"Signature Sun purple/teal CDE workspace, chiseled Front Panel, and dtterm running prtconf and psrinfo."
	)


# ==============================================================================
# 10. UBUNTU 10.04 LTS (LUCID LYNX) - APRIL 2010
# THE ALEXNET WORKSTATION (2012) & THE PARADIGM SHIFT TO MODERN GPU AI
# ==============================================================================
static func _populate_ubuntu_1004(p: OSProfile) -> void:
	p.exhibit_subtitle = "Canonical's Ambiance Redesign, Impending Move to Unity & The AlexNet AI Hardware Zero-Point (2012)"
	p.era_classification = "Dawn of the Modern Deep Learning & GPU Compute Age (2010–2012)"
	p.historical_overview = (
		"Ubuntu 10.04 LTS ('Lucid Lynx') marks the historical boundary between vintage, CPU-bound interactive personal "
		+ "computing and the modern era of massive parallel GPU compute and artificial intelligence. Released on April 29, 2010 "
		+ "by Canonical Ltd., Lucid Lynx was celebrated as the pinnacle of the classic GNOME 2 desktop, introducing Canonical's "
		+ "dramatic 'Light: Soft Software' visual redesign with the dark aubergine 'Ambiance' theme and the controversial relocation "
		+ "of window controls to the top-left—a calculated architectural maneuver preparing the community for the impending arrival "
		+ "of the vertical Unity shell in 10.10 and 11.04. In 2011–2012, a contemporary low-overhead Linux environment of this era served as "
		+ "the operating foundation for the 'AlexNet' workstation assembled by University of Toronto researchers Alex Krizhevsky, "
		+ "Ilya Sutskever, and Geoffrey Hinton, whose groundbreaking dual-GPU deep convolutional neural network shattered the ImageNet "
		+ "computer vision benchmark and sparked the global artificial intelligence revolution. Crucially, while the dual 3GB NVIDIA "
		+ "GeForce GTX 580 graphics cards are documented historical fact, the remainder of the workstation's hardware and host specifications "
		+ "were never formally recorded in academic literature and are inferred from what would have likely been assembled at the time, "
		+ "unless Alex, Ilya, or Geoff eventually confirm what it ran on."
	)
	p.historical_context = (
		"The historical significance of Ubuntu 10.04 LTS bridges two pivotal revolutions in computing history:\n\n"
		+ "1. THE AMBIANCE REDESIGN & THE IMPENDING MOVE TO UNITY:\n"
		+ "In early 2010, Canonical founder Mark Shuttleworth unveiled a bold new brand identity for Ubuntu entitled 'Light'. "
		+ "Departing from the warm brown 'Human' palette that had defined Ubuntu since 4.10, 10.04 introduced 'Ambiance'—a sleek, "
		+ "dark charcoal-and-aubergine aesthetic accented with vibrant orange. Most controversially, Canonical moved window control buttons "
		+ "(close, minimize, maximize) from the top-right to the top-left corner. While fiercely debated by longtime UNIX desktop users, "
		+ "this change was an intentional spatial precursor to Unity—Canonical's bespoke desktop shell designed to maximize vertical screen "
		+ "real estate on netbooks and widescreen monitors by combining titlebars, global menu bars, and a vertical left-hand launcher dock. "
		+ "Lucid Lynx would stand as the final Long Term Support release powered by classic GNOME 2.30, remembered fondly as one of the most "
		+ "polished, rock-solid desktop operating systems ever created.\n\n"
		+ "2. THE ALEXNET WORKSTATION (2012) — THE HARDWARE ZERO-POINT OF MODERN AI:\n"
		+ "While modern AI infrastructure depends on hyperscale tensor server farms consuming megawatts of power, the modern deep learning "
		+ "revolution was born on a single consumer-grade desktop computer running in a University of Toronto laboratory. Assembled by "
		+ "Alex Krizhevsky, Ilya Sutskever, and pioneer Geoffrey Hinton, this enthusiast PC was engineered to train a deep convolutional "
		+ "neural network (CNN) for the 2012 ImageNet Large Scale Visual Recognition Challenge (ILSVRC). For decades, artificial neural "
		+ "networks had been dismissed by the academic establishment as computationally intractable. The U of T team recognized that modern "
		+ "gaming GPUs, designed for high-throughput floating-point polygon rasterization, could be repurposed as massive parallel matrix engines.\n\n"
		+ "3. THE LINUX/CUDA SOFTWARE STACK & CUDA-CONVNET:\n"
		+ "The unsung foundation of this breakthrough was its operating environment: Ubuntu 10.04 LTS. In 2011 and 2012, pushing the boundaries "
		+ "of NVIDIA's CUDA toolkit demanded a frictionless, low-latency, bare-metal environment. Microsoft Windows was fundamentally "
		+ "unsuited for the granular, custom C++ memory management and low-overhead PCIe peer-to-peer DMA streaming necessary to parallelize "
		+ "a massive 60-million parameter neural network. Ubuntu provided the lightweight stability and direct kernel memory access that allowed "
		+ "Alex Krizhevsky to write 'cuda-convnet'—his legendary custom C++/CUDA framework featuring hand-tuned assembly matrix multiplication "
		+ "kernels. By eliminating operating system background bloat, Ubuntu dedicated virtually 100% of the machine's memory bandwidth and "
		+ "CPU cycles to feeding the voracious GPU data pipeline.\n\n"
		+ "4. MODEL PARALLELISM ACROSS DUAL FERMI GPUS & THE PARADIGM SHIFT:\n"
		+ "Because the 60-million parameter network and its 650,000 neurons could not physically fit into the 3GB GDDR5 VRAM of a single card, "
		+ "Krizhevsky ingeniously split the architecture across two NVIDIA GeForce GTX 580 GPUs utilizing the 40nm 'Fermi' microarchitecture. "
		+ "One GPU processed the top half of the network while the second processed the bottom half, with the cards synchronizing activations "
		+ "only at specific convolutional layers (Conv2, Conv4, Conv5, and FC6). A high-end 6-core Intel Core i7 processor ran on-the-fly data "
		+ "augmentation—generating random 224x224 crops, horizontal reflections, and PCA color shifts from the 1.2 million ImageNet JPEGs before "
		+ "streaming them across PCIe 2.0 buses. Running continuously at full 244W TDP per card for five to six days across 90 epochs, the rig "
		+ "achieved over 2,200 forward passes per second. When the ILSVRC 2012 results were published, AlexNet achieved a top-5 test error rate "
		+ "of 15.3%—obliterating the second-place traditional computer vision model (26.2%) by an unprecedented 10.9 percentage points. "
		+ "This single Ubuntu-powered workstation catalyzed the worldwide transition away from manual feature extraction to end-to-end "
		+ "deep learning, fundamentally launching the modern age of computing.\n\n"
		+ "5. HISTORICAL ACCURACY & RECONSTRUCTED SPECIFICATIONS:\n"
		+ "In their landmark 2012 paper ('ImageNet Classification with Deep Convolutional Neural Networks', NeurIPS 2012), "
		+ "Alex Krizhevsky, Ilya Sutskever, and Geoffrey Hinton explicitly documented their graphics configuration: two NVIDIA GeForce "
		+ "GTX 580 GPUs with 3GB of GDDR5 memory per card, communicating via direct cross-GPU peer-to-peer DMA over PCIe. "
		+ "However, the researchers never published a formal Bill of Materials (BOM) for the rest of the computer. Besides the graphics cards, "
		+ "the remainder of the workstation's components—including the specific motherboard, central processor (CPU), chassis, power supply, "
		+ "system RAM capacity, and even the exact Linux distribution and kernel revision—are historically unknown. Computing historians "
		+ "and technical archivists reconstruct these specifications from the strict operational constraints of the workload: housing two 244-watt "
		+ "Fermi GPUs under 100% continuous load required an SLI-capable enthusiast motherboard (e.g., Intel X58 or X79), a high-wattage power supply "
		+ "(1000W+), a high-clock multi-core CPU capable of real-time image cropping and PCA color jittering without starving the GPUs, and a "
		+ "lightweight, developer-friendly Linux distribution like Ubuntu (10.04 or 12.04 LTS) for Krizhevsky to write and compile cuda-convnet. "
		+ "This exhibit represents the most period-accurate reconstruction possible, inferred from what would have likely been used at the University "
		+ "of Toronto in 2011–2012, unless Alex, Ilya, or Geoff eventually confirm the exact hardware and software manifest it ran on."
	)
	p.engineering_innovations = (
		"• Model-Parallel Multi-GPU Deep Learning: First successful multi-GPU parallelization of a deep convolutional neural network, "
		+ "splitting 60 million parameters and 650,000 neurons across two 3GB NVIDIA GeForce GTX 580 GPUs via PCIe peer-to-peer DMA.\n"
		+ "• Alex Krizhevsky's 'cuda-convnet': Groundbreaking custom CUDA C++ framework featuring hand-crafted assembly matrix multiplication "
		+ "and 2D convolution routines running at near-theoretical hardware throughput on NVIDIA Fermi streaming multiprocessors.\n"
		+ "• Rectified Linear Units (ReLU) & Dropout Regularization: Replaced slow saturating tanh/sigmoid activation functions with non-saturating "
		+ "f(x) = max(0, x), accelerating gradient descent training speed by 600% while dropout prevented complex co-adaptations.\n"
		+ "• Real-Time CPU Data Augmentation Pipeline: Offloaded on-the-fly random 224x224 image cropping, horizontal flipping, and PCA color "
		+ "jittering to the multi-core Intel Core i7 host CPU, preventing GPU starvation across 1,281,167 ImageNet training images.\n"
		+ "• Ubuntu 10.04 LTS 'Ambiance' & The Path to Unity: Canonical's iconic dark aubergine visual identity, relocated left-side window "
		+ "controls, Plymouth kernel boot splash, and the final Long Term Support release of classic GNOME 2."
	)
	p.cultural_legacy = (
		"The Ubuntu 10.04 AlexNet workstation stands as the monumental bridge between the historical computer museum "
		+ "and the modern technological era. In 1972, the Datapoint 2200 proved that computing "
		+ "power belonged on an individual operator's desk; exactly 40 years later in 2012, this Ubuntu workstation proved that off-the-shelf "
		+ "consumer graphics hardware and open-source Linux could breathe cognitive life into deep artificial neural networks—igniting "
		+ "the generative AI, computer vision, and large language model revolution that defines our modern world."
	)
	p.technical_specs = {
		"Hardware Provenance": "Dual GTX 580 GPUs Confirmed; Host Build Inferred (Pending Author Confirmation)",
		"Manufacturer / Vendor": "Canonical Ltd. / Custom University of Toronto AI Build",
		"Release Date": "April 2010 (Ubuntu 10.04 LTS • AlexNet trained 2011–2012)",
		"System Model": "AlexNet Deep Learning Workstation (Historical Enthusiast Reconstruction)",
		"Processor (CPU)": "Intel Core i7-3930K (Inferred Period-Correct 6C/12T @ 3.20GHz, 3.80GHz Turbo)",
		"Clock Rate & Cache": "3.20 GHz Base Clock • 12 MB SmartCache • 32nm Sandy Bridge-E",
		"Co-Processor / GPUs": "2× NVIDIA GeForce GTX 580 (512 CUDA Cores, 1.54GHz, Fermi GF110) [Confirmed]",
		"System Bus & Chipset": "Intel X79 Express • 40 PCIe 2.0 Lanes • Direct GPU-to-GPU DMA",
		"Memory (RAM)": "16 GB DDR3-1600 (Inferred Quad-Channel Interleaved • 25.6 GB/s Bandwidth)",
		"Graphics Memory (VRAM)": "6 GB Total GDDR5 (3 GB per GPU • 384-bit Bus • 192.4 GB/s per Card) [Confirmed]",
		"Audio Subsystem": "Realtek ALC898 8-Channel High Definition Audio • Ubuntu Marimba Chime",
		"Storage & Media": "1 TB Western Digital Caviar Black (Inferred 7200 RPM SATA • 27GB ImageNet)",
		"Power Supply (PSU)": "1200W Enthusiast 80+ Gold (Inferred for Dual 244W TDP GPUs)",
		"Operating System": "Ubuntu 10.04.4 LTS (Inferred Contemporary Low-Overhead Linux Host)",
		"Kernel & Toolchain": "Linux 2.6.32-21-generic • GCC 4.4.3 • NVIDIA Driver 295.40 • CUDA 4.2",
		"GUI / Window System": "GNOME 2.30.2 Desktop • Ambiance GTK Theme (Left-Side Window Controls)",
		"Default Shell": "GNU bash 4.1.5 (`alex@alexnet-node0:~/cuda-convnet$ `)",
		"Original Build Cost": "Approx. $2,800 USD in 2011–2012 (Consumer Off-the-Shelf Enthusiast Parts)",
		"Predecessor": "Ubuntu 9.10 ('Karmic Koala') / Traditional CPU Hand-Crafted Vision (SIFT)",
		"Successor": "Ubuntu 10.10 (Unity Netbook) / Ubuntu 11.04 (Unity Desktop) & Modern AI Clusters"
	}
	p.usage_cases = [
		{
			"title": "Training the 60-Million Parameter AlexNet CNN on ILSVRC 2012 ImageNet",
			"role": "Alex Krizhevsky & Ilya Sutskever (University of Toronto Machine Learning Group)",
			"software": "cuda-convnet (Custom C++/CUDA), NVIDIA CUDA 4.2 Toolkit, Python 2.7, NumPy",
			"scenario": "Launching 'python convdata.py' inside an Ubuntu 10.04 GNOME terminal. The dual GeForce GTX 580 GPUs spin up to 100% fan speed, consuming nearly 500 watts of power as they process 2,240 images per second. After six days of continuous computation, the top-5 error rate converges at an unprecedented 15.3%, stunning the computer vision community."
		},
		{
			"title": "Writing, Compiling & Benchmarking cuda-convnet in Ubuntu 10.04",
			"role": "Senior CUDA Systems & Kernel Programmer",
			"software": "GCC 4.4.3, NVIDIA NVCC Compiler, CUDA Driver 295.40, GDB Debugger",
			"scenario": "Writing hand-optimized PTX assembly matrix multiplication routines and custom cross-GPU peer-to-peer synchronization code. Ubuntu's lightweight kernel and low memory footprint allow direct, uninhibited interaction with NVIDIA's unified virtual memory addressing and PCIe 2.0 DMA controllers."
		},
		{
			"title": "The Ubuntu 10.04 LTS Desktop & The Impending Transition to Unity",
			"role": "Canonical Community Contributor & Linux Desktop Architect (2010)",
			"software": "GNOME 2.30.2, Ambiance GTK Theme, Metacity Window Manager, Ubuntu Software Center",
			"scenario": "Customizing the new 'Ambiance' desktop, adapting to window close buttons situated on the top-left, and testing early prototype builds of the Clutter-based Unity shell on netbooks prior to its full desktop rollout in Ubuntu 11.04."
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. AlexNet Dual-GTX 580 Enthusiast Workstation Tower & 24\" Widescreen LCD",
		"High-airflow ATX full-tower chassis with side acrylic panel revealing twin dual-slot NVIDIA GeForce GTX 580 graphics cards.",
		"Fig 2. Intel X79 Motherboard, LGA2011 CPU, Quad-Channel DDR3 & Dual-GPU SLI PCIe Bus",
		"Enthusiast motherboard architecture detailing the direct PCIe root complex lines and peer-to-peer DMA bridge between the two Fermi GPUs.",
		"Fig 3. Ubuntu 10.04 LTS Ambiance Desktop: Left Window Controls & cuda-convnet Terminal",
		"Signature dark aubergine GNOME 2.30 desktop featuring left-hand window controls and terminal output tracking AlexNet training loss."
	)


# ==============================================================================
# 11. EVGA SR-2 "SUPER RECORD" TRIPLE-BOOT WORKSTATION - LATE 2011
# THE PINNACLE AND FIERY TWILIGHT OF BRUTE-FORCE ENTHUSIAST COMPUTING
# ==============================================================================
static func _populate_evga_sr2(p: OSProfile) -> void:
	p.exhibit_subtitle = "The Super Record HPTX Platform, FirePro S400 24-Screen Genlock & The Fiery Twilight of Brute-Force Computing"
	p.era_classification = "Enthusiast Overclocking Zenith & Fiery Twilight of Brute-Force Multi-Socket Computing (Late 2011)"
	p.historical_overview = (
		"The EVGA SR-2 'Super Record' Triple-Boot Workstation is a featured exhibit in the digital computer museum, "
		+ "representing the absolute pinnacle—and the fiery twilight—of enthusiast desktop computing in late 2011. "
		+ "Built around the legendary EVGA Classified SR-2 motherboard, this system demonstrates the rare convergence "
		+ "of enterprise-grade server hardware with extreme overclocking capabilities and multi-OS versatility. "
		+ "This specific configuration highlights a notoriously complex triple-boot environment, utilizing distinct physical "
		+ "solid-state drives to run Windows 7 Ultimate SP1, Mac OS X 10.7 Lion (via 'Hackintosh' bootloaders), and Oracle "
		+ "Solaris 11. Housed in a massive black aluminum Lian Li HPTX full-tower chassis and historically paired with dual "
		+ "27-inch professional color-calibrated IPS monitors alongside a high-powered 24-screen synchronized video wall, "
		+ "it functioned as an unprecedented computing monolith capable of dominating any consumer, scientific, or enterprise "
		+ "visualization workload of the era."
	)
	p.historical_context = (
		"The historical significance of the EVGA Classified SR-2 workstation encompasses four monumental hardware paradigms:\n\n"
		+ "1. THE END OF THE BRUTE-FORCE ERA & THE EFFICIENCY REVOLUTION:\n"
		+ "While the SR-2 reigned supreme for extreme overclockers, it also represented the end of an era characterized by "
		+ "high-powered workstations producing ridiculous amounts of heat. The dual 32nm Westmere-EP processors and quad-GPU "
		+ "configurations required staggering power draw—often necessitating dual 1200W power supplies just to keep the system "
		+ "stable under load and turning the chassis into a space heater. The impending launch of Intel’s 2nd-generation "
		+ "Sandy Bridge-E architecture in November 2011 signaled a fundamental shift in hardware design. As processor lithography "
		+ "technology advanced to 32nm and subsequently 22nm (Ivy Bridge), future architectures became drastically more power-efficient. "
		+ "This relentless push for efficiency over raw thermal output set the stage for massive industry disruptions. AMD’s eventual "
		+ "Ryzen and Threadripper lines would go on to democratize massive core counts on single, highly efficient consumer motherboards, "
		+ "eliminating the need for complex dual-socket server workarounds. Similarly, the heat and power limitations of Intel’s older "
		+ "architectures ultimately drove Apple to abandon Intel entirely, transitioning to their remarkably power-efficient, ARM-based "
		+ "Apple Silicon chips—a stark philosophical departure from the 1200-watt monoliths of 2011.\n\n"
		+ "2. QUAD ATI FIREPRO V9800 & S400 SYNCHRONIZATION MODULE (24-SCREEN MATRIX):\n"
		+ "Each ATI FirePro V9800 featured six independent Mini DisplayPort outputs and 4GB of high-speed GDDR5 memory (16GB total "
		+ "across four cards). Advanced builds linked all four cards together using a dedicated ATI FirePro S400 synchronization module. "
		+ "Instead of just sharing compute rendering across a standard bridge, the S400 perfectly locked the frame pacing, pixel clocks, "
		+ "and refresh rates across all four GPUs via dedicated hardware Genlock and Framelock buses. This allowed the workstation to "
		+ "drive up to 24 perfectly synchronized monitors simultaneously (delivering a massive 11,520 x 4,320 resolution Single Large "
		+ "Surface matrix). In an era when driving more than two or three displays caused screen tearing and phase latency, the SR-2 "
		+ "S400 matrix allowed mission control centers, military flight simulators, broadcast video walls, and CAVE immersive virtual "
		+ "reality environments to operate with zero micro-stutter and frame-accurate synchronization across every bezel.\n\n"
		+ "3. TRIPLE-BOOT ORCHESTRATION ACROSS DEDICATED PHYSICAL SSDs:\n"
		+ "Managing three fundamentally different operating systems on server-class hardware required careful bootloader orchestration. "
		+ "To prevent file system corruption and OS conflicts, each operating system was assigned its own dedicated OCZ Vertex 3 240GB "
		+ "SATA III SSD: the Chameleon bootloader for Mac OS X 10.7 Lion with custom DSDT ACPI table patches and FakeSMC for the dual "
		+ "LGA1366 Tylersburg platform, a heavily modified GRUB2 for Oracle Solaris 11 with native ZFS boot environments, and the native "
		+ "Windows Boot Manager for Windows 7 Ultimate SP1. The mechanical hard drives—four 2TB Western Digital Caviar Blacks—were formatted "
		+ "across NTFS, HFS+, and ZFS RAIDZ2 for specific, isolated storage pools, guaranteeing high data throughput without file table collisions.\n\n"
		+ "4. THE LEGENDARY EVGA CLASSIFIED SR-2 MOTHERBOARD ARCHITECTURE:\n"
		+ "Engineered by EVGA and renowned overclocker Peter 'Shamino' Tan, the Classified SR-2 redefined what desktop motherboards could "
		+ "achieve. Measuring a colossal 13.6 by 15 inches in the proprietary HPTX form factor, it featured dual LGA1366 sockets powered by "
		+ "8+2 phase digital PWMs, dual Intel 5520 chipset hubs, and twin NVIDIA NF200 bridge chips supplying 7 full-bandwidth PCI Express 2.0 "
		+ "x16 slots. Overclockers routinely pushed dual 6-core Xeon X5690s from 3.46 GHz past 4.40 GHz on custom water loops, breaking "
		+ "dozens of world benchmark records in 3DMark and Cinebench."
	)
	p.engineering_innovations = (
		"• Dual-Socket HPTX Overclocking Architecture: Dual LGA1366 sockets powered by dual Intel 5520 chipset hubs and twin NF200 bridges, "
		+ "overclocking dual 32nm Intel Xeon X5690 processors from 3.46 GHz to 4.40 GHz across 24 threads.\n"
		+ "• Quad ATI FirePro V9800 & S400 Genlock/Framelock Hardware Sync: Linked four 4GB workstation cards via the FirePro S400 "
		+ "synchronization module, driving up to 24 perfectly synchronized 1080p monitors simultaneously (11520x4320 Eyefinity matrix).\n"
		+ "• Physical Drive-Isolated Triple-Boot Architecture: Dedicated OCZ Vertex 3 SSDs isolating Windows 7 (Windows Boot Manager), "
		+ "Mac OS X 10.7 Lion (Chameleon v2.1 / FakeSMC), and Oracle Solaris 11 (GRUB2 ZFS Root Pool).\n"
		+ "• Dual 1200W Synchronized Power Supply Subsystem: Dual Corsair AX1200 80+ Gold power supplies linked via 24-pin relay bridge, "
		+ "delivering 2400W total capacity to feed dual overclocked Xeons and quad 225W GPUs.\n"
		+ "• Custom Dual-Loop Liquid Cooling Subsystem: Twin EK-Supreme HF CPU waterblocks, EK full-cover motherboard block, 4x GPU full-cover "
		+ "blocks, dual 480mm quad-fan radiators, and dual Swiftech MCP655 / D5 high-flow pumps.\n"
		+ "• Multi-Terabyte ZFS Enterprise Storage on Enthusiast Hardware: 4x 2TB Western Digital Caviar Black HDDs configured in ZFS RAIDZ2 "
		+ "with 100% data checksum verification and self-healing resilience."
	)
	p.cultural_legacy = (
		"The EVGA SR-2 Super Record stands as the grand finale of the brute-force, high-wattage enthusiast desktop era. Exactly as late "
		+ "1960s muscle cars represented the peak of naturally aspirated cubic inches before the fuel crises, the SR-2 stood as the absolute "
		+ "zenith of multi-socket, dual-power-supply personal supercomputers. Its legendary legacy lives on as both a celebrated milestone "
		+ "in extreme PC overclocking and the historical turning point that prompted the computing industry to embrace the energy-efficient, "
		+ "multi-core consumer paradigms of Sandy Bridge-E, AMD Threadripper, and Apple Silicon."
	)
	p.technical_specs = {
		"Manufacturer / Platform": "EVGA / Custom Enthusiast HPTX Workstation",
		"Release Date": "Late 2011 (EVGA SR-2 / Intel Xeon X5690 / Vertex 3 Era)",
		"Motherboard Model": "EVGA Classified SR-2 (Intel 5520 / ICH10R / Dual NF200, HPTX)",
		"Processors (CPU)": "2x Intel Xeon X5690 (Westmere-EP 32nm, 12 Cores / 24 Threads @ 4.40 GHz O/C)",
		"System Memory (RAM)": "48GB (12x 4GB) Corsair Dominator GT DDR3-1600 MHz in Triple-Channel (x2)",
		"Graphics Subsystem": "4x ATI FirePro V9800 4GB GDDR5 (6,400 Stream Cores / 16GB Total VRAM)",
		"Display Synchronization": "ATI FirePro S400 Hardware Genlock / Framelock Synchronization Module",
		"Display Output Capacity": "Up to 24x Independent Mini DisplayPort Outputs (11,520 x 4,320 SLS Matrix)",
		"Primary Console Displays": "Dual 27-inch Color-Calibrated IPS Displays (2560x1440 10-Bit)",
		"Graphic Boot Storage": "3x OCZ Vertex 3 240GB SATA III SSDs (SandForce SF-2281, Independent OS Drives)",
		"Mass Storage Pools": "4x Western Digital Caviar Black 2TB 7200RPM HDDs (8TB Raw across NTFS/HFS+/ZFS)",
		"Power Supply (PSU)": "Dual Corsair AX1200 (1200W) 80+ Gold Power Supplies (2400W Combined Headroom)",
		"Cooling Subsystem": "Custom Dual-Loop Liquid Cooling (EKWB blocks, dual 480mm radiators, dual D5 pumps)",
		"Chassis / Form Factor": "Custom-Modified Black Aluminum Lian Li HPTX Full Tower (Acoustic Dampened)",
		"Operating Systems": "Windows 7 Ultimate SP1 (x64) / Mac OS X 10.7 Lion / Oracle Solaris 11 (11/11)",
		"Bootloader Orchestration": "Windows Boot Manager (BCD) / Chameleon v2.1 r1684 / GRUB2 ZFS BE"
	}
	p.usage_cases = [
		{
			"title": "24-Screen Synchronized Eyefinity Command Center & Simulation Wall",
			"institution": "Advanced Simulation Laboratory / Global Command & Control Center",
			"hardware_setup": "EVGA SR-2 • 4x FirePro V9800 + S400 Genlock • 24x 1080p Thin-Bezel IPS Displays",
			"software_stack": "Windows 7 Ultimate SP1 (x64) • AMD Catalyst Pro 8.911 • DirectX 11 Simulation Engine",
			"workflow": (
				"The workstation drives a massive 6-column by 4-row video wall comprising 24 independent 1080p IPS displays, "
				+ "delivering an ultra-high resolution Single Large Surface (SLS) canvas of 11,520 by 4,320 pixels (49.7 megapixels). "
				+ "While un-synchronized multi-GPU setups suffered from severe tearing, frame-rate oscillation, and phase jitter across "
				+ "screen boundaries, the ATI FirePro S400 hardware synchronization module locked the pixel clocks and vertical refresh "
				+ "cycles across all four cards to a studio reference signal. Flight simulator pilots and command center operators "
				+ "view continuous, tear-free telemetry and real-time 3D flight dynamics spanning the entire 24-screen canvas."
			),
			"impact": (
				"Proved that an enthusiast multi-GPU workstation could replace multimillion-dollar proprietary Unix visualization "
				+ "clusters, powering seamless immersive military simulators, CAVE virtual environments, and broadcast studio walls."
			)
		},
		{
			"title": "24-Thread Liquid-Overclocked 3D Raytracing & VFX Render Node",
			"institution": "Boutique Visual Effects Studio & Architectural Visualization Lab",
			"hardware_setup": "EVGA SR-2 • Dual Xeon X5690 @ 4.40GHz • 48GB Corsair Dominator GT • Dual 480mm Radiators",
			"software_stack": "Windows 7 Ultimate SP1 (x64) • Autodesk 3ds Max 2012 • Chaos Group V-Ray 2.0",
			"workflow": (
				"Visual effects artists utilize the 24 threads of the liquid-cooled Xeon processors to render massive architectural scenes "
				+ "with complex global illumination, subsurface scattering, and multi-layer reflection passes. The 48GB triple-channel "
				+ "Corsair Dominator memory pool easily accommodates 12-million-polygon geometry caches without disk swapping. While rendering, "
				+ "the workstation draws over 1,800 Watts from the dual Corsair AX1200 power supplies, with dual 480mm radiators expelling "
				+ "tremendous thermal energy to keep both 4.40GHz Xeons under 65°C."
			),
			"impact": (
				"Delivered rendering throughput that eclipsed standard 8-node dual-quad-core render farms of the late 2000s, consolidating "
				+ "an entire studio's computational pipeline into a single, aggressively overclocked desktop chassis."
			)
		},
		{
			"title": "Cross-Platform Enterprise Software Development & ZFS Storage Vault",
			"institution": "Cross-Platform Enterprise Systems R&D / High-Throughput Financial Firm",
			"hardware_setup": "EVGA SR-2 • 3x OCZ Vertex 3 SSDs • 4x 2TB WD Black RAIDZ2 • Dual 27\" Color IPS Displays",
			"software_stack": "Oracle Solaris 11 11/11 (ZFS / DTrace) • Mac OS X 10.7 Lion (Final Cut Studio) • Win7 x64",
			"workflow": (
				"Engineers utilize the triple-boot architecture to execute isolated, mission-critical workflows without cross-contamination. "
				+ "Under Oracle Solaris 11, the 4x 2TB Western Digital Caviar Black hard drives are managed as an enterprise ZFS RAIDZ2 pool, "
				+ "providing continuous checksumming, snapshotting, and DTrace dynamic kernel inspection across PCIe DMA transfers. "
				+ "Rebooting via Chameleon into Mac OS X 10.7 Lion provides a native Apple environment for ProRes 422 color grading and "
				+ "OpenCL compute, while Windows 7 provides DirectX 11 engineering compatibility—each OS running on its own dedicated SATA3 SSD."
			),
			"impact": (
				"Demonstrated the absolute pinnacle of desktop hardware virtualization and multi-OS deployment before cloud hypervisors "
				+ "and containerization displaced bare-metal multi-booting."
			)
		}
	]
	p.exhibit_images = _build_default_image_slots(
		p.id,
		"Fig 1. Lian Li HPTX Workstation Chassis, Dual 27\" IPS Displays & 24-Screen Wall",
		"Massive black anodized aluminum Lian Li full-tower chassis with acrylic side window, dual liquid cooling loops, and 24-monitor Eyefinity video wall.",
		"Fig 2. EVGA Classified SR-2 Motherboard, Dual Xeons & Quad-V9800 S400 Array",
		"Architectural schematic showing dual LGA1366 sockets, 12 Corsair Dominator GT slots, 4x FirePro V9800 GPUs, and S400 Genlock ribbon interconnect.",
		"Fig 3. Triple-Boot Multi-OS Desktop Matrix & ATI FirePro Eyefinity Control Panel",
		"Interactive composite displaying Windows 7 Aero Glass, Mac OS X Lion Aqua, and Oracle Solaris 11 Java Desktop interfaces with 24-screen Genlock telemetry."
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

