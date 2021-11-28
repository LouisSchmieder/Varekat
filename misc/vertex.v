module misc

import mathf

pub struct Vertex {
pub mut:
	pos    mathf.Vec3
	color  mathf.Vec3 = mathf.vec3(1, 0, 0)
	normal mathf.Vec3
	texture mathf.Vec2
	model int
}

pub fn create_vertex(pos mathf.Vec3, color mathf.Vec3, normal mathf.Vec3) Vertex {
	return Vertex{
		pos: pos
		color: color
		normal: normal
	}
}

pub fn vertex_offsets() []u32 {
	pos_offset := __offsetof(Vertex, pos)
	color_offset := __offsetof(Vertex, color)
	normal_offset := __offsetof(Vertex, normal)
	//texture_offset := __offsetof(Vertex, texture)
	//model_offset := __offsetof(Vertex, model)
	return [pos_offset, color_offset, normal_offset]
}

pub fn (vertex Vertex) str() string {
	return 'pos: $vertex.pos.x $vertex.pos.y $vertex.pos.z'
}