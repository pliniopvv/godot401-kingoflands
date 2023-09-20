extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var noise: FastNoiseLite

func get_noise():
	if noise == null:
		noise = FastNoiseLite.new()
		noise.frequency = 0.01
		noise.fractal_octaves = 8
		noise.fractal_gain = 0.2
		noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	return noise

func get_noiseTexture(xoff:float,yoff:float):
	var nt = NoiseTexture2D.new()
	var fn = get_noise()
	fn.offset = Vector3(xoff,0.0,yoff)
	nt.noise = fn
	nt.normalize = false
	return nt
