class_name DayNightCycleComponent
extends CanvasModulate

# Día inicial del juego. Cuando se cambia desde el editor, también actualiza el sistema de ciclo día-noche.
@export var initial_day: int = 1:
	set(id):
		initial_day = id
		DayAndNightCycleManager.initial_day = id
		DayAndNightCycleManager.set_initial_time()

# Hora inicial del juego. También actualiza el sistema de tiempo cuando se modifica.
@export var initial_hour: int = 12:
	set(ih):
		initial_hour = ih
		DayAndNightCycleManager.initial_hour = ih
		DayAndNightCycleManager.set_initial_time()

# Minuto inicial del juego. Se comunica con el sistema de tiempo al cambiar.
@export var initial_minute: int = 30:
	set(im):
		initial_minute = im
		DayAndNightCycleManager.initial_minute = im
		DayAndNightCycleManager.set_initial_time()

# Textura de gradiente usada para modificar los colores del filtro según la hora del día
@export var day_night_gradient_texture: GradientTexture1D

func _ready() -> void:
	# Al iniciar, se establecen los valores iniciales del sistema de tiempo
	DayAndNightCycleManager.initial_day = initial_day
	DayAndNightCycleManager.initial_hour = initial_hour
	DayAndNightCycleManager.initial_minute = initial_minute
	DayAndNightCycleManager.set_initial_time()
	
	# Conectamos el sistema para que cuando cambie el tiempo, se actualice el color del filtro
	DayAndNightCycleManager.game_time.connect(on_game_time)

func on_game_time(time: float) -> void:
	# Se calcula un valor entre 0 y 1 usando seno para simular el ciclo día/noche suavemente
	var sample_value = 0.5 * (sin(time - PI * 0.5) + 1.0)
	
	# Se obtiene el color del gradiente según el momento del día y se aplica al filtro
	color = day_night_gradient_texture.gradient.sample(sample_value)
