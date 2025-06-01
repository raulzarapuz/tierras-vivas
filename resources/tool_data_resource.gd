class_name ToolDataResource extends NodeDataResource

@export var isDisable: bool  # Guarda si los botones están deshabilitados
@export var a: Control.FocusMode  # Guarda el modo de enfoque del botón

func _save_data(node: Node2D) -> void:
	super._save_data(node)
	
	# Guarda el estado de los botones (deshabilitado y modo de enfoque)
	for tool_button: Button in node.get_children():
		isDisable = tool_button.disabled
		a = tool_button.focus_mode

func _load_data(window: Window) -> void:
	var scene_node = window.get_node_or_null(node_path)
	
	if scene_node != null:
		# Restaura el estado de los botones
		for tool_button: Button in scene_node.get_children():
			tool_button.disabled = isDisable
			tool_button.focus_mode = a
