module game

import graphics
import mathf
import misc
import game.loader

pub struct WorldSettings {
pub:
	name string
	ambient_strenght f32
	light_color mathf.Vec3
}

pub struct World {
pub:
	name             string
pub mut:
	meshes           []graphics.Mesh
	ambient_strenght f32
	light_color      mathf.Vec3
}

pub fn create_world(settings WorldSettings) World {
	return World{
		name: settings.name
		ambient_strenght: settings.ambient_strenght
		light_color: settings.light_color
	}
}

pub fn (world World) get_world_verticies() []misc.Vertex {
	mut verticies := []misc.Vertex{}

	for mesh in world.meshes {
		v, _ := mesh.mesh_data()
		verticies << v
	}
	return verticies
}

pub fn (world World) get_world_indicies() []u32 {
	mut indicies := []u32{}

	for mesh in world.meshes {
		_, i := mesh.mesh_data()
		indicies << i
	}

	return indicies
}

pub fn (mut world World) load(path string, loc mathf.Vec3, rot mathf.Vec3, scale mathf.Vec3, mut progress &misc.Progress) ? {
	if loader.exists(path.split('/').last()) {
		world.meshes << load_mesh(path.split('/').last(), mut progress)
		return
	}
	
	verticies, indicies := misc.load_obj(path, world.meshes.len, mut progress) ?
	mut mesh := graphics.create_mesh(verticies, indicies)
	mesh.update(loc, rot, scale)
	world.meshes << mesh

	go save_mesh(mesh, path.split('/').last())
}

fn save_mesh(mesh graphics.Mesh, name string) {
	loader := loader.create_loader(name, mesh)
	loader.store() or { panic(err) }
}

fn load_mesh(name string, mut progress &misc.Progress) graphics.Mesh {
	mut loader := loader.create_loader(name, graphics.Mesh{})
	loader.load(mut progress) or { panic(err) }
	return loader.data
}
