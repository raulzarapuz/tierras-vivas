extends NonPlayableCharacter

func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)  # Asigna un número aleatorio de ciclos de caminata al NPC al empezar
