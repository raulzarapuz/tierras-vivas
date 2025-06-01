extends Node

# Esta variable indica si se permite guardar la partida o no
var allow_save_game: bool

# Detecta si se ha pulsado la tecla asociada a "save_game"
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		save_game()

# Función para guardar la partida
func save_game() -> void:
	# Busca el nodo que pertenece al grupo "save_level_data_component"
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	
	# Si se encuentra el nodo, se llama a su función para guardar la partida
	if save_level_data_component != null:
		save_level_data_component.save_game()

# Función para cargar la partida
func load_game() -> void:
	# Espera un frame para asegurar que la escena esté completamente cargada
	await get_tree().process_frame 
	
	# Busca el nodo del grupo "save_level_data_component"
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	
	# Si existe, se llama a su función para cargar los datos guardados
	if save_level_data_component != null:
		save_level_data_component.load_game()
