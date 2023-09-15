@tool
extends Node3D

#@onready var chunk = preload("res://nodes/terrain/chunk.tscn")
@export_category("Configs")

var map = {}
@onready var pos = Vector2(0,0)

@onready var grama: Texture2D = preload("res://assets/texture/grass.jpg")
@onready var deserto: Texture2D = preload("res://assets/texture/sand.jpg")

var flip_flop = true

@onready var surfacetool = SurfaceTool.new()
@onready var qtd_chunks = 2
func _ready():
	surfacetool.begin(Mesh.PRIMITIVE_TRIANGLES)
	generate_chunks(pos, qtd_chunks)
	
func generate_chunks(pos: Vector2, qtd_chunks: int):
	for x in range(qtd_chunks):
		for z in range(qtd_chunks):
			var _x = pos.x + x - qtd_chunks/2
			var _z = pos.y + z - qtd_chunks/2
			if not map.has(Vector2(_x,_z)):
				
				if (flip_flop):
					set_mat(surfacetool,grama)
					flip_flop = false
				else:
					set_mat(surfacetool,deserto)
					flip_flop = true
				
#				var c = GenericChunk.new(surfacetool, _x, _z)
				var c = GenericChunk.new()
				c.generate_chunk(surfacetool, _x, _z)
				map[Vector2(_x,_z)] = c
				add_child(c)
	
func _process(delta):
	pass

func set_mat(st:SurfaceTool, texture:Texture2D):
		var mat = StandardMaterial3D.new()
		mat.albedo_texture = texture
		st.set_material(mat)
