extends Node3D

@export_category("Configurações gerais")
@export var chunks_fog = 0
@export var grama: Texture2D
@export var deserto: Texture2D
@export_category("Cfg das chunks individuais")
@export var size_chunks = Vector2(12,12)
@export var altura_chunks = 5
@export var lod_chunks = 5

var map = {}
@onready var chunk = preload("res://nodes/terrain/chunk.tscn")

func _ready():
	generate_chunks(Vector2(0,0))


func generate_chunks(pos: Vector2):
	var surfacetool = SurfaceTool.new()
	surfacetool.begin(Mesh.PRIMITIVE_TRIANGLES)
	var noise = FastNoiseLite.new()
	noise.frequency = 0.07
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	
	for x in range(chunks_fog*2+1):
		for z in range(chunks_fog*2+1):
			var fx = floor(pos.x+x-chunks_fog)
			var fz = floor(pos.y+z-chunks_fog)
			surfacetool.begin(Mesh.PRIMITIVE_TRIANGLES)
			if not map.has(Vector2(fx,fz)):
				#criação das chunks
				var pC = Vector2(fx,fz)
				var chunk = generate_chunk(noise, surfacetool, pC)
				map[pC] = chunk
				add_child(chunk)

func _process(delta):
	pass

func generate_chunk(noise:FastNoiseLite, surfacetool: SurfaceTool, posChunk: Vector2):
	var c = chunk.instantiate()
	c.size = size_chunks
	c.altura = altura_chunks
	c.lod = lod_chunks
	c.generate_terrain(noise, surfacetool, posChunk)
	return c
