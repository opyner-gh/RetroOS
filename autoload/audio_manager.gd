extends Node
## Global hardware & OS acoustic synthesizer and sample player (Autoload: `AudioManager`).
## Manages:
## 1. Continuous ambient server/workstation cooling fan hum loop (with RPM pitch shifting).
## 2. Physical-modeled hard drive voice-coil actuator clicks, multi-seek burst chatter, and background ticks.
## 3. Authentic 3.5" Floppy disk drive solenoid clack, 300 RPM Mylar disk friction, and stepper-motor seek grinds.
## 4. BIOS POST 1000Hz PC speaker beep.
## 5. Unique OS startup/login chimes for all 7 operating systems (Ubuntu 7.04, HP-UX CDE, Plan 9,
##    Windows 98 SE, OS/2 Warp 4, Windows XP Alienware Predator, and SGI IRIX 6.5 Octane2).

signal disk_activity_pulsed(is_floppy: bool)

const OSProfile = preload("res://data/os_profile.gd")
const MIX_RATE := 22050

var fan_enabled: bool = true
var hdd_ambient_enabled: bool = true
var master_muted: bool = false

var _fan_player: AudioStreamPlayer
var _hdd_player: AudioStreamPlayer
var _floppy_player: AudioStreamPlayer
var _beep_player: AudioStreamPlayer
var _startup_player: AudioStreamPlayer
var _ambient_hdd_timer: Timer

var _cached_hdd_clicks: Array[AudioStream] = []
var _cached_hdd_bursts: Array[AudioStream] = []
var _cached_floppy_seek: AudioStream
var _cached_optical_seek: AudioStream
var _cached_disk2_bang: AudioStream
var _cached_post_beep: AudioStream
var _cached_startup_streams: Dictionary = {}

var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()
	_setup_players()
	_prebuild_core_streams()
	start_fan_hum(110.0, 0.22)
	_schedule_next_ambient_hdd_tick()


func _setup_players() -> void:
	_fan_player = AudioStreamPlayer.new()
	_fan_player.name = "FanHumPlayer"
	_fan_player.volume_db = -10.0
	add_child(_fan_player)

	_hdd_player = AudioStreamPlayer.new()
	_hdd_player.name = "HDDClickPlayer"
	_hdd_player.volume_db = -3.5
	add_child(_hdd_player)

	_floppy_player = AudioStreamPlayer.new()
	_floppy_player.name = "FloppySeekPlayer"
	_floppy_player.volume_db = -2.5
	add_child(_floppy_player)

	_beep_player = AudioStreamPlayer.new()
	_beep_player.name = "PostBeepPlayer"
	_beep_player.volume_db = -9.0
	add_child(_beep_player)

	_startup_player = AudioStreamPlayer.new()
	_startup_player.name = "OSStartupPlayer"
	_startup_player.volume_db = -3.5
	add_child(_startup_player)

	_ambient_hdd_timer = Timer.new()
	_ambient_hdd_timer.name = "AmbientHDDTimer"
	_ambient_hdd_timer.one_shot = true
	_ambient_hdd_timer.timeout.connect(_on_ambient_hdd_timer_timeout)
	add_child(_ambient_hdd_timer)


func _prebuild_core_streams() -> void:
	# Build 6 organic variations of single HDD actuator clicks
	var ext_click_path := "res://assets/audio/sfx/hdd_click.ogg"
	if ResourceLoader.exists(ext_click_path):
		var s := ResourceLoader.load(ext_click_path)
		if s is AudioStream:
			_cached_hdd_clicks.append(s)
	if _cached_hdd_clicks.is_empty():
		for v in range(6):
			_cached_hdd_clicks.append(_synth_hdd_click_variant(v))

	# Build 4 organic variations of multi-seek HDD burst chatter
	var ext_burst_path := "res://assets/audio/sfx/hdd_burst.ogg"
	if ResourceLoader.exists(ext_burst_path):
		var b := ResourceLoader.load(ext_burst_path)
		if b is AudioStream:
			_cached_hdd_bursts.append(b)
	if _cached_hdd_bursts.is_empty():
		for v in range(4):
			_cached_hdd_bursts.append(_synth_hdd_burst_variant(v))

	_cached_floppy_seek = _load_or_generate("res://assets/audio/sfx/floppy_seek.ogg", _synth_floppy_seek)
	_cached_optical_seek = _load_or_generate("res://assets/audio/sfx/optical_seek.ogg", _synth_optical_seek)
	_cached_disk2_bang = _load_or_generate("res://assets/audio/sfx/disk2_bang.ogg", _synth_disk2_bang)
	_cached_post_beep = _load_or_generate("res://assets/audio/sfx/post_beep.ogg", _synth_post_beep)


func _load_or_generate(path: String, generator: Callable) -> AudioStream:
	if ResourceLoader.exists(path):
		var loaded := ResourceLoader.load(path)
		if loaded is AudioStream:
			return loaded
	return generator.call()


# ==============================================================================
# PUBLIC API
# ==============================================================================

## Starts or updates the continuous workstation/server cooling fan loop.
func start_fan_hum(base_freq: float = 115.0, noise_level: float = 0.24) -> void:
	var external_path := "res://assets/audio/ambient/fan_hum.ogg"
	if ResourceLoader.exists(external_path):
		_fan_player.stream = ResourceLoader.load(external_path)
	else:
		_fan_player.stream = _synth_fan_hum_loop(base_freq, noise_level)
	if fan_enabled and not _fan_player.playing:
		_fan_player.play()


## Simulates cooling fan RPM surge during BIOS power-on self-test.
func trigger_fan_spinup(profile: OSProfile = null) -> void:
	var target_freq := profile.fan_base_freq if profile else 118.0
	var target_noise := profile.fan_noise_level if profile else 0.25
	start_fan_hum(target_freq, target_noise)
	_fan_player.pitch_scale = 0.75
	var tw := create_tween()
	tw.tween_property(_fan_player, "pitch_scale", 1.18, 0.95).set_trans(Tween.TRANS_SINE)
	tw.tween_property(_fan_player, "pitch_scale", 1.00, 1.35).set_trans(Tween.TRANS_SINE)


func set_fan_enabled(enabled: bool) -> void:
	fan_enabled = enabled
	if fan_enabled:
		if not _fan_player.playing:
			_fan_player.play()
	else:
		_fan_player.stop()


func set_hdd_ambient_enabled(enabled: bool) -> void:
	hdd_ambient_enabled = enabled
	if enabled:
		_schedule_next_ambient_hdd_tick()
	else:
		_ambient_hdd_timer.stop()


## Plays a physical-modeled hard disk head actuator seek click.
func play_hdd_click(pitch_variance: float = 0.06) -> void:
	if master_muted or _cached_hdd_clicks.is_empty():
		return
	var idx := _rng.randi_range(0, _cached_hdd_clicks.size() - 1)
	_hdd_player.stream = _cached_hdd_clicks[idx]
	_hdd_player.pitch_scale = _rng.randf_range(1.0 - pitch_variance, 1.0 + pitch_variance)
	_hdd_player.play()
	disk_activity_pulsed.emit(false)


## Plays a realistic multi-cylinder IDE/SCSI hard disk head thrashing burst.
func play_hdd_burst() -> void:
	if master_muted or _cached_hdd_bursts.is_empty():
		return
	var idx := _rng.randi_range(0, _cached_hdd_bursts.size() - 1)
	_hdd_player.stream = _cached_hdd_bursts[idx]
	_hdd_player.pitch_scale = _rng.randf_range(0.95, 1.05)
	_hdd_player.play()
	disk_activity_pulsed.emit(false)


## Plays a 3.5" floppy drive solenoid head-load clack, Mylar spin, and stepper-motor seek sequence.
func play_floppy_seek() -> void:
	if master_muted:
		return
	_floppy_player.stream = _cached_floppy_seek
	_floppy_player.pitch_scale = _rng.randf_range(0.97, 1.03)
	_floppy_player.play()
	disk_activity_pulsed.emit(true)


## Plays a CD-ROM / DVD-ROM / GD-ROM optical laser lens focus-coil chirp & sled slide.
func play_optical_seek() -> void:
	if master_muted:
		return
	_floppy_player.stream = _cached_optical_seek
	_floppy_player.pitch_scale = _rng.randf_range(0.96, 1.04)
	_floppy_player.play()
	disk_activity_pulsed.emit(true)


## Plays an Apple II Disk II 5.25" Shugart SA-390 Track-0 stepper head-bang recalibration.
func play_disk2_bang() -> void:
	if master_muted:
		return
	_floppy_player.stream = _cached_disk2_bang
	_floppy_player.pitch_scale = _rng.randf_range(0.98, 1.02)
	_floppy_player.play()
	disk_activity_pulsed.emit(true)


## Plays a standard 1000Hz BIOS POST speaker beep.
func play_post_beep() -> void:
	if master_muted:
		return
	_beep_player.stream = _cached_post_beep
	_beep_player.play()


## Plays the unique OS login/startup chime for the specified `os_id`.
func play_os_startup_sound(os_id: String) -> void:
	if master_muted:
		return
	var custom_path := "res://assets/audio/startup/%s.ogg" % os_id
	if ResourceLoader.exists(custom_path):
		_startup_player.stream = ResourceLoader.load(custom_path)
		_startup_player.play()
		return

	if not _cached_startup_streams.has(os_id):
		_cached_startup_streams[os_id] = _synth_os_startup_chime(os_id)

	_startup_player.stream = _cached_startup_streams[os_id]
	_startup_player.play()


## Triggers a named hardware sound effect from a boot log entry.
func trigger_boot_sfx(sfx_key: String, profile: OSProfile = null) -> void:
	match sfx_key:
		"beep":
			play_post_beep()
		"floppy":
			play_floppy_seek()
		"cd_seek":
			play_optical_seek()
		"disk2_bang":
			play_disk2_bang()
		"hdd_click":
			play_hdd_click()
		"hdd_burst":
			play_hdd_burst()
		"fan_spinup":
			trigger_fan_spinup(profile)


func _schedule_next_ambient_hdd_tick() -> void:
	if not hdd_ambient_enabled:
		return
	var range_vec := Vector2(2.5, 6.5)
	if GameState.current_profile:
		range_vec = GameState.current_profile.hdd_seek_interval_range
	_ambient_hdd_timer.start(_rng.randf_range(range_vec.x, range_vec.y))


func _on_ambient_hdd_timer_timeout() -> void:
	if hdd_ambient_enabled and GameState.current_phase == GameState.SimPhase.DESKTOP:
		if _rng.randf() < 0.28:
			play_hdd_burst()
		else:
			play_hdd_click()
	_schedule_next_ambient_hdd_tick()


# ==============================================================================
# PROCEDURAL 16-BIT PCM AUDIO SYNTHESIZERS
# ==============================================================================

func _create_wav_stream(samples: PackedFloat32Array, loop: bool = false) -> AudioStreamWAV:
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = MIX_RATE
	wav.stereo = false

	var byte_data := PackedByteArray()
	byte_data.resize(samples.size() * 2)
	for i in range(samples.size()):
		var clamped := clampf(samples[i], -1.0, 1.0)
		var pcm16 := int(clamped * 32767.0)
		byte_data.encode_s16(i * 2, pcm16)

	wav.data = byte_data
	if loop:
		wav.loop_mode = AudioStreamWAV.LOOP_FORWARD
		wav.loop_begin = 0
		wav.loop_end = samples.size()
	return wav


## Synthesizes a seamless 3-second workstation fan hum + filtered airflow noise loop.
func _synth_fan_hum_loop(base_freq: float, noise_level: float) -> AudioStreamWAV:
	var duration := 3.0
	var count := int(MIX_RATE * duration)
	var samples := PackedFloat32Array()
	samples.resize(count)

	# Ensure integer number of cycles for seamless loop
	var f1 := roundf(base_freq * duration) / duration
	var f2 := f1 * 2.0
	var f3 := f1 * 3.0
	var mains_hum := roundf(60.0 * duration) / duration

	var lp_state := 0.0
	var bp_state := 0.0

	for i in range(count):
		var t := float(i) / float(MIX_RATE)
		var drone := (
			0.36 * sin(TAU * f1 * t)
			+ 0.18 * sin(TAU * f2 * t + 0.8)
			+ 0.08 * sin(TAU * f3 * t + 1.7)
			+ 0.22 * sin(TAU * mains_hum * t)
		)
		# Low-pass filtered turbulent airflow noise
		var white := _rng.randf_range(-1.0, 1.0)
		lp_state = lp_state + 0.08 * (white - lp_state)
		bp_state = bp_state + 0.02 * (lp_state - bp_state)
		var airflow := (lp_state - bp_state * 0.5) * noise_level

		var sample := (drone * 0.35) + airflow
		samples[i] = sample * 0.7

	# Smooth last 256 samples toward first 256 samples for zero-crossing loop continuity
	var fade_len := 256
	for i in range(fade_len):
		var alpha := float(i) / float(fade_len)
		var idx := count - fade_len + i
		samples[idx] = lerpf(samples[idx], samples[i], alpha)

	return _create_wav_stream(samples, true)


## Physical model of a single HDD voice-coil actuator seek (low chassis thump + damped
## cast-aluminum bandpass transient + servo lock-on micro-tick).
func _synth_hdd_click_variant(variant: int) -> AudioStreamWAV:
	var duration := 0.055
	var count := int(MIX_RATE * duration)
	var samples := PackedFloat32Array()
	samples.resize(count)

	var settle_delay := 0.008 + float(variant % 4) * 0.0025
	var thump_freq := 130.0 + float(variant) * 9.0
	var lp1 := 0.0
	var lp2 := 0.0

	for i in range(count):
		var t := float(i) / float(MIX_RATE)
		var val := _eval_hdd_actuator_pulse(t, thump_freq, 1.0, lp1, lp2)

		# Secondary track-lock servo micro-tick
		if t >= settle_delay:
			val += _eval_hdd_actuator_pulse(t - settle_delay, thump_freq * 1.18, 0.38, lp1, lp2)

		# Update state-variable filter states for organic metallic crunch
		var raw_noise := _rng.randf_range(-1.0, 1.0)
		lp1 += 0.26 * (raw_noise - lp1)
		lp2 += 0.07 * (lp1 - lp2)

		samples[i] = clampf(val * 0.92, -0.98, 0.98)

	return _create_wav_stream(samples, false)


func _eval_hdd_actuator_pulse(dt: float, base_thump_hz: float, gain: float, filt_hi: float, filt_lo: float) -> float:
	if dt < 0.0 or dt > 0.028:
		return 0.0
	# 1. Heavy voice-coil stop thud into drive bay chassis (pitch-dropping 150Hz -> 75Hz)
	var inst_freq := maxf(65.0, base_thump_hz - dt * 3200.0)
	var chassis_thud := sin(TAU * inst_freq * dt) * exp(-dt * 310.0) * 0.68

	# 2. Razor-sharp damped metallic actuator snap (band-passed noise, no pure sine ring!)
	var bp_noise := (filt_hi - filt_lo)
	var arm_snap := bp_noise * exp(-dt * 680.0) * 1.35

	# 3. Sub-millisecond initial magnetic stop click
	var micro_click := (1.0 if dt < 0.0009 else 0.0) * 0.45 * (1.0 - dt / 0.0009)

	return (chassis_thud + arm_snap + micro_click) * gain


## Physical model of multi-seek IDE/SCSI disk thrashing ("krr-tck-tk-tk-krrr-tk").
func _synth_hdd_burst_variant(variant: int) -> AudioStreamWAV:
	var duration := 0.48
	var count := int(MIX_RATE * duration)
	var samples := PackedFloat32Array()
	samples.resize(count)

	# Generate an irregular, authentic seek schedule (mix of short track hops & long cylinder seeks)
	var seek_events: Array[Dictionary] = []
	var cursor := 0.004
	var local_rng := RandomNumberGenerator.new()
	local_rng.seed = 9001 + variant * 73
	while cursor < duration - 0.035:
		var is_long_seek := local_rng.randf() < 0.35
		seek_events.append({
			"time": cursor,
			"thump": local_rng.randf_range(115.0, 170.0),
			"gain": local_rng.randf_range(0.55, 1.0) if is_long_seek else local_rng.randf_range(0.32, 0.65),
		})
		cursor += local_rng.randf_range(0.028, 0.062) if is_long_seek else local_rng.randf_range(0.009, 0.022)

	var lp1 := 0.0
	var lp2 := 0.0

	for i in range(count):
		var t := float(i) / float(MIX_RATE)
		var raw_noise := _rng.randf_range(-1.0, 1.0)
		lp1 += 0.28 * (raw_noise - lp1)
		lp2 += 0.075 * (lp1 - lp2)

		# Subtle 7200 RPM (120Hz) spindle bearing murmur during disk access
		var spindle := sin(TAU * 120.0 * t) * 0.035
		var accum := spindle

		for ev in seek_events:
			var dt: float = t - float(ev["time"])
			if dt >= 0.0 and dt < 0.026:
				accum += _eval_hdd_actuator_pulse(dt, float(ev["thump"]), float(ev["gain"]), lp1, lp2)

		samples[i] = clampf(accum * 0.88, -0.98, 0.98)

	return _create_wav_stream(samples, false)


## Physical model of a 3.5" 1.44MB Floppy Disk Drive (TEAC FD-235HF style):
## 1. Head load solenoid & hub catch clack (0.00s)
## 2. 300 RPM (5Hz) Mylar magnetic disk jacket friction ("shhh-shhh")
## 3. Outward stepper-motor track seek ratchet (13 steps @ 18ms/step)
## 4. Brief head settle pause
## 5. Inward stepper-motor return to Track 0 (13 steps @ 17ms/step)
## 6. Two discrete Track-0 verification steps ("chk ... chk")
func _synth_floppy_seek() -> AudioStreamWAV:
	var duration := 1.08
	var count := int(MIX_RATE * duration)
	var samples := PackedFloat32Array()
	samples.resize(count)

	# Build discrete stepper motor pulse schedule
	var step_pulses: Array[Dictionary] = []
	# Outward seek burst (13 tracks)
	for s in range(13):
		step_pulses.append({
			"time": 0.11 + float(s) * 0.0185,
			"pitch": 195.0 + float(s % 3) * 12.0,
			"gain": 0.82
		})
	# Return seek burst to Track 0 (13 tracks, slightly lower chassis resonance)
	for s in range(13):
		step_pulses.append({
			"time": 0.44 + float(s) * 0.0175,
			"pitch": 172.0 + float(s % 2) * 10.0,
			"gain": 0.86
		})
	# Two distinct Track-0 index verification steps ("chk ... chk")
	step_pulses.append({"time": 0.75, "pitch": 162.0, "gain": 0.95})
	step_pulses.append({"time": 0.85, "pitch": 155.0, "gain": 0.90})

	var lp_fast := 0.0
	var lp_slow := 0.0
	var rub_lp := 0.0

	for i in range(count):
		var t := float(i) / float(MIX_RATE)
		var white := _rng.randf_range(-1.0, 1.0)
		lp_fast += 0.32 * (white - lp_fast)
		lp_slow += 0.08 * (lp_fast - lp_slow)
		rub_lp += 0.12 * (white - rub_lp)
		var bp_grit := lp_fast - lp_slow

		var val := 0.0

		# 1. Initial solenoid head-load clack & metal shutter catch (0.00s - 0.055s)
		if t < 0.055:
			var clack_thud := sin(TAU * (150.0 - t * 1400.0) * t) * exp(-t * 115.0) * 0.65
			var plastic_snap := bp_grit * exp(-t * 240.0) * 1.15
			if t > 0.014:
				var dt2 := t - 0.014
				plastic_snap += bp_grit * exp(-dt2 * 310.0) * 0.75
			val += clack_thud + plastic_snap

		# 2. 300 RPM (5 Hz) Mylar disk spinning inside fabric liner ("shhh-shhh" modulation)
		if t >= 0.04 and t < 1.00:
			var rev_mod := 0.55 + 0.45 * sin(TAU * 5.0 * t)
			var disk_rub := (rub_lp - lp_slow * 0.7) * 0.11 * rev_mod
			val += disk_rub

		# 3. Discrete stepper-motor worm-gear pulses
		for sp in step_pulses:
			var dt: float = t - float(sp["time"])
			if dt >= 0.0 and dt < 0.015:
				var p_freq: float = sp["pitch"]
				var p_gain: float = sp["gain"]
				# Stepper coil magnetic detent thump + worm-screw mechanical rattle
				var coil_pulse := sin(TAU * p_freq * dt) * exp(-dt * 260.0) * 0.55
				var gear_grit := bp_grit * exp(-dt * 380.0) * 0.85
				var detent_tick := sin(TAU * (p_freq * 2.7) * dt) * exp(-dt * 480.0) * 0.35
				val += (coil_pulse + gear_grit + detent_tick) * p_gain

		# 4. Final head-unload relay click at 1.01s
		if t >= 1.00 and t < 1.04:
			var dt_end := t - 1.00
			val += (sin(TAU * 130.0 * dt_end) + bp_grit * 0.8) * exp(-dt_end * 350.0) * 0.45

		samples[i] = clampf(val * 0.88, -0.98, 0.98)

	return _create_wav_stream(samples, false)


## Synthesizes a CD-ROM / DVD-ROM / GD-ROM optical laser lens focus-coil chirp & worm-gear sled seek.
func _synth_optical_seek() -> AudioStreamWAV:
	var duration := 0.88
	var count := int(MIX_RATE * duration)
	var samples := PackedFloat32Array()
	samples.resize(count)

	var lp := 0.0
	for i in range(count):
		var t := float(i) / float(MIX_RATE)
		var white := _rng.randf_range(-1.0, 1.0)
		lp += 0.25 * (white - lp)
		var val := 0.0

		# 1. Optical sled worm-gear motor slide (0.02s - 0.28s)
		if t >= 0.02 and t < 0.28:
			var dt := t - 0.02
			var sled_freq := 310.0 + sin(TAU * 18.0 * dt) * 28.0
			val += (sin(TAU * sled_freq * dt) * 0.28 + (white - lp) * 0.22) * minf(1.0, dt * 30.0)

		# 2. Laser lens focus-coil double chirp ("pew-tck ... pew-tck" at 0.34s and 0.56s)
		for chirp_start in [0.34, 0.56]:
			if t >= chirp_start and t < chirp_start + 0.14:
				var dt: float = t - chirp_start
				var sweep_hz := 980.0 - dt * 4200.0
				var lens_chirp := sin(TAU * maxf(180.0, sweep_hz) * dt) * exp(-dt * 28.0) * 0.36
				var limit_tick := (white - lp) * exp(-dt * 180.0) * 0.65
				val += lens_chirp + limit_tick

		# 3. Short spindle motor nudge (0.72s - 0.85s)
		if t >= 0.72 and t < 0.85:
			var dt := t - 0.72
			val += sin(TAU * (240.0 + dt * 400.0) * dt) * exp(-dt * 22.0) * 0.25

		samples[i] = clampf(val * 0.85, -0.98, 0.98)

	return _create_wav_stream(samples, false)


## Synthesizes the classic Apple II Disk II 5.25" Shugart SA-390 Track-0 stepper head-bang.
func _synth_disk2_bang() -> AudioStreamWAV:
	var duration := 0.92
	var count := int(MIX_RATE * duration)
	var samples := PackedFloat32Array()
	samples.resize(count)

	var lp1 := 0.0
	var lp2 := 0.0
	for i in range(count):
		var t := float(i) / float(MIX_RATE)
		var white := _rng.randf_range(-1.0, 1.0)
		lp1 += 0.35 * (white - lp1)
		lp2 += 0.09 * (lp1 - lp2)
		var bp := lp1 - lp2
		var val := 0.0

		# 35 rapid stepper-motor impacts against the mechanical Track-0 stop (every 18ms)
		if t < 0.64:
			var step_dt := fmod(t, 0.018)
			var clack := sin(TAU * (185.0 - step_dt * 3200.0) * step_dt) * exp(-step_dt * 220.0) * 0.65
			var metal_stop := bp * exp(-step_dt * 340.0) * 1.15
			val += clack + metal_stop
		# Two final track seek steps after calibration
		elif t >= 0.70 and t < 0.86:
			var step_dt := fmod(t - 0.70, 0.045)
			val += (sin(TAU * 165.0 * step_dt) + bp * 0.8) * exp(-step_dt * 260.0) * 0.55

		samples[i] = clampf(val * 0.90, -0.98, 0.98)

	return _create_wav_stream(samples, false)


## Synthesizes a 140ms 1000Hz square-wave PC speaker POST beep.
func _synth_post_beep() -> AudioStreamWAV:
	var count := int(MIX_RATE * 0.14)
	var samples := PackedFloat32Array()
	samples.resize(count)

	for i in range(count):
		var t := float(i) / float(MIX_RATE)
		var sq := 1.0 if sin(TAU * 1000.0 * t) >= 0.0 else -1.0
		var env := 1.0
		if t > 0.11:
			env = maxf(0.0, (0.14 - t) / 0.03)
		samples[i] = sq * 0.32 * env

	return _create_wav_stream(samples, false)


## Synthesizes a distinct, period-evocative startup/login sound for each OS.
func _synth_os_startup_chime(os_id: String) -> AudioStreamWAV:
	match os_id:
		"ubuntu_704":
			# Warm wooden marimba/djembe arpeggio (B3 -> F#4 -> B4 -> D#5)
			return _synth_chord_sequence([
				{"freq": 246.94, "start": 0.00, "dur": 0.65, "amp": 0.35, "warmth": 1.0},
				{"freq": 369.99, "start": 0.11, "dur": 0.65, "amp": 0.32, "warmth": 1.0},
				{"freq": 493.88, "start": 0.22, "dur": 0.75, "amp": 0.32, "warmth": 1.0},
				{"freq": 622.25, "start": 0.34, "dur": 0.95, "amp": 0.28, "warmth": 1.0},
			], 1.35)

		"hpux_cde":
			# Crisp FM-synth UNIX workstation bell chord (E4 + B4 + F#5 + G#5)
			return _synth_chord_sequence([
				{"freq": 329.63, "start": 0.00, "dur": 1.10, "amp": 0.28, "warmth": 0.4},
				{"freq": 493.88, "start": 0.04, "dur": 1.10, "amp": 0.26, "warmth": 0.4},
				{"freq": 739.99, "start": 0.08, "dur": 1.00, "amp": 0.22, "warmth": 0.3},
				{"freq": 830.61, "start": 0.20, "dur": 1.05, "amp": 0.24, "warmth": 0.3},
			], 1.30)

		"plan9":
			# Minimalist Bell Labs pure harmonic fifths (C4 -> G4 -> D5)
			return _synth_chord_sequence([
				{"freq": 261.63, "start": 0.00, "dur": 0.85, "amp": 0.30, "warmth": 0.8},
				{"freq": 392.00, "start": 0.14, "dur": 0.85, "amp": 0.28, "warmth": 0.8},
				{"freq": 587.33, "start": 0.28, "dur": 0.90, "amp": 0.25, "warmth": 0.8},
			], 1.25)

		"win98_se":
			# Shimmering late-90s ambient pad & bell cascade (Eb4 -> Bb4 -> Ab4 -> Eb5 -> Bb5)
			return _synth_chord_sequence([
				{"freq": 311.13, "start": 0.00, "dur": 1.50, "amp": 0.26, "warmth": 0.6},
				{"freq": 466.16, "start": 0.12, "dur": 1.40, "amp": 0.24, "warmth": 0.6},
				{"freq": 415.30, "start": 0.25, "dur": 1.30, "amp": 0.24, "warmth": 0.6},
				{"freq": 622.25, "start": 0.40, "dur": 1.35, "amp": 0.28, "warmth": 0.5},
				{"freq": 932.33, "start": 0.55, "dur": 1.20, "amp": 0.20, "warmth": 0.4},
			], 1.80)

		"os2_warp":
			# Deep IBM Warp 4 orchestral synth swell (D3 + A3 + D4 + F#4 + A4)
			return _synth_chord_sequence([
				{"freq": 146.83, "start": 0.00, "dur": 1.45, "amp": 0.32, "warmth": 0.5},
				{"freq": 220.00, "start": 0.08, "dur": 1.40, "amp": 0.28, "warmth": 0.5},
				{"freq": 293.66, "start": 0.16, "dur": 1.35, "amp": 0.26, "warmth": 0.5},
				{"freq": 369.99, "start": 0.28, "dur": 1.25, "amp": 0.25, "warmth": 0.4},
				{"freq": 440.00, "start": 0.40, "dur": 1.15, "amp": 0.24, "warmth": 0.4},
			], 1.65)

		"winxp_alienware":
			# Iconic Windows XP two-phrase electric piano & warm strings melody
			# (Eb5 -> Bb4 -> Ab4 -> Eb4, resolving to Bb4 -> Eb5 over Ab/Eb bass pad)
			return _synth_chord_sequence([
				{"freq": 155.56, "start": 0.00, "dur": 1.90, "amp": 0.22, "warmth": 0.8},
				{"freq": 622.25, "start": 0.00, "dur": 0.45, "amp": 0.28, "warmth": 0.6},
				{"freq": 466.16, "start": 0.18, "dur": 0.45, "amp": 0.26, "warmth": 0.6},
				{"freq": 415.30, "start": 0.36, "dur": 0.55, "amp": 0.28, "warmth": 0.6},
				{"freq": 311.13, "start": 0.62, "dur": 0.80, "amp": 0.26, "warmth": 0.7},
				{"freq": 466.16, "start": 0.92, "dur": 0.50, "amp": 0.28, "warmth": 0.6},
				{"freq": 622.25, "start": 1.18, "dur": 0.95, "amp": 0.32, "warmth": 0.5},
			], 2.15)

		"sgi_irix":
			# Silicon Graphics Octane2 / Indigo Magic crystalline D-Lydian workstation fanfare
			return _synth_chord_sequence([
				{"freq": 146.83, "start": 0.00, "dur": 1.85, "amp": 0.26, "warmth": 0.5},
				{"freq": 293.66, "start": 0.06, "dur": 1.75, "amp": 0.24, "warmth": 0.4},
				{"freq": 440.00, "start": 0.14, "dur": 1.65, "amp": 0.24, "warmth": 0.3},
				{"freq": 554.37, "start": 0.24, "dur": 1.50, "amp": 0.22, "warmth": 0.3},
				{"freq": 659.25, "start": 0.36, "dur": 1.40, "amp": 0.24, "warmth": 0.3},
				{"freq": 880.00, "start": 0.50, "dur": 1.30, "amp": 0.20, "warmth": 0.2},
			], 1.95)

		"beos_r5":
			# Crisp BeOS R5 Media Server bell triad (G4 -> B4 -> D5 -> G5)
			return _synth_chord_sequence([
				{"freq": 392.00, "start": 0.00, "dur": 0.75, "amp": 0.28, "warmth": 0.6},
				{"freq": 493.88, "start": 0.08, "dur": 0.75, "amp": 0.26, "warmth": 0.6},
				{"freq": 587.33, "start": 0.16, "dur": 0.85, "amp": 0.26, "warmth": 0.5},
				{"freq": 783.99, "start": 0.24, "dur": 1.00, "amp": 0.28, "warmth": 0.4},
			], 1.35)

		"nextstep_33":
			# Motorola DSP56001 NeXTstation rich fifths chord (A3 + E4 + A4 + C#5)
			return _synth_chord_sequence([
				{"freq": 220.00, "start": 0.00, "dur": 1.35, "amp": 0.30, "warmth": 0.7},
				{"freq": 329.63, "start": 0.04, "dur": 1.30, "amp": 0.28, "warmth": 0.6},
				{"freq": 440.00, "start": 0.10, "dur": 1.25, "amp": 0.26, "warmth": 0.5},
				{"freq": 554.37, "start": 0.18, "dur": 1.20, "amp": 0.24, "warmth": 0.5},
			], 1.50)

		"solaris_8":
			# Sun Ultra 60 OpenWindows / CDE chime (F4 -> C5 -> G5)
			return _synth_chord_sequence([
				{"freq": 349.23, "start": 0.00, "dur": 1.05, "amp": 0.28, "warmth": 0.5},
				{"freq": 523.25, "start": 0.12, "dur": 1.00, "amp": 0.26, "warmth": 0.4},
				{"freq": 783.99, "start": 0.24, "dur": 1.10, "amp": 0.24, "warmth": 0.3},
			], 1.40)

		"redhat_62":
			# Enlightenment DR16 sci-fi synth chord (E3 + B3 + E4 + B4)
			return _synth_chord_sequence([
				{"freq": 164.81, "start": 0.00, "dur": 1.25, "amp": 0.30, "warmth": 0.6},
				{"freq": 246.94, "start": 0.08, "dur": 1.20, "amp": 0.26, "warmth": 0.5},
				{"freq": 329.63, "start": 0.16, "dur": 1.15, "amp": 0.26, "warmth": 0.4},
				{"freq": 493.88, "start": 0.28, "dur": 1.10, "amp": 0.24, "warmth": 0.3},
			], 1.45)

		"freebsd_411", "sco_openserver":
			# Classic UNIX server console dual-tone bell chime
			return _synth_chord_sequence([
				{"freq": 440.00, "start": 0.00, "dur": 0.55, "amp": 0.28, "warmth": 0.5},
				{"freq": 659.25, "start": 0.18, "dur": 0.85, "amp": 0.28, "warmth": 0.5},
			], 1.10)

		"mac_sys75":
			# Classic Macintosh Quadra 840AV C-Major / G rich organ startup chord
			return _synth_chord_sequence([
				{"freq": 130.81, "start": 0.00, "dur": 1.80, "amp": 0.30, "warmth": 0.5},
				{"freq": 261.63, "start": 0.00, "dur": 1.80, "amp": 0.28, "warmth": 0.5},
				{"freq": 329.63, "start": 0.00, "dur": 1.80, "amp": 0.26, "warmth": 0.4},
				{"freq": 392.00, "start": 0.00, "dur": 1.80, "amp": 0.26, "warmth": 0.4},
				{"freq": 523.25, "start": 0.00, "dur": 1.80, "amp": 0.22, "warmth": 0.3},
			], 1.90)

		"macosx_g4":
			# Booming 1999 Power Mac G4 New World ROM F#-Major startup chord
			return _synth_chord_sequence([
				{"freq": 92.50, "start": 0.00, "dur": 2.20, "amp": 0.34, "warmth": 0.4},
				{"freq": 185.00, "start": 0.00, "dur": 2.20, "amp": 0.30, "warmth": 0.4},
				{"freq": 277.18, "start": 0.00, "dur": 2.20, "amp": 0.26, "warmth": 0.3},
				{"freq": 369.99, "start": 0.00, "dur": 2.20, "amp": 0.26, "warmth": 0.3},
				{"freq": 466.16, "start": 0.00, "dur": 2.20, "amp": 0.22, "warmth": 0.3},
			], 2.30)

		"amiga_os31":
			# Paula 8-bit DMA stereo harmonic arpeggio (A3 -> C#4 -> E4 -> A4)
			return _synth_chord_sequence([
				{"freq": 220.00, "start": 0.00, "dur": 0.80, "amp": 0.30, "warmth": 0.3},
				{"freq": 277.18, "start": 0.10, "dur": 0.80, "amp": 0.28, "warmth": 0.3},
				{"freq": 329.63, "start": 0.20, "dur": 0.85, "amp": 0.28, "warmth": 0.3},
				{"freq": 440.00, "start": 0.30, "dur": 0.95, "amp": 0.28, "warmth": 0.3},
			], 1.30)

		"apple_iie":
			# Classic Apple II 1000Hz speaker beep
			return _synth_post_beep()


		_:
			return _synth_chord_sequence([
				{"freq": 440.0, "start": 0.0, "dur": 0.6, "amp": 0.3, "warmth": 0.5}
			], 0.7)


func _synth_chord_sequence(notes: Array[Dictionary], total_duration: float) -> AudioStreamWAV:
	var count := int(MIX_RATE * total_duration)
	var samples := PackedFloat32Array()
	samples.resize(count)

	for i in range(count):
		var t := float(i) / float(MIX_RATE)
		var mix := 0.0
		for n in notes:
			var start: float = n["start"]
			var dur: float = n["dur"]
			if t >= start and t < start + dur:
				var nt := t - start
				var freq: float = n["freq"]
				var amp: float = n["amp"]
				var warmth: float = n["warmth"]
				var attack := minf(1.0, nt / 0.025)
				var decay := exp(-nt * (2.6 / dur))
				var fundamental := sin(TAU * freq * nt)
				var harmonic2 := sin(TAU * (freq * 2.0) * nt) * (0.45 * (1.0 - warmth * 0.5))
				var harmonic3 := sin(TAU * (freq * 3.0) * nt) * (0.20 * (1.0 - warmth * 0.7))
				mix += (fundamental + harmonic2 + harmonic3) * amp * attack * decay
		samples[i] = clampf(mix, -0.95, 0.95)

	return _create_wav_stream(samples, false)
