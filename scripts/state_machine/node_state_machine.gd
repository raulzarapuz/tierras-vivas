class_name NodeStateMachine extends Node

@export var initial_node_state : NodeState  # Estado inicial de la máquina

var node_states : Dictionary = {}  # Diccionario que guarda todos los estados
var current_node_state : NodeState  # Estado actual
var current_node_state_name : String  # Nombre del estado actual

func _ready() -> void:
	for child in get_children():
		if child is NodeState:
			node_states[child.name.to_lower()] = child  # Añade el estado al diccionario
			child.transition.connect(transition_to)  # Conecta la señal de transición a la función que cambia de estado
	
	if initial_node_state:
		initial_node_state._on_enter()  # Entra en el estado inicial
		current_node_state = initial_node_state

func _process(delta : float) -> void:
	if current_node_state:
		current_node_state._on_process(delta)  # Llama a la lógica de proceso del estado actual

func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state._on_physics_process(delta)  # Lógica física del estado actual
		current_node_state._on_next_transitions()  # Verifica si se debe cambiar de estado

func transition_to(node_state_name : String) -> void:
	if node_state_name == current_node_state.name.to_lower():
		return  # Si ya está en ese estado, no hace nada
	
	var new_node_state = node_states.get(node_state_name.to_lower())
	
	if !new_node_state:
		return  # Si no existe el estado, no hace nada
	
	if current_node_state:
		current_node_state._on_exit()  # Sale del estado actual
	
	new_node_state._on_enter()  # Entra al nuevo estado
	
	current_node_state = new_node_state
	current_node_state_name = current_node_state.name.to_lower()  # Guarda el nombre del nuevo estado
