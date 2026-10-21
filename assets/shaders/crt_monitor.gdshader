shader_type canvas_item;
// Subtle CRT scanline, vignette, and phosphor grill overlay shader for RetroOS.
// Applied on a full-screen ColorRect with mouse_filter = MOUSE_FILTER_IGNORE.

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float scanline_opacity : hint_range(0.0, 0.5) = 0.14;
uniform float scanline_count : hint_range(100.0, 1080.0) = 384.0;
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.22;
uniform float curvature : hint_range(0.0, 0.08) = 0.015;

vec2 curve_uv(vec2 uv) {
	vec2 centered = uv * 2.0 - 1.0;
	vec2 offset = centered.yx * centered.yx * curvature;
	centered = centered + centered * offset;
	return centered * 0.5 + 0.5;
}

void fragment() {
	vec2 uv = curve_uv(SCREEN_UV);
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		COLOR = vec4(0.02, 0.02, 0.025, 1.0);
	} else {
		vec4 col = texture(screen_texture, uv);
		float scan = sin(uv.y * scanline_count * 3.14159265 * 2.0);
		col.rgb -= col.rgb * (scan * 0.5 + 0.5) * scanline_opacity;

		vec2 vig_uv = uv * (1.0 - uv.yx);
		float vig = vig_uv.x * vig_uv.y * 16.0;
		vig = clamp(pow(vig, vignette_intensity), 0.0, 1.0);
		col.rgb *= vig;

		COLOR = vec4(col.rgb, 1.0);
	}
}

