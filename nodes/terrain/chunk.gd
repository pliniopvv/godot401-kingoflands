@tool
extends MeshInstance3D
class_name GenericChunk

@export_category("Configurações iniciais")
@export var size = 12
@export var texture : Texture2D

var uvx = 0
var uvz = 0

#func _init(st:SurfaceTool, offsetx: int, offsety: int):
#	_st = st
#	_offsetx = offsetx
#	_offsety = offsety

func _ready():
	pass
#	generate_chunk(_st,size/2*_offsetx, size/2*_offsety)
#	generate_chunk(st, size/2*0, size/2*0)

func generate_chunk(st:SurfaceTool, offsetx:int, offsety:int):
	var dx = size/2*offsetx
	var dy = size/2*offsety
	
	for _z in range(size/2+1):
		if uvz == 0: uvz = 1
		else: uvz = 0
		for _x in range(size/2+1):
			var x = dx+_x
			var z = dy+_z
			var y = 0
			
			if uvx == 0: uvx = 1
			else: uvx = 0
			var uv = Vector2(uvx, uvz)
			st.set_uv(uv)
			
			var vertex = Vector3(x,y,z)
			st.add_vertex(vertex)
			
	var vert = 0
	for z in size/2:
		for x in size/2:
			st.add_index(vert+0)
			st.add_index(vert+1)
			st.add_index(vert+size/2+1)
			st.add_index(vert+size/2+1)
			st.add_index(vert+1)
			st.add_index(vert+size/2+2)
			vert+=1	
		vert+=1
			
	st.generate_normals()
	mesh = st.commit()

func _process(delta):
	pass
