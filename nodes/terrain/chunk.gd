extends MeshInstance3D
class_name GenericChunk

enum Bioma {
	Floresta,
	Deserto
}

@export_category("Configurações iniciais")
@export_group("Texturas")
@export var tGrama: Texture2D = preload("res://assets/texture/grass2.jpg")
@export var tDeserto: Texture2D = preload("res://assets/texture/sand.jpg")
@export var humidade: NoiseTexture2D
@export_group("Valores iniciais")
@export var size = Vector2(12.0,12.0)
@export var resolution = 5
@export var altura = 5.0
@export var flat = false

var center_terrain = size/2
var center_offset = 0.5
var lim_hum = 0.35
var type_biome = Bioma.Floresta

var noise: FastNoiseLite
var humNoise: FastNoiseLite
var surfacetool:SurfaceTool
@onready var grass := $grass

const grama_item := preload("res://assets/blender/grass.gltf")
#const grass_mesh := preload("res://nodes/terrain/biomes/forest/grass/grass5.res")
const grass_mesh := preload("res://nodes/terrain/biomes/forest/grass/grass7arraymesh.res")

var thread1 : Thread = Thread.new()

func _ready():
	generate_terrain()
	pass

func generate_terrain():
	randomize()
	var sizev3 = Vector3(size.x, 1.0, size.y)
	var posOrigin = Vector2(position.x/size.x,position.z/size.y)
	for _z in range(resolution+1):
		for _x in range(resolution+1):
			var percent = Vector2(_x,_z)/resolution
			var pontoNaMesh = Vector3((percent.x-center_offset), 0, (percent.y-center_offset))
			if not flat:
				pontoNaMesh.y = noise.get_noise_2d(posOrigin.x+pontoNaMesh.x, posOrigin.y+pontoNaMesh.z) * altura * resolution
			var vertex = pontoNaMesh * sizev3
			var uv = Vector2(0,0)
			uv.x = percent.x
			uv.y = percent.y
			
			surfacetool.set_uv(uv)
			surfacetool.add_vertex(vertex)
	
	var vert = 0
	for z in range(resolution):
		for x in range(resolution):
			surfacetool.add_index(vert+0)
			surfacetool.add_index(vert+1)
			surfacetool.add_index(vert+resolution+1)
			surfacetool.add_index(vert+resolution+1)
			surfacetool.add_index(vert+1)
			surfacetool.add_index(vert+resolution+2)
			vert+=1
		vert+=1
	
	surfacetool.generate_normals()
	
	mesh = surfacetool.commit()
	surfacetool.clear()
	
	create_trimesh_collision()
	
	var sm = ShaderMaterial.new()
	sm.shader = preload("res://nodes/terrain/chunk.gdshader")
	sm.set_shader_parameter("origin", posOrigin)
	sm.set_shader_parameter("size", size)
	
	#
	#				CONFIGURANDO BIOMAS
	#

	var oeste = tGrama
	var leste = tGrama
	var norte = tGrama
	var sul = tGrama
	var bioma = tGrama
	
	var hum = humNoise.get_noise_2dv(posOrigin)
	var hOeste = humNoise.get_noise_2d(posOrigin.x-1, posOrigin.y)
	var hLeste = humNoise.get_noise_2d(posOrigin.x+1, posOrigin.y)
	var hNorte = humNoise.get_noise_2d(posOrigin.x, posOrigin.y+1)
	var hSul = humNoise.get_noise_2d(posOrigin.x, posOrigin.y-1)
	
	if (hum < lim_hum):
		bioma = tDeserto
		type_biome = Bioma.Deserto
	if (hOeste < lim_hum):
		oeste = tDeserto
	if (hLeste < lim_hum):
		leste = tDeserto
	if (hNorte < lim_hum):
		norte = tDeserto
	if (hSul < lim_hum):
		sul = tDeserto
	
	sm.set_shader_parameter("bioma", bioma)
	sm.set_shader_parameter("oeste", oeste)
	sm.set_shader_parameter("leste", leste)
	sm.set_shader_parameter("norte", norte)
	sm.set_shader_parameter("sul", sul)
	
	mesh.surface_set_material(0, sm)
	
	var e = thread1.start(build_biome.bind(position), Thread.PRIORITY_LOW)
	if e:
		print("Erro: ", e)
	#build_biome(position)

@export var update: bool = false
func _process(delta):
	if update:
		update = false
	pass

func set_resolution(_resolution:int):
	resolution = _resolution

func get_center():
	return center_terrain

@export_group("Configurações do bioma de grama")
@export var densidade_grama = 10
@export var visible_grama = true
func build_biome(position: Vector3):
	match type_biome:
		Bioma.Deserto:
			pass
		_:
			randomize()
			var mm = MultiMesh.new()
			mm.transform_format = MultiMesh.TRANSFORM_3D
			mm.instance_count = densidade_grama*3
			mm.visible_instance_count = densidade_grama
			mm.mesh = grass_mesh
			grass.multimesh = mm
			
			var sizev3 = Vector3(size.x,1,size.y)
			for i in range(densidade_grama):
				var pos = Vector3(randf()-center_offset,0,randf()-center_offset)
				pos.y = noise.get_noise_2d(position.x/size.x+pos.x,position.z/size.y+pos.z) * altura * resolution
				mm.set_instance_transform(i, Transform3D(Basis(), pos*sizev3))
