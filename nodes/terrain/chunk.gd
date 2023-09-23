extends MeshInstance3D
class_name GenericChunk

@export_category("Configurações iniciais")
@export_group("Texturas")
@export var grama: Texture2D = preload("res://assets/texture/grass2.jpg")
@export var deserto: Texture2D = preload("res://assets/texture/sand.jpg")
@export var humidade: NoiseTexture2D
@export_group("Valores iniciais")
@export var size = Vector2(12.0,12.0)
@export var lod = 5
@export var altura = 5.0
@export var flat = false

var center_terrain = size/2

var uvx = 0
var uvz = 0

func _ready():
	pass

func generate_terrain(noise: FastNoiseLite, st:SurfaceTool, posOrigin:Vector2):
	for _z in range(lod+1):
		if uvz == 0: uvz = 1
		else: uvz = 0
		for _x in range(lod+1):
			var unid = size/lod
			var unidPos = Vector2(_x, _z) * unid
			var pontoNaMesh = posOrigin *size +unidPos -center_terrain #Vector2(posOrigin.x*size.x+(unidPos.x-center_terrain.x), posOrigin.y*size.y+(unidPos.y-center_terrain.y))
			
			var y = 0
			if not flat:
				y = noise.get_noise_2d(pontoNaMesh.x, pontoNaMesh.y) * altura
			
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
	st.clear()
	
	create_trimesh_collision()
	
	var sm = ShaderMaterial.new()
	sm.shader = preload("res://nodes/terrain/chunk.gdshader")
#	sm.set_shader_parameter("teste", teste)
	sm.set_shader_parameter("grama", grama)
	sm.set_shader_parameter("deserto", deserto)
	
	var fn = FastNoiseLite.new()
	fn.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	fn.frequency = 0.01
	fn.fractal_gain = 0.8
	fn.fractal_octaves = 8
	#fn.offset = Vector3(posOrigin.x*size.x-center_terrain.x,posOrigin.y*size.y-center_terrain.y,0.0)
	fn.offset = Vector3(posOrigin.x*size.x,posOrigin.y*size.y,0.0)
	
	humidade = NoiseTexture2D.new()
	humidade.width = size.x
	humidade.height = size.y
	humidade.noise = fn
	humidade.normalize = false

	sm.set_shader_parameter("humidade", humidade)
	sm.set_shader_parameter("origin", posOrigin)
	sm.set_shader_parameter("size", size)
	mesh.surface_set_material(0, sm)
	

@export var update: bool = false
func _process(delta):
	if update:
		update = false
	pass

func set_lod(_lod:int):
	lod = _lod

func get_center():
	return center_terrain
