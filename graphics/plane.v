module graphics

import misc
import mathf

pub struct PlaneSettings {
	ObjectSettings
	quad_length f32
	width       int
	height      int
	y_mult      f32
}

pub struct Plane {
	quad_length f32
	width       int
	height      int
	y_mult      f32
mut:
	mesh Mesh
}

pub fn create_plane(settings PlaneSettings) &Plane {
	mut verticies := []misc.Vertex{len: settings.width * settings.height}
	mut indicies := []u32{}

	for x in 0 .. settings.width {
		for z in 0 .. settings.height {
			verticies << misc.create_vertex(mathf.vec3(x * settings.quad_length, 0, z * settings.quad_length),
				mathf.vec3<f32>(1, 0, 0), mathf.vec3<f32>(0, 0, -1), mathf.vec2<f32>(x * settings.quad_length,
				z * settings.quad_length), -1)

			if x >= settings.width - 1 || z >= settings.height - 1 {
				continue
			}

			indicies << mathf.vec3<u32>(x, z, u32(settings.height)).location_idx()
			indicies << mathf.vec3<u32>(x, z + 1, u32(settings.height)).location_idx()
			indicies << mathf.vec3<u32>(x + 1, z, u32(settings.height)).location_idx()

			indicies << mathf.vec3<u32>(x + 1, z, u32(settings.height)).location_idx()
			indicies << mathf.vec3<u32>(x, z + 1, u32(settings.height)).location_idx()
			indicies << mathf.vec3<u32>(x + 1, z + 1, u32(settings.height)).location_idx()
		}
	}

	return &Plane{
		quad_length: settings.quad_length
		width: settings.width
		height: settings.height
		mesh: create_mesh(verticies, indicies)
	}
}

pub fn (plane Plane) update_vertex_heights(heights map[int]f32) ? {
	for k, v in heights {
		mut vertex := plane.mesh().get_vertex(k) ?
		vertex.pos.y = v * plane.y_mult
	}
}

pub fn (plane Plane) mesh() &Mesh {
	return &plane.mesh
}
