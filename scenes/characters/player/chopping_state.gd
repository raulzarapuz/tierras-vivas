extends NodeState

@export var player : Player
@export var animated_sprite_2d: AnimatedSprite2D 
@export var hit_component_collision_shape : CollisionShape2D  # Área de impacto del golpe

func _ready() -> void:
	hit_component_collision_shape.disabled = true  # Se desactiva por defecto
	hit_component_collision_shape.position = Vector2(0,0)

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")  # Cuando termina la animación, pasa al estado Idle

func _on_enter() -> void:
	# Según la dirección del jugador, se reproduce la animación de cortar correspondiente
	# y se coloca el área de impacto en una posición relativa distinta
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("chopping_back")
		hit_component_collision_shape.position = Vector2(0,-18)
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("chopping_front")
		hit_component_collision_shape.position = Vector2(0,3)
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("chopping_left")
		hit_component_collision_shape.position = Vector2(-9,-3)
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("chopping_right")
		hit_component_collision_shape.position = Vector2(9,-3)
	else:
		animated_sprite_2d.play("chopping_front")
	hit_component_collision_shape.disabled = false  # Activa el área de golpeo

func _on_exit() -> void:
	animated_sprite_2d.stop()  # Detiene la animación
	hit_component_collision_shape.disabled = true  # Desactiva el área de impacto
