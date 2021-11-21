module misc

import mathf
import os

pub fn load_obj(path string) ?([]mathf.Vec3, [][2]f32, []mathf.Vec3, []u32) {
	data := os.read_file(path) ?
	mut verticies := []mathf.Vec3{}
	mut textures := [][2]f32{}
	mut normals := []mathf.Vec3{}
	mut indicies := []u32{}

	mut aligned_normals := []mathf.Vec3{}
	mut aligned_textures := [][2]f32{}
	mut face := false

	for line in data.split('\n') {
		fields := line.fields()

		if fields.len > 0 {
			match fields[0] {
				'v' {
					// Vertex
					verticies << mathf.vec3(fields[1].f32(), fields[2].f32(), fields[3].f32())
				}
				'vt' {
					// Texture
					textures << [fields[1].f32(), fields[2].f32()]!
				}
				'vn' {
					// Normal
					normals << mathf.vec3(fields[1].f32(), fields[2].f32(), fields[3].f32())
				}
				'f' {
					if !face {
						aligned_normals = []mathf.Vec3{len: verticies.len}
						aligned_textures = [][2]f32{len: verticies.len}
						face = true
					}

					vertex_1 := fields[1].split('/')
					vertex_2 := fields[2].split('/')
					vertex_3 := fields[3].split('/')

					process_vertex(vertex_1, mut indicies, verticies, normals, textures, mut
						aligned_normals, mut aligned_textures)
					process_vertex(vertex_2, mut indicies, verticies, normals, textures, mut
						aligned_normals, mut aligned_textures)
					process_vertex(vertex_3, mut indicies, verticies, normals, textures, mut
						aligned_normals, mut aligned_textures)
				}
				else {
					continue
				}
			}
		}
	}

	return verticies, aligned_textures, aligned_normals, indicies
}

fn process_vertex(vertex_args []string, mut indicies []u32, verticies []mathf.Vec3, normals []mathf.Vec3, textures [][2]f32, mut aligned_normals []mathf.Vec3, mut aligned_textures [][2]f32) {
	current_vertex := vertex_args[0].u32() - 1
	indicies << current_vertex

	aligned_textures[current_vertex] = textures[vertex_args[1].int() - 1]
	aligned_normals[current_vertex] = normals[vertex_args[2].int() - 1]
}
