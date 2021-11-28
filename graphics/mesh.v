module graphics

import mathf
import misc

pub struct Mesh {
pub mut:
	position mathf.Vec3
	rotation mathf.Vec3
	scale    mathf.Vec3
mut:
	verticies []misc.Vertex
	indicies  []u32
}

pub fn create_mesh(verticies []misc.Vertex, indicies []u32) Mesh {
	mut mesh := Mesh{
		indicies: indicies
		verticies: verticies
	}

	return mesh
}

pub fn (mut mesh Mesh) update(pos mathf.Vec3, rot mathf.Vec3, scale mathf.Vec3) {
	mesh.position = pos
	mesh.rotation = rot
	mesh.scale = scale
}

pub fn (mesh Mesh) mesh_data() ([]misc.Vertex, []u32) {
	return mesh.verticies, mesh.indicies
}

