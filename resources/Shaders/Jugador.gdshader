shader_type canvas_item;
render_mode blend_mix, unshaded; // Necesario para usar color sin iluminación real y simular glow

// === PARÁMETROS DEL USUARIO ===
uniform vec4 color : source_color = vec4(1.0); // Color del contorno
uniform float width : hint_range(0, 10) = 1.0; // Grosor del contorno
uniform int pattern : hint_range(0, 2) = 0; // 0: diamante, 1: círculo, 2: cuadrado
uniform bool inside = false; // Si el contorno se dibuja por dentro
uniform bool add_margins = true; // Solo útil si el contorno va por fuera
uniform vec2 number_of_images = vec2(1.0); // Para spritesheets con animaciones
uniform float glow_strength : hint_range(0.0, 2.0) = 0.4; // Intensidad del "glow" simulado

// === VARIABLES INTERNAS ===
varying flat vec4 modulate; // Color modulado por vertex()

// === DESPLAZAMIENTO DE VÉRTICES PARA OUTLINE EXTERNO ===
void vertex() {
	modulate = COLOR;

	if (add_margins) {
		if ((UV.x <= 0.0 || UV.x >= 1.0) && (UV.y <= 0.0 || UV.y >= 1.0)) {
			VERTEX += (UV * 2.0 - 1.0) * width;
		} else {
			VERTEX += sign(VERTEX) * width;
		}
	}
}

// === DETECCIÓN DE BORDES PARA APLICAR CONTORNO ===
bool hasContraryNeighbour(vec2 uv, vec2 texture_pixel_size, vec2 image_top_left, vec2 image_bottom_right, sampler2D texture) {
	for (float i = -ceil(width); i <= ceil(width); i++) {
		float x = abs(i) > width ? width * sign(i) : i;
		float offset;

		if (pattern == 0) {
			offset = width - abs(x); // diamante
		} else if (pattern == 1) {
			offset = floor(sqrt(pow(width + 0.5, 2.0) - x * x)); // círculo
		} else {
			offset = width; // cuadrado
		}

		for (float j = -ceil(offset); j <= ceil(offset); j++) {
			float y = abs(j) > offset ? offset * sign(j) : j;
			vec2 xy = uv + texture_pixel_size * vec2(x, y);

			// Comprueba si el píxel vecino es diferente (alpha)
			if ((xy != clamp(xy, image_top_left, image_bottom_right) || texture(texture, xy).a <= 0.0) == inside) {
				return true;
			}
		}
	}
	return false;
}

// === FRAGMENTO: APLICA COLOR, CONTORNO Y GLOW ===
void fragment() {
	vec2 uv = UV;
	vec2 image_top_left = floor(uv * number_of_images) / number_of_images;
	vec2 image_bottom_right = image_top_left + vec2(1.0) / number_of_images;

	// Ajuste UV si hay margen
	if (add_margins) {
		vec2 texture_pixel_size = vec2(1.0) / (vec2(1.0) / TEXTURE_PIXEL_SIZE + vec2(width * 2.0) * number_of_images);
		uv = (uv - texture_pixel_size * width - image_top_left) * TEXTURE_PIXEL_SIZE / texture_pixel_size + image_top_left;

		if (uv != clamp(uv, image_top_left, image_bottom_right)) {
			COLOR.a = 0.0;
		} else {
			COLOR = texture(TEXTURE, uv) * modulate;
		}
	} else {
		COLOR = texture(TEXTURE, uv) * modulate;
	}

	// Aplica contorno
	if ((COLOR.a > 0.0) == inside && hasContraryNeighbour(uv, TEXTURE_PIXEL_SIZE, image_top_left, image_bottom_right, TEXTURE)) {
		COLOR.rgb = inside ? mix(COLOR.rgb, color.rgb * modulate.rgb, color.a * modulate.a) : color.rgb * modulate.rgb;
		COLOR.a += (1.0 - COLOR.a) * color.a * modulate.a;
	}

	// Simula glow aumentando el brillo del color
	COLOR.rgb += COLOR.rgb * glow_strength;
}
