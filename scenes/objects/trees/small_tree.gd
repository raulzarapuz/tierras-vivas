class_name SmallTree extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent  # Componente que detecta si el árbol recibe daño
@onready var damage_component: DamageComponent = $DamageComponent  # Componente que aplica el daño real

@export var log = preload("res://Scenes/objects/trees/log.tscn")  # Escena del tronco que aparece al talar el árbol

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)

func on_hurt(damage: int) -> void:
	damage_component.apply_damage(damage)
	material.set_shader_parameter("shake_intensity", 0.8)  # Aplica un efecto de sacudida visual
	await get_tree().create_timer(1.0).timeout  # Espera 1 segundo
	material.set_shader_parameter("shake_intensity", 0.0)  # Quita el efecto

func on_max_damaged_reached() -> void:
	call_deferred("add_log_scene")  # Llama a la función para crear el tronco
	queue_free()  # Elimina el árbol

func add_log_scene() -> void:
	var log_instantiate = log.instantiate() as Node2D
	log_instantiate.global_position = global_position
	get_parent().add_child(log_instantiate)  # Añade el tronco en la misma posición
