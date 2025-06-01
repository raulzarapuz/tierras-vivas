extends Node

# Constantes para controlar el tiempo del juego
const MINUTES_PER_DAY : int  = 24 * 60 # Total de minutos en un día
const MINUTES_PER_HOUR : int = 60 # Total de minutos en una hora
const GAME_MINUTE_DURATION: float = TAU / MINUTES_PER_DAY # Duración de un minuto en el juego, para crear un ciclo completo con TAU (2*PI)

var game_speed: float = 5.0 # Velocidad a la que avanza el tiempo en el juego

# Hora inicial del juego (día 1 a las 12:30)
var initial_day: int = 1
var initial_hour: int = 12
var initial_minute: int = 30

# Variables para el seguimiento del tiempo
var time: float = 0.0 # Tiempo acumulado en el juego
var current_minute: int = -1 # Minuto actual (se usa para detectar cambios)
var current_day: int = 0 # Día actual

# Señales para comunicar el cambio de tiempo a otras partes del juego
signal game_time(time: float) # Envía el tiempo acumulado para cosas como cambiar filtros de pantalla
signal time_tick(day: int, hour: int, minute: int) # Se emite cada minuto con la hora exacta
signal time_tick_day(day: int) # Se emite cuando cambia el día

func _ready() -> void:
	set_initial_time() # Configura el tiempo inicial al iniciar el juego
	
func _process(delta: float) -> void:
	# Se actualiza el tiempo cada frame según la velocidad establecida
	time += delta * game_speed * GAME_MINUTE_DURATION
	game_time.emit(time) # Se emite el tiempo para que otros nodos puedan usarlo
	recalculate_time() # Se recalculan los valores de día, hora y minuto

func set_initial_time() -> void:
	# Convierte la hora inicial en minutos y la aplica al tiempo acumulado
	var initial_total_minutes = initial_day * MINUTES_PER_DAY + (initial_hour * MINUTES_PER_HOUR) + initial_minute
	time = initial_total_minutes * GAME_MINUTE_DURATION
	
func recalculate_time() -> void:
	# Convierte el tiempo acumulado en minutos del juego
	var total_minutes: int = int(time / GAME_MINUTE_DURATION)
	
	# Calcula el día actual
	var day: int = int(total_minutes / MINUTES_PER_DAY)
	# Minutos dentro del día actual
	var current_day_minutes: int = int(total_minutes % MINUTES_PER_DAY)
	
	# Calcula la hora y los minutos actuales
	var hour: int = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute: int = int(current_day_minutes % MINUTES_PER_HOUR)
	
	# Solo emite señales si cambia el minuto
	if current_minute != minute:
		current_minute = minute
		time_tick.emit(day, hour, minute) # Envía la nueva hora
	
	# Solo emite señal si cambia el día
	if current_day != day:
		current_day = day
		time_tick_day.emit(day) # Envía el nuevo día
