shader_type canvas_item;
// Subtle CRT scanline, vignette, and phosphor curvature overlay shader for RetroOS.
// Supports both 16:9 widescreen and 4:3 pillarboxed monitors via `display_bounds`.
// Applied on a ColorRect with mouse_filter = MOUSE_FILTER_IGNORE.

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float scanline_opacity : hint_range(0.0, 0.5) = 0.14;
uniform float scanline_count : hint_range(100.0, 1080.0) = 384.0;
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.22;
uniform float curvature : hint_range(0.0, 0.08) = 0.015;
// Normalized viewport rectangle: (x_start, y_start, width, height)
uniform vec4 display_bounds = vec4(0.0, 0.0, 1.0, 1.0);

vec2 curve_uv(vec2 monitor_uv) {
	vec2 centered = monitor_uv * 2.0 - 1.0;
	vec2 offset = centered.yx * centered.yx * curvature;
	centered = centered + centered * offset;
	return centered * 0.5 + 0.5;
}

void fragment() {
	// Map SCREEN_UV into monitor-local UV [0.0 .. 1.0]
	vec2 monitor_uv = (SCREEN_UV - display_bounds.xy) / display_bounds.zw;
	if (monitor_uv.x < 0.0 || monitor_uv.x > 1.0 || monitor_uv.y < 0.0 || monitor_uv.y > 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		vec2 curved_uv = curve_uv(monitor_uv);
		if (curved_uv.x < 0.0 || curved_uv.x > 1.0 || curved_uv.y < 0.0 || curved_uv.y > 1.0) {
			COLOR = vec4(0.02, 0.02, 0.025, 1.0);
		} else {
			vec2 screen_sample_uv = display_bounds.xy + curved_uv * display_bounds.zw;
			vec4 col = texture(screen_texture, screen_sample_uv);
			float scan = sin(curved_uv.y * scanline_count * 3.14159265 * 2.0);
			col.rgb -= col.rgb * (scan * 0.5 + 0.5) * scanline_opacity;

			vec2 vig_uv = curved_uv * (1.0 - curved_uv.yx);
			float vig = vig_uv.x * vig_uv.y * 16.0;
			vig = clamp(pow(vig, vignette_intensity), 0.0, 1.0);
			col.rgb *= vig;

			COLOR = vec4(col.rgb, 1.0);
		}
	}
}
