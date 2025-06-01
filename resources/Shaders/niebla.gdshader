shader_type canvas_item;
// render_mode unshaded; // Descomenta si no quieres que le afecte la luz del entorno

// Textura de ruido que se usará para simular la niebla
uniform sampler2D noise_texture : repeat_enable, filter_nearest;
// Densidad de la niebla
uniform float density: hint_range(0.0, 1.0) = 0.30;
// Velocidad a la que se mueve la niebla
uniform vec2 speed = vec2(0.02, 0.01);

// Esta función se llama para cada píxel visible del objeto
void fragment() {
	// Mueve lentamente la niebla usando el tiempo
	vec2 uv = UV + speed * TIME;
	// Muestra el valor de la textura de ruido en esas coordenadas
	float noise = texture(noise_texture, uv).r;
	// Ajusta el valor del ruido de (0.0, 1.0) a (-1.0, 1.0), luego lo limita entre 0.0 y 1.0
	float fog = clamp(noise * 2.0 - 1.0, 0.0, 1.0);
	// Aplica el efecto de niebla multiplicando la opacidad
	COLOR.a *= fog * density;
}
