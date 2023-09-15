@tool
extends Node3D

@export_category("Configurações gerais")
@export var qtd_chunks = 1
@export_category("Cfg das chunks individuais")
@export var size_chunks = Vector2(12,12)
@export var altura_chunks = 5

var map = {}
@onready var chunk = preload("res://nodes/terrain/chunk.tscn")

@onready var grama: Texture2D = preload("res://assets/texture/grass.jpg")
@onready var deserto: Texture2D = preload("res://assets/texture/sand.jpg")

var flip_flop = true

func _ready():
	var surfacetool = SurfaceTool.new()
	surfacetool.begin(Mesh.PRIMITIVE_TRIANGLES)
	generate_chunks(surfacetool)

var noise: FastNoiseLite
func generate_chunks(surfacetool: SurfaceTool):
	var noise = FastNoiseLite.new()
	noise.frequency = 0.007
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	
	for x in range(qtd_chunks*2-1):
		for z in range(qtd_chunks*2-1):
			surfacetool.begin(Mesh.PRIMITIVE_TRIANGLES)
			if not map.has(Vector2(x,z)):
				if (flip_flop):
					set_mat(surfacetool,grama)
					flip_flop = false
				else:
					set_mat(surfacetool,deserto)
					flip_flop = true
				
				var c = chunk.instantiate()
				c.size = size_chunks
				c.altura = altura_chunks
				var posChunk = Vector2(x, z)
				c.generate_terrain(noise, surfacetool, posChunk)
				map[posChunk] = c
				add_child(c)

func _process(delta):
	pass

func set_mat(st:SurfaceTool, texture:Texture2D):
		var mat = StandardMaterial3D.new()
		mat.albedo_texture = texture
		st.set_material(mat)
