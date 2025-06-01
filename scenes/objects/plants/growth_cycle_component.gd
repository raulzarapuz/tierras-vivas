class_name GrowthCycleComponent extends Node  # Script que gestiona el crecimiento de los cultivos

@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination  # Estado actual del cultivo
@export_range(5,365) var days_util_harvest: int = 7  # Días necesarios para cosechar

signal crop_maturity  # Señal que se emite cuando el cultivo madura
signal crop_harvesting  # Señal que se emite cuando se puede cosechar

var is_waterd: bool  # Indica si ha sido regado
var starting_day: int
var current_day: int

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)  # Se conecta al sistema de día y noche

func on_time_tick_day(day: int) -> void:
	if is_waterd:  # Solo avanza si se ha regado
		if starting_day == 0:
			starting_day = day
		growth_states(starting_day, day)  # Calcula el estado de crecimiento según los días
		harvest_states(starting_day, day)  # Verifica si está listo para cosechar

func growth_states(starting_day: int, current_day: int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return
	
	var num_states = 5  # Número total de estados de crecimiento
	
	var growth_days_passed = (current_day - starting_day) % num_states  # Días desde que empezó a crecer
	var state_index = growth_days_passed % num_states + 1  # Índice del estado actual

	current_growth_state = state_index  # Se actualiza el estado de crecimiento
	var name = DataTypes.GrowthStates.keys()[current_growth_state]
	print("Current growth state: ", name, " state index: ", state_index)
	
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit()  # Se emite la señal de madurez

func harvest_states(starting_day: int, current_day: int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Harvesting:
		return
		
	var days_passed = (current_day - starting_day) % days_util_harvest
	
	if days_passed == days_util_harvest - 1:
		current_growth_state = DataTypes.GrowthStates.Harvesting  # ← Aquí faltaba un "=" para asignar
		crop_harvesting.emit()  # Se emite la señal de cosecha

func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state  # Devuelve el estado actual del cultivo
