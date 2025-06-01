extends NodeState

@export var character : NonPlayableCharacter
@export var animated_sprite_2d: AnimatedSprite2D 
@export var navigation_agent_2d : NavigationAgent2D
@export var min_speed : float = 7.0
@export var max_speed : float = 15.0

var speed: float

func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(on_safe_velocity_computed)  # Conecta la señal para calcular velocidad segura con evitación de obstáculos
	call_deferred("character_setup")  # Espera a que se cargue toda la escena antes de configurar
	navigation_agent_2d.avoidance_enabled = true  # Habilita evitación de obstáculos

func character_setup() -> void:
	await get_tree().physics_frame  # Espera un frame de física
	set_movement_target()  # Asigna un nuevo objetivo de movimiento

func set_movement_target() -> void:
	# Elige un punto aleatorio dentro del mapa de navegación y lo asigna como objetivo
	var target_position : Vector2 = NavigationServer2D.map_get_random_point(navigation_agent_2d.get_navigation_map(), navigation_agent_2d.navigation_layers, false)
	navigation_agent_2d.target_position = target_position
	speed = randf_range(min_speed, max_speed)  # Asigna una velocidad aleatoria dentro del rango

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	# Lógica para mover al personaje hacia su objetivo
	if navigation_agent_2d.is_navigation_finished():
		character.current_walk_cycle += 1  # Aumenta el contador de ciclos
		set_movement_target()  # Asigna un nuevo objetivo
		return
			
	var target_position = navigation_agent_2d.get_next_path_position()
	var target_direction = character.global_position.direction_to(target_position)
	var velocity : Vector2 = target_direction * speed

	if navigation_agent_2d.avoidance_enabled:
		animated_sprite_2d.flip_h = velocity.x < 0  # Gira el sprite según dirección
		navigation_agent_2d.velocity = velocity  # Mueve usando navegación con evitación
	else:
		character.velocity = velocity
		character.move_and_slide()  # Movimiento básico

func on_safe_velocity_computed(safe_velocity : Vector2) -> void:
	# Si la navegación calcula una velocidad segura, se aplica aquí
	animated_sprite_2d.flip_h = safe_velocity.x < 0
	character.velocity = safe_velocity
	character.move_and_slide()

func _on_next_transitions() -> void:
	# Cambia al estado Idle cuando se completan todos los ciclos de caminata
	if character.current_walk_cycle == character.walk_cycles:
		character.velocity = Vector2.ZERO
		transition.emit("Idle")

func _on_enter() -> void:
	animated_sprite_2d.play("walk")  # Reproduce animación de caminar

func _on_exit() -> void:
	animated_sprite_2d.stop()  # Detiene la animación al salir del estado
