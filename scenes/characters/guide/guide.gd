extends Node2D

# Guardamos la referencia al componente que detecta cuando el jugador se acerca
@onready var interactable_component: InteractableComponent = $InteractableComponent

# Referencia al letrero que aparece cuando te puedes acercar y hablar
@onready var interactable_label_component: Control = $InteractableLabelComponent

# Esta es la escena del globo de diálogo que se muestra cuando hablas
var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")

# Esta variable se usa para saber si el jugador está cerca del NPC
var in_range: bool

func _ready() -> void:
	# Conectamos las señales de cuando el jugador entra o sale del rango de interacción
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	
	# Ocultamos el letrero hasta que el jugador se acerque
	interactable_label_component.hide()

	# Conectamos esta señal para dar herramientas cuando el diálogo lo indique
	GameDialogueManager.give_crop_seeds.connect(on_give_crop_seeds)

# Cuando el jugador se acerca, mostramos el letrero y marcamos que está en rango
func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

# Cuando el jugador se aleja, ocultamos el letrero y marcamos que ya no está en rango
func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false

# Este código se ejecuta cuando se pulsa una tecla (como la E para hablar)
func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("show_dialogue"):
			# Instanciamos el globo de diálogo
			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
			get_tree().root.add_child(balloon)
			
			# Cargamos el diálogo del archivo .dialogue y empezamos desde el nodo "start"
			balloon.start(load("res://dialogue/conversations/guide.dialogue"), "start")

# Esta función se llama cuando el diálogo activa la señal para dar semillas
func on_give_crop_seeds() -> void:
	# Activamos varias herramientas que ahora puede usar el jugador
	ToolManager.enable_tool_button(DataTypes.Tools.TillGround)
	ToolManager.enable_tool_button(DataTypes.Tools.WaterCrops)
	ToolManager.enable_tool_button(DataTypes.Tools.PlantCorn)
	ToolManager.enable_tool_button(DataTypes.Tools.PlantTomato)
