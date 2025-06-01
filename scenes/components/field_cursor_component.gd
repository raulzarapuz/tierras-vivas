class_name FieldCursorComponent extends Node

@export var grass: TileMapLayer
@export var tilled_soil: TileMapLayer
@export var terrain_set: int = 0  # Conjunto de terreno dentro del TileMapLayer
@export var terrain: int = 3  # Índice del terreno (tipo de tierra que queremos colocar)

var player: Player  # Se obtiene el jugador al iniciar

var mouse_position: Vector2  # Posición del ratón
var cell_position: Vector2i  # Coordenadas de la celda en el mapa de tiles
var cell_source_id: int  # ID del tile en esa celda, -1 si está vacía
var local_cell_position: Vector2  # Posición local del centro de la celda
var distance: float  # Distancia del jugador a la celda

func _ready() -> void:
	await get_tree().physics_frame
	player = get_tree().get_first_node_in_group("player")  # Busca al jugador a través del grupo, útil si están en escenas distintas

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_hit"):  # Ctrl + click izquierdo
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_tilled_soil_cell()
	elif event.is_action_pressed("hit"):  # Click izquierdo normal
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			add_tilled_soil_cell()

func get_cell_under_mouse() -> void:
	mouse_position = grass.get_local_mouse_position()
	cell_position = grass.local_to_map(mouse_position)
	cell_source_id = grass.get_cell_source_id(cell_position)
	local_cell_position = grass.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	print("mouse ", mouse_position, " cell ", cell_position, " cell_id ", cell_source_id)

func add_tilled_soil_cell() -> void:
	if distance <= 20 and cell_source_id != -1:
		# Añade tierra arada en la celda si está dentro del alcance y hay césped
		tilled_soil.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)

func remove_tilled_soil_cell() -> void:
	if distance <= 20 and cell_source_id != -1:
		# Reemplaza el terreno arado por vacío (código 0) en esa celda
		tilled_soil.set_cells_terrain_connect([cell_position], terrain_set, 0, true)
