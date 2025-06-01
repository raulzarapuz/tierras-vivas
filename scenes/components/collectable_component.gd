# Define esta clase como 'CollectableComponent' y hereda de Area2D, lo que le permite detectar colisiones con otros cuerpos.
class_name CollectableComponent extends Area2D

# Variable exportada que puedes cambiar desde el editor. Representa el nombre del objeto coleccionable (por ejemplo, "gema", "llave", etc.).
@export var collectable_name : String

# Esta función se ejecuta automáticamente cuando un cuerpo entra en el área de colisión del objeto.
func _on_body_entered(body: Node2D) -> void:
	# Verifica si el objeto que ha entrado en contacto es el jugador.
	if body is Player: 
		# Añade el objeto al inventario a través del sistema InventoryManager, usando su nombre.
		InventoryManager.add_collectable(collectable_name)

		# Muestra en la consola qué objeto fue recogido, útil para pruebas y depuración.
		print("collectable: ", collectable_name)

		# Elimina el nodo padre del objeto (es decir, hace desaparecer el coleccionable de la escena).
		get_parent().queue_free()
