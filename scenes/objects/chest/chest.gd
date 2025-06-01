extends Node2D

var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")  # Carga la escena del globo de diálogo

var corn_harvest_scene = preload("res://Scenes/objects/plants/corn_harvest.tscn")  # Cosecha de maíz
var tomato_harvest_scene = preload("res://Scenes/objects/plants/tomato_harvest.tscn")  # Cosecha de tomate

@export var dialogue_start_command: String
@export var food_drop_height: int = 40  # Altura desde la que caen los objetos al alimentar
@export var reward_output_radius: int = 20  # Radio en el que aparecen las recompensas
@export var output_reward_scenes: Array[PackedScene] = []  # Lista de escenas que se usarán como recompensa

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var feed_component: FeedComponent = $FeedComponent
@onready var reward_marker: Marker2D = $RewardMarker
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool
var is_chest_open: bool

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()
	
	GameDialogueManager.feed_the_animals.connect(on_feed_the_animals)  # Conecta la señal para alimentar a los animales
	feed_component.food_received.connect(on_food_received)

func on_interactable_activated() -> void:
	interactable_label_component.show()  # Muestra el texto de interacción
	in_range = true

func on_interactable_deactivated() -> void:
	if is_chest_open:
		animated_sprite_2d.play("chest_close")  # Cierra el cofre si estaba abierto
	
	is_chest_open = false
	interactable_label_component.hide()
	in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("show_dialogue"):
			interactable_label_component.hide()
			animated_sprite_2d.play("chest_open")  # Anima la apertura del cofre
			is_chest_open = true
			
			# Crea y muestra un globo de diálogo
			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate() 
			get_tree().root.add_child(balloon)
			balloon.start(load("res://dialogue/conversations/chest.dialogue"), dialogue_start_command)

func on_feed_the_animals() -> void:
	if in_range:
		# Lanza los objetos de cosecha al alimentar a los animales
		trigger_feed_harvest("corn", corn_harvest_scene)
		trigger_feed_harvest("tomato", tomato_harvest_scene)

func trigger_feed_harvest(inventory_item: String, scene: Resource) -> void: 
	var inventory: Dictionary = InventoryManager.inventory
	
	if !inventory.has(inventory_item):
		return
	
	var inventory_item_count = inventory[inventory_item]
	
	for index in inventory_item_count:
		var harvest_instance = scene.instantiate() as Node2D
		harvest_instance.global_position = Vector2(global_position.x, global_position.y - food_drop_height)
		get_tree().root.add_child(harvest_instance)
		var target_position = global_position
		
		var time_delay = randf_range(0.5, 2.0)  # Espera aleatoria antes de mover la cosecha
		await get_tree().create_timer(time_delay).timeout
		
		var tween = get_tree().create_tween()
		tween.tween_property(harvest_instance, "position", target_position, 1.0)
		tween.tween_property(harvest_instance, "scale", Vector2(0.5, 0.5), 1.0)
		tween.tween_callback(harvest_instance.queue_free)  # Borra la instancia al acabar
		
		InventoryManager.remove_collectable(inventory_item)  # Elimina el ítem del inventario

func on_food_received(area: Area2D) -> void:
	call_deferred("add_reward_scene")  # Añade las recompensas tras alimentar

func add_reward_scene() -> void:
	for scene in output_reward_scenes:
		var reward_scene: Node2D = scene.instantiate()
		var reward_position: Vector2 = get_random_position_in_circle(reward_marker.global_position, reward_output_radius)
		reward_scene.global_position = reward_position
		get_tree().root.add_child(reward_scene)  # Aparece la recompensa en una posición aleatoria

func get_random_position_in_circle(center: Vector2, radius: int) -> Vector2i:
	var angle = randf() * TAU
	var distance_from_center = sqrt(randf()) * radius
	
	var x: int = center.x + distance_from_center * cos(angle)
	var y: int = center.y + distance_from_center * sin(angle)
	
	return Vector2i(x, y)  # Devuelve una posición aleatoria dentro de un círculo
