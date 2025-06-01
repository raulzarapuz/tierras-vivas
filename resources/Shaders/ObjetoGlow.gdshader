shader_type canvas_item;

// Color que parpadea al resaltar el sprite
uniform vec4 highlight_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Controla el tiempo entre cada parpadeo
uniform float frequency : hint_range(0.0, 25.0) = 0.35;

// Velocidad de cada parpadeo
uniform float highlight_speed : hint_range(0.0, 25.0) = 6.0;

// Área que cubre cada parpadeo (ancho)
uniform float highlight_width : hint_range(0.0, 50.0) = 15.0;

void fragment()
{
	vec4 input_color = texture(TEXTURE, UV);
	float width = 0.001 * frequency * highlight_width / 2.0;
	
	// Puedes cambiar el signo de cada UV
	// para controlar la dirección del parpadeo
	// Ej: -UV.x - UV.y hace que el parpadeo vaya
	// de la esquina superior izquierda a la inferior derecha
	float value = floor(sin(frequency * ((UV.x - UV.y) + TIME * highlight_speed)) + width);
	
	// Controla si usar el color original o el color de resaltado
	float highlight = value > 0.5 ? 1.0 : 0.0;
	vec3 new_color = input_color.rgb * (1.0 - highlight) + highlight_color.rgb * highlight;
	COLOR = vec4(new_color, input_color.a);
}
