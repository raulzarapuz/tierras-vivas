extends Control

# Referencias a las etiquetas que muestran el día y la hora
@onready var day_label: Label = $DayPanel/DayLabel
@onready var time_label: Label = $TimePanel/TimeLabel

# Velocidades configurables para el paso del tiempo en el juego
@export var normal_speed: int = 8       # Velocidad normal
@export var fast_speed: int = 25        # Velocidad rápida
@export var cheetah_speed: int = 100    # Velocidad muy rápida (modo guepardo)

func _ready() -> void:
	# Escucha el evento que se lanza cada minuto en el juego
	DayAndNightCycleManager.time_tick.connect(on_time_tick)

# Actualiza los textos del panel con el día y la hora actual
func on_time_tick(day: int, hour: int, minute: int) -> void:
	day_label.text = "DAY " + str(day)
	time_label.text = "%02d:%02d" % [hour, minute] # Formato tipo 00:00

# Cambia la velocidad del juego a normal cuando se presiona el botón
func _on_normal_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = normal_speed

# Cambia la velocidad del juego a rápida cuando se presiona el botón
func _on_fast_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = fast_speed

# Cambia la velocidad del juego a modo guepardo cuando se presiona el botón
func _on_cheetah_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = cheetah_speed
