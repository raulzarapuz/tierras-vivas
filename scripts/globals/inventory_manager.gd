extends Node

var inventory : Dictionary = Dictionary()  # Diccionario que representa el inventario

signal inventory_changed  # Señal que se emite cuando cambia el inventario

func add_collectable(collectable_name : String) -> void:
	inventory.get_or_add(collectable_name)  # Añade el objeto al diccionario si no existe
	
	# Aumenta la cantidad del objeto
	if inventory[collectable_name] == null:
		inventory[collectable_name] = 1
	else:
		inventory[collectable_name] += 1
		
	inventory_changed.emit()  # Emite la señal de cambio

func remove_collectable(collectable_name : String) -> void:
	inventory.get_or_add(collectable_name)  # Asegura que la clave existe
	
	# Reduce la cantidad del objeto si es mayor a 0
	if inventory[collectable_name] == null:
		inventory[collectable_name] = 0
	else:
		if inventory[collectable_name] > 0:
			inventory[collectable_name] -= 1
		
	inventory_changed.emit()  # Emite la señal de cambio
