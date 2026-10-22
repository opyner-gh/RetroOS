# Museum Exhibit Image Archive (`res://assets/exhibits/`)

The **RetroOS Digital Computing Codex** includes a built-in provision to display either **historical photographs**, **curated screenshots**, or **AI-generated images** for each exhibited computer system, its internal hardware, and its operating system software.

Out-of-the-box, when no external image file is present for a slot, the Codex renders a custom **Archival Vector Plate** (`ExhibitPlateRenderer`) depicting the machine's chassis silhouette, motherboard schematic, or desktop UI.

---

## 🖼️ How to Add Historical or Generated Images

### Method 1: Directly Inside the Running Codex UI (No Restart Needed)
1. Select any computer system in the **RetroOS Digital Computing Codex**.
2. In the right-hand **Wikipedia Infobox** (or under **Section 5: Curatorial Media & Image Archive**), click **`[ 📂 Attach / Replace Image... ]`**.
3. Pick any `.png`, `.jpg`, `.jpeg`, or `.webp` image from your computer.
4. RetroOS automatically copies the image into `res://assets/exhibits/<os_id>/<slot_id>.png` (and `user://exhibits/<os_id>/<slot_id>.png`) and renders it live!

### Method 2: Drop Files Into `res://assets/exhibits/<os_id>/`
Drop `.png`, `.jpg`, `.jpeg`, or `.webp` files into the corresponding `<os_id>` folder using these three slot filenames:
- `system.png` — **Slot 1: System Chassis, Monitor & Industrial Design**
- `hardware.png` — **Slot 2: Internal Hardware, Motherboard, CPU Die & Peripherals**
- `software.png` — **Slot 3: Operating System Desktop, Window Chrome & Period Software**

---

## 🗂️ Supported System Exhibit Folder IDs (Chronological: 1972 → 2007)

| Folder Path | System & Operating System Exhibit |
| :--- | :--- |
| `res://assets/exhibits/datapoint_2200/` | **Datapoint DOS 2.1 (Datapoint 2200)** — CTC 8-Bit Discrete TTL Workstation & Diablo 2.5MB Disk (1972) • Chronological Entry #1 |
| `res://assets/exhibits/apple_iie/` | **Apple IIe Enhanced** — Apple //e 65C02 with DuoDisk & Monitor // (1985) |
| `res://assets/exhibits/amiga_os31/` | **Commodore AmigaOS 3.1** — Commodore Amiga 3000 (1993) |
| `res://assets/exhibits/mac_sys75/` | **Mac OS System 7.5.3** — Apple Macintosh Quadra 840AV (1995) |
| `res://assets/exhibits/nextstep_33/` | **NeXTSTEP 3.3** — NeXTstation Turbo Color 68040 + DSP56001 (1995) |
| `res://assets/exhibits/os2_warp/` | **IBM OS/2 Warp 4 (Merlin)** — IBM PC 300PL Pentium Pro (1996) |
| `res://assets/exhibits/macosx_g4/` | **Mac OS X 10.2 Jaguar** — 1999 Apple Power Mac G4 'Sawtooth' (1999) |
| `res://assets/exhibits/sco_openserver/` | **SCO OpenServer 5.0.5** — Compaq ProLiant 1600 Dual P-III (1999) |
| `res://assets/exhibits/win98_se/` | **Windows 98 Second Edition** — Pentium III 500MHz & 3dfx Voodoo3 (1999) |
| `res://assets/exhibits/beos_r5/` | **BeOS R5 Pro (5.0.3)** — Tyan Tiger 100 Dual Pentium III SMP (2000) |
| `res://assets/exhibits/hpux_cde/` | **HP-UX 11i (CDE Workstation)** — HP 9000 Visualize C3600 (2000) |
| `res://assets/exhibits/redhat_62/` | **Red Hat Linux 6.2 (Zoot)** — Dual Pentium II 400MHz Workstation (2000) |
| `res://assets/exhibits/solaris_8/` | **Sun Solaris 8** — Sun Ultra 60 Dual UltraSPARC II Creator3D (2000) |
| `res://assets/exhibits/sgi_irix/` | **SGI IRIX 6.5.22** — Silicon Graphics Octane2 VPro V12 (2001) |
| `res://assets/exhibits/plan9/` | **Plan 9 from Bell Labs (4th Ed.)** — Bell Labs 9pc Terminal (2002) |
| `res://assets/exhibits/winxp_alienware/` | **Windows XP Pro SP2** — Alienware Area-51 'Predator' P4 Extreme (2003) |
| `res://assets/exhibits/freebsd_411/` | **FreeBSD 4.11-STABLE** — Supermicro P3TDDE Dual Pentium III (2004) |
| `res://assets/exhibits/ubuntu_704/` | **Ubuntu 7.04 (Feisty Fawn)** — Dell OptiPlex GX620 (2007) |

