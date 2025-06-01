extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var interactable_component: InteractableComponent = $InteractableComponent


func _ready() -> void:
	# Conecta las señales de interacción al entrar o salir del área
	interactable_component.interactable_activated.connect(_on_interactable_activated)
	interactable_component.interactable_deactivated.connect(_on_interactable_deactivated)
	collision_layer = 1  # Capa de colisión por defecto
	
func _on_interactable_activated():
	animated_sprite_2d.play("open_door")  # Anima la puerta abriéndose
	collision_layer = 2  # Cambia la capa de colisión (por ejemplo, para atravesarla)

func _on_interactable_deactivated():
	animated_sprite_2d.play("close_door")  # Anima la puerta cerrándose
	collision_layer = 1  # Vuelve a la capa original
