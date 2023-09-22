extends Node3D

@export var terrain: Node3D
@export var player: CharacterBody3D

func _ready():
	terrain.player = player
	pass

func _process(delta):
	pass
