class_name DataTypes

# Definimos los tipos de herramientas disponibles en el juego
enum Tools {
	None,           # Sin herramienta seleccionada
	AxeWood,        # Hacha para cortar árboles
	TillGround,     # Azada para arar la tierra
	WaterCrops,     # Regadera para regar los cultivos
	PlantCorn,      # Semilla de maíz
	PlantTomato     # Semilla de tomate
}

# Definimos las distintas etapas del crecimiento de una planta
enum GrowthStates {
	Seed,           # Etapa inicial, la semilla
	Germination,    # Cuando empieza a germinar
	Vegetative,     # Fase de crecimiento con hojas
	Reproduction,   # Ya está más desarrollada
	Maturity,       # La planta está madura
	Harvesting      # Lista para cosechar
}
