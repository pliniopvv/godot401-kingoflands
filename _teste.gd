extends Node3D


func _ready():
	var noise = FastNoiseLite.new()
	print(noise.get_noise_2d(0.5,0.5))
	pass # Replace with function body.


func _process(delta):
	pass
