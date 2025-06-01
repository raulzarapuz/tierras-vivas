class_name SaveLevelDataComponent extends Node

# Nombre de la escena actual
var level_scene_name: String

# Ruta donde se guardarán los datos del juego
var save_game_data_path: String = "user://game_data/"

# Formato del nombre del archivo de guardado
var save_file_name : String = "save_%s_game_data.tres"

# Recurso donde se almacenará la información del nivel (no hace falta exportarlo)
var game_data_resource: SaveGameDataResource

func _ready() -> void:
	# Añade este nodo al grupo para que el SaveGameManager pueda acceder a él
	add_to_group("save_level_data_component")
	
	# Guarda el nombre del nodo padre (que normalmente es la escena raíz)
	level_scene_name = get_parent().name

func save_node_data() -> void:
	# Obtiene todos los nodos que están en el grupo "save_data_component"
	var nodes = get_tree().get_nodes_in_group("save_data_component")
	
	# Crea un nuevo recurso que almacenará los datos del nivel
	game_data_resource = SaveGameDataResource.new()
	
	# Si hay nodos para guardar, recorre cada uno
	if nodes != null:
		for node: SaveDataComponent in nodes:
			if node is SaveDataComponent:
				# Llama al método _save_data() del nodo para obtener los datos a guardar
				var save_data_resource: NodeDataResource = node._save_data()
				# Duplica el recurso para asegurarse de no modificar el original
				var save_final_resource = save_data_resource.duplicate()
				# Añade el recurso al array de nodos guardados del nivel
				game_data_resource.save_data_nodes.append(save_final_resource)

func save_game() -> void:
	# Si la carpeta donde se guardarán los archivos no existe, se crea
	if !DirAccess.dir_exists_absolute(save_game_data_path):
		DirAccess.make_dir_absolute(save_game_data_path)
	
	# Se construye el nombre del archivo según la escena actual
	var level_save_file_name: String = save_file_name % level_scene_name
	
	# Guarda todos los nodos con datos
	save_node_data()
	
	# Guarda el recurso en el archivo usando ResourceSaver
	var result: int = ResourceSaver.save(game_data_resource, save_game_data_path + level_save_file_name)
	print("save result:", result)

func load_game() -> void:
	# Construye la ruta al archivo de guardado
	var level_save_file_name: String = save_file_name % level_scene_name
	var save_game_path: String = save_game_data_path + level_save_file_name
	
	# Si el archivo no existe, salimos
	if !FileAccess.file_exists(save_game_path):
		return
	
	# Cargamos el recurso desde el archivo
	game_data_resource = ResourceLoader.load(save_game_path)
	
	# Si la carga falla, salimos
	if game_data_resource == null:
		return
	
	# Obtenemos el nodo raíz de la escena actual
	var root_node: Window = get_tree().root
	
	# Recorremos todos los recursos guardados
	for resource in game_data_resource.save_data_nodes:
		# Solo nos interesan los que son del tipo adecuado
		if resource is Resource:
			if resource is NodeDataResource:
				# Restauramos los datos del nodo usando el método _load_data()
				resource._load_data(root_node)
