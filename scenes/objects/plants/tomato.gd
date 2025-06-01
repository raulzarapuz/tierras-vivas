extends Node2D

var tomato_harvest_scene = preload("res://Scenes/objects/plants/tomato_harvest.tscn")  # Escena del tomate maduro

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles  # Partículas de riego
@onready var flowering_particles: GPUParticles2D = $FloweringParticles  # Partículas de floración
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent

var growth_state : DataTypes.GrowthStates = DataTypes.GrowthStates.Seed  # Estado inicial: semilla

func _ready() -> void:
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	hurt_component.hurt.connect(on_hurt)  # Conecta la detección de riego
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)  # Conecta al llegar a madurez
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)  # Conecta al estar listo para cosecha

func _process(delta: float) -> void:
	growth_state = growth_cycle_component.get_current_growth_state()
	sprite_2d.frame = growth_state + 6  # Actualiza el sprite según el estado de crecimiento
	
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true  # Muestra partículas de floración

func on_hurt(damage: int) -> void:
	if !growth_cycle_component.is_waterd:  # Si no ha sido regado, emite partículas y marca como regado
		watering_particles.emitting = true
		await get_tree().create_timer(5.0).timeout
		watering_particles.emitting = false
		growth_cycle_component.is_waterd = true

func on_crop_maturity() -> void:
	flowering_particles.emitting = true  # Activa las partículas de floración

func on_crop_harvesting() -> void:
	var tomato_harvest = tomato_harvest_scene.instantiate() as Node2D
	tomato_harvest.global_position = global_position
	get_parent().add_child(tomato_harvest)  # Aparece un tomate maduro
	queue_free()  # Elimina la planta original
