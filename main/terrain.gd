extends Node3D

@export_category("Configurações gerais")
@export var load_distance = 1
@export var grama: Texture2D
@export var deserto: Texture2D
@export_category("Cfg das chunks individuais")
@export var size_chunks = Vector2(12,12)
@export var altura_chunks = 5
@export var lod = 5
@export var flat = false

@onready var chunk = preload("res://nodes/terrain/chunk.tscn")

var map = {}
var pos = Vector2(0,0)
var player: CharacterBody3D
var surfacetool: SurfaceTool
var noise: FastNoiseLite

func set_player(p: CharacterBody3D):
	player = p

func _ready():
		surfacetool = SurfaceTool.new()
		noise = FastNoiseLite.new()
		noise.frequency = 0.07
		noise.noise_type = FastNoiseLite.TYPE_PERLIN
		generate_chunks(pos)

func generate_chunks(pos: Vector2):
	for x in range(load_distance*2+1):
		for z in range(load_distance*2+1):
			var fx = floor(pos.x+x-load_distance)
			var fz = floor(pos.y+z-load_distance)
			surfacetool.begin(Mesh.PRIMITIVE_TRIANGLES)
			if not map.has(Vector2(fx,fz)):
				#criação das chunks
				var pC = Vector2(fx,fz)
				var chunk = generate_chunk(noise, surfacetool, pC)
				map[pC] = chunk
				add_child(chunk)

func _process(delta):
	var chunk_pos = floor(Vector2(player.position.x,player.position.z)/size_chunks)
	if pos != chunk_pos:
		pos = chunk_pos
		generate_chunks(pos)

func generate_chunk(noise:FastNoiseLite, surfacetool: SurfaceTool, posChunk: Vector2):
	var c = chunk.instantiate()
	c.size = size_chunks
	c.altura = altura_chunks
	c.lod = lod
	c.flat = flat
	c.GenerateTerrain(noise, surfacetool, posChunk)
	return c
