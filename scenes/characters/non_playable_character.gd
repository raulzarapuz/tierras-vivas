class_name NonPlayableCharacter extends CharacterBody2D

@export var min_walk_cycle : int = 2  # Ciclos mínimos de caminata
@export var max_walk_cycle : int = 6  # Ciclos máximos de caminata

var walk_cycles : int  # Número total de ciclos de movimiento asignados
var current_walk_cycle : int  # Contador actual, al llegar a walk_cycles se pasa a estado Idle
