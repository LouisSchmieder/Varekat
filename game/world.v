module game

import graphics
import mathf
import time
import misc
import game.loader
import vk

pub struct WorldSettings {
pub:
	name             string
	ambient_strenght f32
	light_color      mathf.Vec3<f32>
}

pub struct World {
	WorldSettings
pub mut:
	objects []&graphics.ObjectI
}

pub fn create_world(settings WorldSettings) World {
	return World{
		name: settings.name
		ambient_strenght: settings.ambient_strenght
		light_color: settings.light_color
	}
}

pub fn (world World) objects() []&graphics.ObjectI {
	return world.objects
}

pub fn (mut world World) add_object(obj &graphics.ObjectI) {
	world.objects << unsafe { obj }
}

pub fn (world World) to_vk_meshes() []vk.Mesh {
	mut meshes := []vk.Mesh{}
	for obj in world.objects {
		verticies, indicies := obj.mesh.mesh_data()
		meshes << vk.Mesh{
			verticies: verticies
			indicies: indicies
		}
	}
	return meshes
}
