extends CanvasLayer

@onready var save_game_button = $MarginContainer/VBoxContainer/VBoxContainer2/SaveGameButton
#@onready var volume_slider =  $MarginContainer/VBoxContainer/VBoxContainer2/Volumen
#@onready var fullscreen_checkbox =  $MarginContainer/VBoxContainer/VBoxContainer2/Fullscreen
#@onready var windowed_checkbox =  $MarginContainer/VBoxContainer/VBoxContainer2/Windowed

func _ready() -> void:
	save_game_button.disabled = !SaveGameManager.allow_save_game
	save_game_button.focus_mode = SaveGameManager.allow_save_game if Control.FOCUS_ALL else Control.FOCUS_NONE 

	# Establecer volumen inicial
	#var db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	#volume_slider.value = db_to_linear(db) * 100.0
	#print("Volumen inicial: ", volume_slider.value)

	# Establecer modo de pantalla inicial
	#var mode = DisplayServer.window_get_mode()
	#fullscreen_checkbox.button_pressed = mode == DisplayServer.WINDOW_MODE_FULLSCREEN
	#windowed_checkbox.button_pressed = mode == DisplayServer.WINDOW_MODE_WINDOWED
	#print("Modo de pantalla inicial:", mode)

func _on_start_game_button_pressed() -> void:
	print("Start Game pulsado")
	GameManager.start_game()
	queue_free()

func _on_save_game_button_pressed() -> void:
	print("Guardar partida pulsado")
	SaveGameManager.save_game()

func _on_exit_game_button_pressed() -> void:
	print("Salir del juego pulsado")
	GameManager.exit_game()

func _on_Volumen_value_changed(value):
	var db = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)
	print("Volumen cambiado a: ", value, " → ", db, " dB")

#func _on_Fullscreen_toggled(pressed):
#	print("Fullscreen toggled: ", pressed)
#	if pressed:
#		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
#		windowed_checkbox.button_pressed = false

#func _on_Windowed_toggled(pressed):
#	print("Windowed toggled: ", pressed)
#	if pressed:
#		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
#		fullscreen_checkbox.button_pressed = false

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_cancel"):
		#if self.visible:
			#print("Escape detectado en menú: ya visible, ignorado.")
			#return
		#print("Escape detectado, mostrando menú.")
		#self.visible = true
		#get_tree().paused = true
