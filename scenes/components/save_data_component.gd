class_name SaveDataComponent extends Node

# Se guarda una referencia al nodo padre (normalmente el nodo que queremos guardar)
@onready var parent_node : Node2D = get_parent() as Node2D

# Recurso donde se guarda la información del nodo (puede ser de tipo NodeDataResource o SceneDataResource)
@export var save_data_resource : Resource

func _ready() -> void:
	# Añade este nodo al grupo "save_data_component" automáticamente cuando se instancia
	add_to_group("save_data_component")

# Función que se llama para guardar los datos del nodo
func _save_data() -> Resource:
	# Si no hay nodo padre, no se puede guardar nada
	if parent_node == null:
		return null
	
	# Si no se ha asignado ningún recurso, muestra un error y no guarda
	if save_data_resource == null:
		push_error("save_data_resource:", save_data_resource, parent_node.name)
		return null
	
	# Llama a la función de guardado del recurso, pasándole el nodo padre
	save_data_resource._save_data(parent_node)
	
	# Devuelve el recurso con la información guardada
	return save_data_resource
