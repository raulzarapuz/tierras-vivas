class_name SceneDataResource extends NodeDataResource

# Nombre del nodo
@export var node_name: String
# Ruta del archivo de escena (.tscn)
@export var scene_file_path: String

# Esta función guarda información adicional del nodo,
# además de lo que ya guarda la clase padre (posición, rutas)
func _save_data(node: Node2D) -> void:
	super._save_data(node)  # Llama a la función de la clase padre
	
	node_name = node.name  # Guarda el nombre del nodo
	scene_file_path = node.scene_file_path  # Guarda la ruta del archivo de escena original

# Esta función carga los datos guardados y reconstruye el nodo en la escena
func _load_data(window: Window) -> void:
	var parent_node: Node2D
	var scene_node: Node2D
	
	# Busca el nodo padre en la escena usando la ruta guardada
	if parent_node_path != null:
		parent_node = window.get_node_or_null(parent_node_path)

	# Si hay una ruta al nodo, carga el recurso de escena y lo instancia
	if node_path != null:
		var scene_file_resource: Resource = load(scene_file_path)
		scene_node = scene_file_resource.instantiate() as Node2D

	# Si se han encontrado ambos nodos, coloca el nodo en la posición guardada y lo añade como hijo
	if parent_node != null and scene_node != null:
		scene_node.global_position = global_position
		parent_node.add_child(scene_node)
