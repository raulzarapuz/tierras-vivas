extends NonPlayableCharacter

func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)  # Al iniciar, asigna un número aleatorio de ciclos de caminata
