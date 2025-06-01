extends Node

var game_menu_screen = preload("res://Scenes/ui/game_menu_screen.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		set_game_menu_screen()

func start_game() -> void:
	SceneManager.load_main_scene_container()
	SceneManager.load_level("Level2")
	await get_tree().process_frame
	SaveGameManager.load_game()
	SaveGameManager.allow_save_game = true

func exit_game() -> void:
	get_tree().quit()

func set_game_menu_screen() -> void:
	# Evita abrir otro menú si ya hay uno activo
	if get_tree().root.has_node("GameMenuScreen"):
		return

	var game_menu = game_menu_screen.instantiate()
	game_menu.name = "GameMenuScreen"  # Importante: así podemos detectarlo por nombre
	get_tree().root.add_child(game_menu)
