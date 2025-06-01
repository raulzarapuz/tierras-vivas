class_name CropsCursorComponent extends Node

# TileMap donde se ha labrado la tierra
@export var tilled_soil: TileMapLayer
@export var terrain_set: int = 0 # índice del conjunto de terreno en el TileMap
@export var terrain: int = 3     # tipo de terreno que se va a usar

var player: Player # referencia al jugador

# Precarga de las escenas de cultivos
@onready var corn = preload("res://Scenes/objects/plants/corn.tscn")
@onready var tomato = preload("res://Scenes/objects/plants/tomato.tscn")

# Variables para almacenar la posición del ratón, celdas del mapa y distancia
var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _ready() -> void:
	# Espera un frame de física para asegurarse de que todo está cargado
	await get_tree().physics_frame
	player = get_tree().get_first_node_in_group("player") # busca el nodo del jugador

func _unhandled_input(event: InputEvent) -> void:
	# Si se pulsa la acción para quitar cultivos
	if event.is_action_pressed("remove_hit"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_crop()
	# Si se pulsa la acción para plantar cultivos
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn or ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			get_cell_under_mouse()
			add_crop()

func get_cell_under_mouse() -> void:
	# Obtiene la posición del ratón en el TileMap
	mouse_position = tilled_soil.get_local_mouse_position()
	# Convierte esa posición a coordenadas de celda del TileMap
	cell_position = tilled_soil.local_to_map(mouse_position)
	# Obtiene el ID de la celda en esa posición
	cell_source_id = tilled_soil.get_cell_source_id(cell_position)
	# Convierte la posición de celda a posición local
	local_cell_position = tilled_soil.map_to_local(cell_position)
	# Calcula la distancia del jugador a esa celda
	distance = player.global_position.distance_to(local_cell_position)

func add_crop() -> void:
	if distance < 20:
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
			var corn_instance = corn.instantiate() as Node2D
			corn_instance.global_position = local_cell_position
			get_parent().find_child("CropsField").add_child(corn_instance) # lo añade al nodo donde están todos los cultivos
		if ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			var tomato_instance = tomato.instantiate() as Node2D
			tomato_instance.global_position = local_cell_position
			get_parent().find_child("CropsField").add_child(tomato_instance)

func remove_crop() -> void:
	if distance < 20:
		# Busca todos los cultivos ya plantados
		var crop_nodes = get_parent().find_child("CropsField").get_children()
		for i: Node2D in crop_nodes:
			if i.global_position == local_cell_position:
				queue_free() # elimina el cultivo que esté en esa posición
