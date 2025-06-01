extends Node

# Ruta al archivo principal del juego
var main_scene_path :String = "res://Scenes/main_scene.tscn"

# Ruta en la escena donde se carga el contenedor principal
#var main_scene_level_root:String = "/root/MainScene"
var main_scene_root_path:String = "/root/MainScene"
var main_scene_level_root_path : String = "/root/MainScene/GameRoot/LevelRoot"

# Diccionario con los niveles disponibles y su ruta
var level_scenes:Dictionary = {
	"Level2" : "res://Scenes/levels/level_2.tscn"
}

# Carga el contenedor principal del juego si aún no existe
func load_main_scene_container() -> void:
	if get_tree().root.has_node(main_scene_root_path):  # Evita cargarlo dos veces
		return
	
	var node:Node = load(main_scene_path).instantiate()
	
	if node != null:
		get_tree().root.add_child(node)  # Añade el contenedor principal a la escena

# Carga un nivel dentro del contenedor principal
func load_level(level:String) -> void:
	var scene_path:String = level_scenes.get(level)  # Busca la ruta del nivel
	
	if scene_path == null:
		return
	
	var level_scene:Node = load(scene_path).instantiate()  # Carga e instancia el nivel
	var level_root:Node = get_node(main_scene_level_root_path)  # Nodo donde se añaden los niveles

	if level_root != null:
		var nodes = level_root.get_children()  # Borra todos los nodos anteriores del nivel
		
		if nodes != null:
			for node: Node in nodes:
				node.queue_free()  # Elimina cada nodo del nivel anterior

		await get_tree().process_frame  # Espera un frame para asegurarse de que se han eliminado

	level_root.add_child(level_scene)  # Añade el nuevo nivel cargado al contenedor
