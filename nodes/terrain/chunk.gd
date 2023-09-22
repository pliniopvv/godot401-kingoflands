extends MeshInstance3D
class_name GenericChunk

@export_category("Configurações iniciais")
@export var grama: Texture2D
@export var deserto: Texture2D
@export var humidade: NoiseTexture2D
@export var size = Vector2(12,12)
@export var lod = 5
@export var altura = 5.0

var center_terrain = size/2
var noise_detail = 12.0

var uvx = 0
var uvz = 0


func _ready():
	pass

func generate_terrain(noise: FastNoiseLite, st:SurfaceTool, pos:Vector2):
	for _z in range(lod+1):
		if uvz == 0: uvz = 1
		else: uvz = 0
		for _x in range(lod+1):
			var bLod = Vector2(size.x/lod, size.y/lod)
			var bLodPos = Vector2(_x*bLod.x, _z*bLod.y)
			var pontoNaMesh = Vector2(pos.x*size.x+(bLodPos.x-center_terrain.x), pos.y*size.y+(bLodPos.y-center_terrain.y))
			var y = noise.get_noise_2d(pontoNaMesh.x, pontoNaMesh.y) * altura
			
			if uvx == 0: uvx = 1
			else: uvx = 0
			var uv = Vector2(uvx, uvz)
			st.set_uv(uv)
			
			var vertex = Vector3(pontoNaMesh.x, y, pontoNaMesh.y)
			st.add_vertex(vertex)
	
	var vert = 0
	for z in range(lod):
		for x in range(lod):
			st.add_index(vert+0)
			st.add_index(vert+1)
			st.add_index(vert+lod+1)
			st.add_index(vert+lod+1)
			st.add_index(vert+1)
			st.add_index(vert+lod+2)
			vert+=1
		vert+=1
	
	st.generate_normals()
	
	mesh = st.commit()
	
	create_trimesh_collision()
	
	var sm = ShaderMaterial.new()
	sm.shader = preload("res://nodes/terrain/chunk.gdshader")
#	sm.set_shader_parameter("teste", teste)
	sm.set_shader_parameter("grama", grama)
	sm.set_shader_parameter("deserto", deserto)
	
	var fn = FastNoiseLite.new()
	#fn.offset = Vector3(pos.x*size.x-center_terrain.x,pos.y*size.y-center_terrain.y,0.0)
	fn.offset = Vector3(pos.x*size.x,pos.y*size.y,0.0)
	fn.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH	
	fn.frequency = 0.001
	
	humidade = NoiseTexture2D.new()
	humidade.width = noise_detail
	humidade.height = noise_detail
	humidade.noise = fn
	humidade.normalize = false

	sm.set_shader_parameter("humidade", humidade)
	sm.set_shader_parameter("pos", pos)
	
	sm.set_shader_parameter("size", Vector2(noise_detail,noise_detail))
	
	st.set_material(sm)
	mesh.surface_set_material(0, sm)
	
	st.clear()

@export var update: bool = false
func _process(delta):
	if update:
		update = false
	pass

func set_lod(_lod:int):
	lod = _lod

func get_center():
	return center_terrain
