extends NodeState

@export var player : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

var direction : Vector2

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	direction = GameInputEvents.movement_input()  # Obtiene la dirección del movimiento del jugador

	# Según la dirección, reproduce la animación de idle correspondiente
	if direction == Vector2.UP:
		animated_sprite_2d.play("idle_back")
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("idle_front")
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("idle_left")
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("idle_right")
	else:
		animated_sprite_2d.play("idle_front")

func _on_next_transitions() -> void:
	GameInputEvents.movement_input()  # Llama a la función (aunque este resultado no se usa)
	
	if GameInputEvents.is_movement_input():
		transition.emit("Walk")  # Cambia al estado de caminar si hay movimiento

func _on_enter() -> void:
	pass

func _on_exit() -> void:
	animated_sprite_2d.stop()  # Detiene la animación al salir del estado
