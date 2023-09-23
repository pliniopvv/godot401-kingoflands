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
	[Export]
	private NoiseTexture2D temperatura;
	[ExportGroup("Valores")]
	[Export]
	private Vector2 size = new Vector2(12f, 12f);
	[Export]
	private float altura = 5.0f;
	[Export]
	private int lod = 5;
	[Export]
	public bool flat = false;

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

				Vector2 unid = this.size/this.lod;
				Vector2 sUnid = new Vector2(x, z) * unid;
				Vector2 pontoNaMesh = pos * this.size + sUnid - center_terrain ;
				float y = 0f;
				if (!this.flat) {
					y = noise.GetNoise2D(pontoNaMesh.X, pontoNaMesh.Y) * altura;
				}

				// Vector2 uv = new Vector2(uvx, uvy);
				Vector2 uv = sUnid;
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

		CreateTrimeshCollision();

		ShaderMaterial sm = new ShaderMaterial();
		// var script = ((Shader)GD.Load("res://nodes/terrain/chunk.gdshader")).GetScript();
		// sm.SetScript(script);
		sm.Shader = (Shader)GD.Load("res://nodes/terrain/chunk.gdshader");
		sm.SetShaderParameter("grama", this.grama);
		sm.SetShaderParameter("deserto", this.deserto);

		//
		//					HUMIDADE
		//

		FastNoiseLite fn = new FastNoiseLite();
		fn.Frequency = 0.001f;
		fn.Offset = new Vector3(	pos.X*12f-center_terrain.X //* 512f
									,pos.Y*12f-center_terrain.Y //* 512f
									,0f
		);
		// GD.Print(fn.Offset);
		fn.NoiseType = FastNoiseLite.NoiseTypeEnum.SimplexSmooth;

		this.humidade = new NoiseTexture2D();
		this.humidade.Width = (int) this.size.X;
		this.humidade.Height = (int) this.size.Y;
		this.humidade.Noise = fn;
		this.humidade.Normalize = false;

		//
		//					TEMPERATURA
		//


		FastNoiseLite fnt = new FastNoiseLite();
		fnt.Frequency = 0.001f;
		fnt.Seed = fn.Seed + 1;
		fnt.Offset = new Vector3(	pos.X*12f-center_terrain.X //* 512f
									,pos.Y*12f-center_terrain.Y //* 512f
									,0f
		);

		this.temperatura = new NoiseTexture2D();
		this.temperatura.Width = (int) this.size.X;
		this.temperatura.Height = (int) this.size.Y;
		this.temperatura.Noise = fnt;
		this.temperatura.Normalize = false;
		// GD.Print("xoff: ", pos.X*size.X , " yoff: ", pos.Y*size.Y , " ref: ", fn);

		sm.SetShaderParameter("pos", pos*12f);

		sm.SetShaderParameter("humidade", this.humidade);
		sm.SetShaderParameter("temperatura", this.temperatura);
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
