module graphics

import misc
import mathf

pub struct PlaneSettings {
	ObjectSettings
	quad_length f32
	width       int
	height      int
}

pub struct Plane {
	quad_length f32
	width       int
	height      int
mut:
	mesh Mesh
}

pub fn create_plane(settings PlaneSettings) &Plane {
	mut verticies := []misc.Vertex{len: settings.width * settings.height}
	mut indicies := []u32{}

	for x in 0 .. settings.width {
		for y in 0 .. settings.height {
			verticies << misc.create_vertex(mathf.vec3(x * settings.quad_length, y * settings.quad_length,
				0), mathf.vec3(1, 0, 0), mathf.vec3(0, 0, -1), mathf.vec2(x * settings.quad_length,
				y * settings.quad_length), -1)
			indicies << [misc.create_location_index(x, y, settings.height),
				misc.create_location_index(x, y + 1, settings.height),
				misc.create_location_index(x + 1, y, settings.height)]
			indicies << [misc.create_location_index(x + 1, y, settings.height),
				misc.create_location_index(x, y + 1, settings.height),
				misc.create_location_index(x + 1, y + 1, settings.height)]
		}
	}

	return &Plane{
		quad_length: settings.quad_length
		width: settings.width
		height: settings.height
		mesh: create_mesh(verticies, indicies)
	}
}

pub fn (plane Plane) mesh() &Mesh {
	return &plane.mesh
}
