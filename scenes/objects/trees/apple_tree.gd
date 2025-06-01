extends SmallTree

@export var apple = preload("res://Scenes/objects/trees/apple.tscn")  # Se carga la escena de la manzana

func on_max_damaged_reached() -> void:
	call_deferred("add_apple_scene")  # Cuando se tala el árbol, se añade la manzana
	super()

func add_apple_scene() -> void:
	var apple_instantiate = apple.instantiate() as Node2D
	apple_instantiate.global_position = global_position + Vector2(4,8)
	get_parent().add_child(apple_instantiate)  # Se coloca la manzana en el mundo encima del árbol
