using Godot;
using System;

public partial class chunk : MeshInstance3D
{
	[ExportCategory("Configurações")]
	[ExportGroup("Texturas")]
	[Export]
	private Texture2D grama;
	[Export]
	private Texture2D deserto;
	[Export]
	private NoiseTexture2D humidade;
	[ExportGroup("Valores")]
	[Export]
	private Vector2 size = new Vector2(12, 12);
	[Export]
	private float altura = 5.0f;
	[Export]
	private int lod = 5;

	private Vector2 center_terrain;

	public override void _Ready()
	{
		center_terrain = size / 2;
	}

	public override void _Process(double delta)
	{
		var sf = new SurfaceTool();
		sf.Begin(Mesh.PrimitiveType.Triangles);

	}

	private int uvx = 0;
	private int uvy = 0;

	private float teste = 0f;
	public void GenerateTerrain(FastNoiseLite noise, SurfaceTool st, Vector2 pos)
	{
		for (int z = 0; z < lod + 1; z++)
		{
			uvy = uvy == 0 ? 1 : 0;
			for (int x = 0; x < lod + 1; x++)
			{
				uvx = uvx == 0 ? 1 : 0;

				Vector2 bLod = new Vector2(this.size.X / lod, this.size.Y / lod);
				Vector2 bLodPos = new Vector2(x * bLod.X, z * bLod.Y);
				Vector2 pontoNaMesh = new Vector2(pos.X * size.X + (bLodPos.X - center_terrain.X), pos.Y * size.Y + (bLodPos.Y - center_terrain.Y));
				float y = noise.GetNoise2D(pontoNaMesh.X, pontoNaMesh.Y) * altura;

				Vector2 uv = new Vector2(uvx, uvy);
				st.SetUV(uv);

				Vector3 vertex = new Vector3(pontoNaMesh.X, y, pontoNaMesh.Y);
				st.AddVertex(vertex);
			}
		}

		int vert = 0;
		for (int z = 0; z < lod; z++)
		{
			for (int x = 0; x < lod; x++)
			{
				st.AddIndex(vert + 0);
				st.AddIndex(vert + 1);
				st.AddIndex(vert + lod + 1);
				st.AddIndex(vert + lod + 1);
				st.AddIndex(vert + 1);
				st.AddIndex(vert + lod + 2);
				vert++;
			}
			vert++;
		}

		st.GenerateNormals();
		this.Mesh = st.Commit();

		ShaderMaterial sm = new ShaderMaterial();
		// var script = ((Shader)GD.Load("res://nodes/terrain/chunk.gdshader")).GetScript();
		// sm.SetScript(script);
		sm.Shader = (Shader)GD.Load("res://nodes/terrain/chunk.gdshader");
		sm.SetShaderParameter("grama", this.grama);
		sm.SetShaderParameter("deserto", this.deserto);
		
		FastNoiseLite fn = new FastNoiseLite();
		fn.Frequency = 0.01f;
		fn.Offset = new Vector3(pos.X*12f-center_terrain.X,pos.Y*12f-center_terrain.Y, 0f);
		GD.Print(fn.Offset);
		fn.NoiseType = FastNoiseLite.NoiseTypeEnum.SimplexSmooth;

		this.humidade = new NoiseTexture2D();
		this.humidade.Width = 12;
		this.humidade.Height = 12;
		this.humidade.Noise = fn;
		this.humidade.Normalize = false;
		// GD.Print("xoff: ", pos.X*size.X , " yoff: ", pos.Y*size.Y , " ref: ", fn);

		sm.SetShaderParameter("pos", pos*12f);

		sm.SetShaderParameter("humidade", this.humidade);
		st.SetMaterial(sm);
		this.Mesh.SurfaceSetMaterial(0, sm);
	}

	public void set_lod(int _lod)
	{
		this.lod = _lod;
	}

	public Vector2 get_center()
	{
		return this.center_terrain;
	}
}
