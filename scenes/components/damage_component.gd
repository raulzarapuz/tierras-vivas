class_name DamageComponent extends Node2D # componente que maneja el daño que puede recibir un objeto

@export var max_damage = 1 # daño máximo que puede recibir antes de romperse o eliminarse
@export var current_damage = 0 # daño actual acumulado

signal max_damaged_reached # señal que se emite cuando el daño máximo ha sido alcanzado

func apply_damage(damage : int) -> void:
	current_damage = clamp(current_damage + damage, 0, max_damage) # suma el daño recibido y se asegura de que no pase del máximo ni sea menor que 0
	
	if current_damage == max_damage:
		max_damaged_reached.emit() # si el daño acumulado llega al máximo, emite una señal para avisar
