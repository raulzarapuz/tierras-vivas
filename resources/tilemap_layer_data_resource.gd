class_name TileMapLayerDataResource
extends NodeDataResource

# Almacena las celdas que contienen tiles en el TileMap
@export var tilemap_layer_used_cells: Array[Vector2i] 
@export var terrain_set: int = 0 # ID del conjunto de terreno utilizado
@export var terrain: int = 3     # ID del tipo de terreno (por ejemplo, tierra arada)

# Función que guarda la información del nodo
func _save_data(node: Node2D) -> void:
	super._save_data(node) # Llama al método del padre para guardar posición y rutas básicas
	
	var tilemap_layer: TileMapLayer = node as TileMapLayer 
	var cells: Array[Vector2i] = tilemap_layer.get_used_cells() # Obtiene las coordenadas de todas las celdas que contienen tiles
	
	tilemap_layer_used_cells = cells # Guarda esas celdas en la variable del recurso

# Función que restaura los datos guardados
func _load_data(window: Window) -> void:
	var scene_node = window.get_node_or_null(node_path) # Busca el nodo original por su ruta
	
	if scene_node != null:
		var tilemap_layer: TileMapLayer = scene_node as TileMapLayer
		# Vuelve a colocar los tiles en sus posiciones guardadas, con el mismo tipo de terreno
		tilemap_layer.set_cells_terrain_connect(tilemap_layer_used_cells, terrain_set, terrain, true)
