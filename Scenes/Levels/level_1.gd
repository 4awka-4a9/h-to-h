extends Node2D

@onready var song = $AudioStreamPlayer2D

func _ready() -> void:
	song.play()
