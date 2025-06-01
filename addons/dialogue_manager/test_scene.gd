class_name BaseDialogueTestScene extends Node2D

const DialogueSettings = preload("./settings.gd")  # Configuración del diálogo
const DialogueResource = preload("./dialogue_resource.gd")  # Recurso de diálogo

@onready var title: String = DialogueSettings.get_user_value("run_title")  # Título del diálogo a ejecutar
@onready var resource: DialogueResource = load(DialogueSettings.get_user_value("run_resource_path"))  # Ruta del recurso de diálogo

func _ready():
	if not Engine.is_embedded_in_editor:
		# Centra la ventana en pantalla si no está en el editor
		var window: Window = get_viewport()
		var screen_index: int = DisplayServer.get_primary_screen()
		window.position = Vector2(DisplayServer.screen_get_position(screen_index)) + (DisplayServer.screen_get_size(screen_index) - window.size) * 0.5
		window.mode = Window.MODE_WINDOWED

	var dialogue_manager = Engine.get_singleton("DialogueManager")
	dialogue_manager.dialogue_ended.connect(_on_dialogue_ended)  # Conecta la señal cuando finaliza el diálogo
	dialogue_manager.show_dialogue_balloon(resource, title if not title.is_empty() else resource.first_title)  # Inicia el diálogo

func _enter_tree() -> void:
	DialogueSettings.set_user_value("is_running_test_scene", false)  # Marca que ya no se está ejecutando la escena de prueba

#region Signals

func _on_dialogue_ended(_resource: DialogueResource):
	get_tree().quit()  # Cierra el juego cuando termina el diálogo

#endregion
