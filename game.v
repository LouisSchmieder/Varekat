module main

import time
import mathf
import graphics
import misc
import terrain

fn init_fn(game_ptr voidptr) {
	mut game := &Game(game_ptr)
	// game.world.load_mesh('assets/objects/dragon.obj', mathf.vec3<f32>(0, 0, 10), mathf.vec3<f32>(0, 0, 0), mathf.vec3<f32>(1, 1, 1), mut progress) or { panic(err) }

	mut plane := graphics.create_plane(quad_length: 1, height: 20, width: 20, y_mult: 0.01)
	seed := time.now().unix

	heightmap := terrain.create_random_heightmap(int(seed), 20, 20, 1, 1, terrain.perlin_map_gen)

	plane.update_by_heightmap(heightmap) or { panic(err) }

	game.world.add_mesh(plane.mesh(), mathf.vec3<f32>(0, 0, 0), mathf.vec3<f32>(0, 0,
		0), mathf.vec3<f32>(0, 0, 0))
}

fn key_fn(game_ptr voidptr, key misc.Key, action misc.Action, mods int) {
	mut game := &Game(game_ptr)

	// Move
	match key {
		.key_w {
			if action == .press {
				game.camera.pos += game.camera.facing.mult_vec(game.camera.camera_speed)
			}
		}
		.key_s {
			if action == .press {
				game.camera.pos -= game.camera.facing.mult_vec(game.camera.camera_speed)
			}
		}
		.key_d {
			if action == .press {
				// game.camera.camera_pos += mathf.normalize(mathf.cross(game.camera.front, game.camera.up)).mult_vec(game.camera.camera_speed)
			}
		}
		.key_a {
			if action == .press {
				// game.camera.camera_pos -= mathf.normalize(mathf.cross(game.camera.front, game.camera.up)).mult_vec(game.camera.camera_speed)
			}
		}
		else {}
	}
}

fn loop_fn(delta time.Duration, game_ptr voidptr) ? {
	mut game := &Game(game_ptr)

	delta_seconds := f32(delta.seconds())

	game.rotation += delta_seconds * 5

	proj := mathf.perspective(game.fov, f32(game.height) / f32(game.width), game.near_plane,
		game.far_plane)
	view := mathf.look_at(mathf.vec3<f32>(0, 0, 6), mathf.vec3<f32>(0, 0, 0), mathf.vec3<f32>(0,
		1, 0))

	view_proj := view * proj

	rxm := mathf.rot_x(0)
	rym := mathf.rot_y(0)

	model_pos := mathf.translate(0, -5, -7)
	model_m := (rym * rxm) * model_pos
	scale_m := mathf.scale(1, 1, 1)

	mv := scale_m * model_m
	nm := mv.inverse().transpose()
	mvp := mv * view_proj

	game.ubo.model_view = mv
	game.ubo.mvp = mvp
	game.ubo.normal = nm

	game.uniform_buffer.map_buffer(&game.ubo) ?
}
