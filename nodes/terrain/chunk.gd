extends MeshInstance3D
class_name GenericChunk

@export_category("Configurações iniciais")
@export_group("Texturas")
@export var grama: Texture2D = preload("res://assets/texture/grass2.jpg")
@export var deserto: Texture2D = preload("res://assets/texture/sand.jpg")
@export var humidade: NoiseTexture2D
@export_group("Valores iniciais")
@export var size = Vector2(12.0,12.0)
@export var resolution = 5
@export var altura = 5.0
@export var flat = false

var center_terrain = size/2
var center_offset = 0.5

var uvx = 0
var uvz = 0

func _ready():
	pass

func generate_terrain(bnoise: FastNoiseLite, noise: FastNoiseLite, st:SurfaceTool, posOrigin:Vector2):
	var mSize = Vector3(size.x, 1.0, size.y)
	position = Vector3(posOrigin.x, 0, posOrigin.y) * mSize
	for _z in range(resolution+1):
		for _x in range(resolution+1):
			var percent = Vector2(_x,_z)/resolution
			var pontoNaMesh = Vector3((percent.x-center_offset), 0, (percent.y-center_offset))
			if not flat:
				pontoNaMesh.y = noise.get_noise_2d(posOrigin.x+pontoNaMesh.x, posOrigin.y+pontoNaMesh.z) * altura * resolution
			var vertex = pontoNaMesh * mSize
			
			var uv = Vector2(0,0)
			uv.x = percent.x
			uv.y = percent.y
			
			st.set_uv(uv)
			st.add_vertex(vertex)
	
	var vert = 0
	for z in range(resolution):
		for x in range(resolution):
			st.add_index(vert+0)
			st.add_index(vert+1)
			st.add_index(vert+resolution+1)
			st.add_index(vert+resolution+1)
			st.add_index(vert+1)
			st.add_index(vert+resolution+2)
			vert+=1
		vert+=1
	
	st.generate_normals()
	
	mesh = st.commit()
	st.clear()
	
	create_trimesh_collision()
	
	var sm = ShaderMaterial.new()
	sm.shader = preload("res://nodes/terrain/chunk.gdshader")
	sm.set_shader_parameter("origin", posOrigin)
	sm.set_shader_parameter("size", size)
	
	#
	#				CONFIGURANDO BIOMAS
	#
	
	var oeste = grama
	var leste = grama
	var norte = grama
	var sul = grama
	var biome = grama
	
	var hum = bnoise.get_noise_2dv(posOrigin)
	var hOeste = bnoise.get_noise_2d(posOrigin.x-1, posOrigin.y)
	var hLeste = bnoise.get_noise_2d(posOrigin.x+1, posOrigin.y)
	var hNorte = bnoise.get_noise_2d(posOrigin.x, posOrigin.y+1)
	var hSul = bnoise.get_noise_2d(posOrigin.x, posOrigin.y-1)
	
	if (hum < 0.35):
		biome = deserto
	if (hOeste < 0.35):
		oeste = deserto
	if (hLeste < 0.35):
		leste = deserto
	if (hNorte < 0.35):
		norte = deserto
	if (hSul < 0.35):
		sul = deserto
	
	sm.set_shader_parameter("biome", biome)
	sm.set_shader_parameter("oeste", oeste)
	sm.set_shader_parameter("leste", leste)
	sm.set_shader_parameter("norte", norte)
	sm.set_shader_parameter("sul", sul)
	
	mesh.surface_set_material(0, sm)

@export var update: bool = false
func _process(delta):
	if update:
		update = false
	pass

func set_resolution(_resolution:int):
	resolution = _resolution

func get_center():
	return center_terrain
