extends Node3D

@export_category("Configurações gerais")
@export var qtd_chunks = 1
@export var grama: Texture2D
@export var deserto: Texture2D
@export_category("Cfg das chunks individuais")
@export var size_chunks = Vector2(12,12)
@export var altura_chunks = 5
@export var lod_chunks = 5

var map = {}
@onready var chunk = preload("res://nodes/terrain/chunk.tscn")

var flip_flop = true

func _ready():
	var surfacetool = SurfaceTool.new()
	surfacetool.begin(Mesh.PRIMITIVE_TRIANGLES)
	generate_chunks(surfacetool)

var noise: FastNoiseLite
func generate_chunks(surfacetool: SurfaceTool):
	var noise = FastNoiseLite.new()
	noise.frequency = 0.07
	noise.noise_type = FastNoiseLite.TYPE_PERLIN

	for x in range(qtd_chunks*2-1):
		for z in range(qtd_chunks*2-1):
			surfacetool.begin(Mesh.PRIMITIVE_TRIANGLES)
			if not map.has(Vector2(x,z)):
				
				var c = chunk.instantiate()
				c.size = size_chunks
				c.altura = altura_chunks
				c.lod = lod_chunks
				
				if (flip_flop):
					flip_flop = !flip_flop
					c.teste = 1.0
				else:
					flip_flop = !flip_flop
					c.teste = 0.0
				
				var posChunk = Vector2(x, z)
				var s = c.GenerateTerrain(noise, surfacetool, posChunk)
				map[posChunk] = c
				add_child(c)

func _process(delta):
	pass
