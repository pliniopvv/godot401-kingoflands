@tool
extends MeshInstance3D

@export var size = 6

func _ready():
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for z in range(size/2+1):
		for x in range(size/2+1):
			var y = 0
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
	pass


func _process(delta):
	pass
