class_name NodeDataResource extends Resource

# Guarda la posición global del nodo
@export var global_position: Vector2
# Ruta del nodo en el árbol de la escena
@export var node_path: NodePath
# Ruta del nodo padre
@export var parent_node_path: NodePath

# Esta función guarda datos del nodo que se pasa como parámetro
# Guarda su posición global y las rutas del nodo y su padre
func _save_data(node: Node2D) -> void:
	global_position = node.global_position
	node_path = node.get_path()
	
	var parent_node = node.get_parent()
	
	if parent_node != null:
		parent_node_path = parent_node.get_path() # Guarda la ruta completa del nodo padre

# Esta función está vacía, pero se usará para cargar los datos más adelante
func _load_data(_window: Window) -> void:
	pass
