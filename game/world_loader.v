module game

import mathf

struct WorldLoad {
	settings WorldSettings
	meshes   []WorldMesh
}

struct WorldMesh {
	path  string
	name  string
	pos   mathf.Vec3<f32>
	rot   mathf.Vec3<f32>
	scale mathf.Vec3<f32>
}

/*
pub fn (world World) store(path string) ? {
	mut meshes := []WorldMesh{}

	for mesh in world.meshes {
		meshes << WorldMesh{
			path: mesh.path
		}
	}

	world_load := WorldLoad{
		settings: WorldSettings{
			name: world.name
			ambient_strenght: world.ambient_strenght
			light_color: world.light_color
		}
		meshes: meshes
	}

	os.write_file(path, json.encode(world_load)) ?
}

pub fn (mut world World) load(path string, mut progress misc.Progress) ? {
	str := os.read_file(path) ?
	data := json.decode(WorldLoad, str) ?

	world = create_world(data.settings)

	for mesh in data.meshes {
		world.load_mesh(mesh.path, mesh.pos, mesh.rot, mesh.scale, mut progress) ?
	}
}
*/
