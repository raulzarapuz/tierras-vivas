class_name Rock extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent  # Componente que detecta daño recibido
@onready var damage_component: DamageComponent = $DamageComponent  # Componente que aplica el daño

@export var stone = preload("res://Scenes/objects/rocks/stone.tscn")  # Escena de la piedra que aparece tras romper la roca

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)

func on_hurt(damage: int) -> void:
	damage_component.apply_damage(damage)
	material.set_shader_parameter("shake_intensity", 0.7)  # Aplica efecto de sacudida
	await get_tree().create_timer(0.5).timeout  # Espera medio segundo
	material.set_shader_parameter("shake_intensity", 0.0)  # Quita el efecto

func on_max_damaged_reached() -> void:
	call_deferred("add_log_scene")  # Crea el objeto de piedra
	queue_free()  # Elimina la roca original

func add_log_scene() -> void:
	var stone_instantiate = stone.instantiate() as Node2D
	stone_instantiate.global_position = global_position
	get_parent().add_child(stone_instantiate)  # Añade la piedra en la misma posición
