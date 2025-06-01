extends Node

@export var mouse: Texture2D  # Textura personalizada para el cursor

func _ready() -> void:
	Input.set_custom_mouse_cursor(mouse, Input.CURSOR_ARROW)  # Establece el cursor personalizado en forma de flecha
