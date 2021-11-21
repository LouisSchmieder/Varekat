module misc

import mathf

pub struct Vertex {
pub mut:
	pos    mathf.Vec3
	color  mathf.Vec3
	normal mathf.Vec3
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
	return [pos_offset, color_offset, normal_offset]
}
