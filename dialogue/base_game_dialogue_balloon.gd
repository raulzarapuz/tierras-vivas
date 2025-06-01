class_name BaseGameDialogueBalloon extends CanvasLayer
## Globo de diálogo básico para usar con Dialogue Manager

## Acción para avanzar el diálogo
@export var next_action: StringName = &"ui_accept"

## Acción para saltar la escritura del diálogo
@export var skip_action: StringName = &"ui_cancel"

## Recurso de diálogo
var resource: DialogueResource

## Estados temporales del juego
var temporary_game_states: Array = []

## Si está esperando al jugador
var is_waiting_for_input: bool = false

## Si se está ejecutando una mutación larga y debe ocultarse el globo
var will_hide_balloon: bool = false

## Diccionario para variables temporales
var locals: Dictionary = {}

var _locale: String = TranslationServer.get_locale()

## Línea de diálogo actual
var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
			apply_dialogue_line()  # Aplica la nueva línea de diálogo
		else:
			queue_free()  # Si no hay más diálogo, se cierra el globo
	get:
		return dialogue_line

## Temporizador para retrasar el cierre del globo si hay una mutación
var mutation_cooldown: Timer = Timer.new()

## Nodo visual del globo
@onready var balloon: Control = %Balloon

## Nombre del personaje que habla
@onready var character_label: RichTextLabel = %CharacterLabel

## Texto del diálogo
@onready var dialogue_label: DialogueLabel = %DialogueLabel

## Menú de respuestas
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu


func _ready() -> void:
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

	# Si el menú de respuestas no tiene acción para avanzar, se le pone la acción por defecto
	if responses_menu.next_action.is_empty():
		responses_menu.next_action = next_action

	mutation_cooldown.timeout.connect(_on_mutation_cooldown_timeout)
	add_child(mutation_cooldown)


func _unhandled_input(_event: InputEvent) -> void:
	# Solo el globo puede manejar la entrada cuando está activo
	get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	## Si cambia el idioma, actualiza la línea de diálogo visible
	if what == NOTIFICATION_TRANSLATION_CHANGED and _locale != TranslationServer.get_locale() and is_instance_valid(dialogue_label):
		_locale = TranslationServer.get_locale()
		var visible_ratio = dialogue_label.visible_ratio
		self.dialogue_line = await resource.get_next_dialogue_line(dialogue_line.id)
		if visible_ratio < 1:
			dialogue_label.skip_typing()


## Comienza un diálogo nuevo
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states = [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Aplica cambios visuales cuando cambia la línea de diálogo
func apply_dialogue_line() -> void:
	mutation_cooldown.stop()

	is_waiting_for_input = false
	balloon.focus_mode = Control.FOCUS_ALL
	balloon.grab_focus()

	character_label.visible = not dialogue_line.character.is_empty()
	character_label.text = tr(dialogue_line.character, "dialogue")

	dialogue_label.hide()
	dialogue_label.dialogue_line = dialogue_line

	responses_menu.hide()
	responses_menu.responses = dialogue_line.responses

	# Muestra el globo de diálogo
	balloon.show()
	will_hide_balloon = false

	dialogue_label.show()
	if not dialogue_line.text.is_empty():
		dialogue_label.type_out()
		await dialogue_label.finished_typing

	# Espera entrada del jugador
	if dialogue_line.responses.size() > 0:
		balloon.focus_mode = Control.FOCUS_NONE
		responses_menu.show()
	elif dialogue_line.time != "":
		var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
		await get_tree().create_timer(time).timeout
		next(dialogue_line.next_id)
	else:
		is_waiting_for_input = true
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()


## Ir a la siguiente línea
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


#region Signals


func _on_mutation_cooldown_timeout() -> void:
	if will_hide_balloon:
		will_hide_balloon = false
		balloon.hide()


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	mutation_cooldown.start(0.1)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# Si el diálogo se está escribiendo, permite saltar el texto
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	# Si ya ha terminado de escribir y no hay respuestas, se puede avanzar
	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)


#endregion
