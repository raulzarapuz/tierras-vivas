extends Node

# Variable que guarda la herramienta actualmente seleccionada
var selected_tool : DataTypes.Tools = DataTypes.Tools.None

# Señal que se emite cuando se selecciona una herramienta
signal tool_selected(tool:DataTypes.Tools)

# Señal que se emite para activar una herramienta desde fuera
signal enable_tool(tool:DataTypes.Tools)

# Funcion para seleccionar una herramienta. Emite la señal y guarda la seleccion
func select_tool(tool:DataTypes.Tools) -> void:
	tool_selected.emit(tool)
	selected_tool = tool

# Funcion para activar una herramienta desde fuera (por ejemplo, cuando el jugador avanza en el juego)
func enable_tool_button(tool:DataTypes.Tools) -> void:
	enable_tool.emit(tool)
