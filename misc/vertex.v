module misc

import mathf

pub struct Vertex {
pub mut:
	pos     mathf.Vec3<f32>
	color   mathf.Vec3<f32> = mathf.vec3<f32>(1, 0, 0)
	normal  mathf.Vec3<f32>
	texture mathf.Vec2<f32>
	model   int
}

// Creates a vertex
pub fn create_vertex(pos mathf.Vec3<f32>, color mathf.Vec3<f32>, normal mathf.Vec3<f32>, texture mathf.Vec2<f32>, model int) Vertex {
	return Vertex{
		pos: pos
		color: color
		normal: normal
		texture: texture
		model: model
	}
}

// Returns Vertex field offsets, used by vertex buffer
pub fn vertex_offsets() []u32 {
	pos_offset := __offsetof(Vertex, pos)
	color_offset := __offsetof(Vertex, color)
	normal_offset := __offsetof(Vertex, normal)
	// texture_offset := __offsetof(Vertex, texture)
	// model_offset := __offsetof(Vertex, model)
	return [pos_offset, color_offset, normal_offset]
}

pub fn (vertex Vertex) str() string {
	return 'pos: $vertex.pos.x $vertex.pos.y $vertex.pos.z'
}
