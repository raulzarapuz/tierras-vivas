extends Timer

@export var audio:AudioStreamPlayer2D  # Referencia a un nodo de audio

func _on_timeout() -> void:
	audio.play()  # Reproduce el sonido cada vez que se activa el temporizador
