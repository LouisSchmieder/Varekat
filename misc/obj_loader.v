module misc

import mathf
import os

enum FaceType {
	vertex
	vertex_texture
	vertex_normal
	vertex_texture_normal
}

// Get the verticies and indicies from a `.obj` file at path `path`
// Optimization is WIP
pub fn load_obj(path string, mut progress Progress, optimize bool) ?([]Vertex, []u32) {
	data := os.read_file(path) ?

	mut raw_verticies := []mathf.Vec3<f32>{}
	mut raw_textures := []mathf.Vec2<f32>{}
	mut raw_normals := []mathf.Vec3<f32>{}

	mut verticies := []Vertex{}
	mut indicies := []u32{}

	mut indexes := map[string]u32{}

	mut lines := data.split('\n')

	progress.init(lines.len)

	for line in lines {
		fields := line.fields()
		progress.update()

		if optimize {
			eprintln('${progress.get_progress() * 100} % done')
		}

		if fields.len > 0 {
			match fields[0] {
				'v' {
					// Vertex
					raw_verticies << mathf.vec3(fields[1].f32(), fields[2].f32(), fields[3].f32())
				}
				'vt' {
					// Texture
					raw_textures << mathf.vec2(fields[1].f32(), fields[2].f32())
				}
				'vn' {
					// Normal
					raw_normals << mathf.vec3(fields[1].f32(), fields[2].f32(), fields[3].f32())
				}
				'f' {
					mut spliter := ''
					mut face_type := FaceType.vertex
					if fields[1].contains('//') {
						// Format: Vertex // Normal
						spliter = '//'
						face_type = .vertex_normal
					} else if fields[1].contains('/') {
						spliter = '/'
						if fields[1].split('/').len == 3 {
							// Format: Vertex / Texture / Normal
							face_type = .vertex_texture_normal
						} else if fields[1].split('/').len == 2 {
							// Format: Vertex / Texture
							face_type = .vertex_texture
						}
					} else {
						// Format: Vertex
						spliter = ' '
					}

					for i in 1 .. fields.len {
						validate_face_vertex(fields[i], spliter, face_type, mut verticies, mut
							indicies, raw_verticies, raw_textures, raw_normals, optimize, mut
							indexes)
					}
				}
				else {
					continue
				}
			}
		}
	}

	if optimize {
		unsafe { indexes.free() }
	}

	return verticies, indicies
}

fn validate_face_vertex(field string, spliter string, face_type FaceType, mut verticies []Vertex, mut indicies []u32, raw_verticies []mathf.Vec3<f32>, raw_textures []mathf.Vec2<f32>, raw_normals []mathf.Vec3<f32>, optimize bool, mut indexes map[string]u32) {
	if optimize {
		if field in indexes {
			indicies << indexes[field]
			return
		}
	}

	data := field.split(spliter)
	mut vertex := match face_type {
		.vertex {
			Vertex{}
		}
		.vertex_normal {
			Vertex{
				normal: raw_normals[data[1].int() - 1]
			}
		}
		.vertex_texture {
			Vertex{
				texture: raw_textures[data[1].int() - 1]
			}
		}
		.vertex_texture_normal {
			Vertex{
				texture: raw_textures[data[1].int() - 1]
				normal: raw_normals[data[2].int() - 1]
			}
		}
	}
	vertex.pos = raw_verticies[data[0].int() - 1]

	verticies << vertex
	idx := u32(verticies.len - 1)
	indicies << idx
	if optimize {
		indexes[field] = idx
	}
}
