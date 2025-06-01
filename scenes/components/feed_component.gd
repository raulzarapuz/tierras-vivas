class_name FeedComponent extends Area2D

signal food_received(area: Area2D)  # Señal que se emite cuando entra comida en el área

func _on_area_entered(area: Area2D) -> void:
	food_received.emit(area)  # Emite la señal al detectar que algo ha entrado (comida)
