module game

import graphics
import mathf
import time
import misc
import game.loader

pub struct WorldSettings {
pub:
	name             string
	ambient_strenght f32
	light_color      mathf.Vec3<f32>
}

pub struct World {
pub:
	name string
pub mut:
	meshes           []&graphics.Mesh
	ambient_strenght f32
	light_color      mathf.Vec3<f32>
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

pub fn (mut world World) load(path string, loc mathf.Vec3<f32>, rot mathf.Vec3<f32>, scale mathf.Vec3<f32>, mut progress misc.Progress) ? {
	if loader.exists(path.split('/').last()) {
		world.meshes << load_mesh(path.split('/').last(), mut progress)
		return
	}

	go save_mesh(world.meshes.len, mut progress, path, path.split('/').last())
	mut stopwatch := time.new_stopwatch(time.StopWatchOptions{})
	verticies, indicies := misc.load_obj(path, world.meshes.len, mut progress, false) ?
	stopwatch.stop()
	mut mesh := graphics.create_mesh(verticies, indicies)
	mesh.update_abs(loc, rot, scale)
	world.meshes << &mesh
}

pub fn (mut world World) add_mesh(mesh &graphics.Mesh, loc mathf.Vec3<f32>, rot mathf.Vec3<f32>, scale mathf.Vec3<f32>) {
	mut m := mesh
	m.update_abs(loc, rot, scale)
	world.meshes << m
}

fn save_mesh(len int, mut progress misc.Progress, path string, name string) {
	eprintln('Optimize mesh...')
	verticies, indicies := misc.load_obj(path, len, mut progress, false) or { panic(err) }
	eprintln('Loaded mesh...')
	mesh := graphics.create_mesh(verticies, indicies)
	loader := loader.create_loader(name, mesh)
	loader.store() or { panic(err) }
	eprintln('Stored mesh...')
}

fn load_mesh(name string, mut progress misc.Progress) &graphics.Mesh {
	mut loader := loader.create_loader(name, graphics.Mesh{})
	loader.load(mut progress) or { panic(err) }
	return &loader.data
}
