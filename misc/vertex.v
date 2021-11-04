module misc

pub struct Vertex {
	pos [2]f32
	color [3]f32
}

pub fn create_vertex(x f32, y f32, r f32, g f32, b f32) Vertex {
	mut pos := [2]f32{}
	pos[0] = x
	pos[1] = y
	mut color := [3]f32{}
	color[0] = r
	color[1] = g
	color[2] = b
	return Vertex{
		pos: pos
		color: color
	}
}

pub fn vertex_offsets() []u32 {
	pos_offset := __offsetof(Vertex, pos)
	color_offset := __offsetof(Vertex, color)
	return [pos_offset, color_offset]
}