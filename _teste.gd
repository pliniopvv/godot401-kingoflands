extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var noise = FastNoiseLite.new()
#	noise.seed = 1
	print(noise.get_noise_2d(0.5,0.5))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
