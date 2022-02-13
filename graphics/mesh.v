module graphics

import os
import misc
import buffer

[heap]
pub struct Mesh {
pub:
	path string
mut:
	verticies []misc.Vertex
	indicies  []u32
}

// Create a mesh based on a vertex and index array
pub fn create_mesh(verticies []misc.Vertex, indicies []u32, path string) Mesh {
	mut mesh := Mesh{
		indicies: indicies
		verticies: verticies
		path: path
	}

	return mesh
}

// Get the the verticies and indicies of the mesh
pub fn (mesh Mesh) mesh_data() ([]misc.Vertex, []u32) {
	return mesh.verticies, mesh.indicies
}

// Get a vertex at index `idx`.
// Possible error: `Index out of length`
pub fn (mesh Mesh) get_vertex(idx int) ?&misc.Vertex {
	if idx >= mesh.verticies.len {
		return error('Index out of length')
	}
	return &(mesh.verticies[idx])
}

// Store the mesh to a .vbin file in binary format
pub fn (mesh Mesh) store(path string) {
	mut bos := buffer.new_binary_output_stream()
	bos.write_int(mesh.verticies.len)
	for vertex in mesh.verticies {
		bos.write_vec3(vertex.pos)
		bos.write_vec3(vertex.color)
		bos.write_vec3(vertex.normal)
		bos.write_vec2(vertex.texture)
		bos.write_int(vertex.model)
	}
	bos.write_int(mesh.indicies.len)
	bos.write_u32s(mesh.indicies)

	os.write_file(path, bos.bytes.bytestr()) or { panic(err) }
}

// Load a mesh from a .vbin binary file
pub fn (mut mesh Mesh) load(path string, mut progress misc.Progress) {
	bytes := os.read_bytes(path) or { panic(err) }
	mut bis := buffer.new_binary_input_stream(bytes, mut progress)

	mesh = Mesh{}
	vertex_len := bis.read_int()

	for _ in 0 .. vertex_len {
		mesh.verticies << misc.create_vertex(bis.read_vec3(), bis.read_vec3(), bis.read_vec3(),
			bis.read_vec2(), bis.read_int())
	}

	index_len := bis.read_int()
	mesh.indicies = bis.read_u32s(u32(index_len))
}
