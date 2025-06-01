extends Node2D

# Carga la escena del maiz ya cosechable
var corn_harvest_scene = preload("res://Scenes/objects/plants/corn_harvest.tscn")

# Referencias a los nodos hijos
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles # Particulas que salen al regar
@onready var flowering_particles: GPUParticles2D = $FloweringParticles # Particulas que salen cuando la planta florece
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent

# Estado actual del crecimiento de la planta
var growth_state : DataTypes.GrowthStates = DataTypes.GrowthStates.Seed

func _ready() -> void:
	# Desactiva los efectos de particulas al iniciar
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	# Conecta señales para reaccionar cuando se riega o madura
	hurt_component.hurt.connect(on_hurt)
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)

func _process(delta: float) -> void:
	# Actualiza el estado de crecimiento y cambia el sprite
	growth_state = growth_cycle_component.get_current_growth_state()
	sprite_2d.frame = growth_state
	
	# Si la planta esta madura, activa las particulas de flor
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true

# Se llama cuando la planta es regada
func on_hurt(damage:int)->void:
	if !growth_cycle_component.is_waterd:
		watering_particles.emitting = true
		await get_tree().create_timer(5.0).timeout
		watering_particles.emitting = false
		growth_cycle_component.is_waterd = true
		
# Se llama cuando la planta madura
func on_crop_maturity() -> void:
	flowering_particles.emitting = true

# Se llama cuando se cosecha la planta
func on_crop_harvesting() -> void:
	var corn_harvest = corn_harvest_scene.instantiate() as Node2D
	corn_harvest.global_position = global_position
	get_parent().add_child(corn_harvest)
	queue_free()
