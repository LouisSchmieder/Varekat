module main

import time
import mathf
import graphics
import misc
import glfw
import terrain

fn init_fn(game_ptr voidptr) {
	mut game := &Game(game_ptr)
	mut progress := misc.create_progress()

	eprintln('1')

	mesh := graphics.load_mesh('assets/objects/cube.obj', mut progress) or { panic(err) }
	eprintln('2')
	object := graphics.create_object(mesh,
		position: mathf.vec3<f32>(0, 0, 5)
		rotation: mathf.vec3<f32>(0, 0, 0)
		scale: mathf.vec3<f32>(1, 1, 1)
	)
	game.world.add_object(object)

	/*
	mut plane := graphics.create_plane(quad_length: 1, height: 20, width: 20, y_mult: 0.01)
	seed := time.now().unix

	heightmap := terrain.create_random_heightmap(int(seed), 20, 20, 1, 1, terrain.perlin_map_gen)

	plane.update_by_heightmap(heightmap) or { panic(err) }

	game.world.add_object(plane, mathf.vec3<f32>(0, 0, 5), mathf.vec3<f32>(0, 0,
		0), mathf.vec3<f32>(1, 1, 1))*/
}

fn mouse_fn(game_ptr voidptr) {
	mut game := &Game(game_ptr)

	game.camera.look(game.mouse.off_y, game.mouse.off_x)
}

fn loop_fn(delta time.Duration, game_ptr voidptr) ? {
	mut game := &Game(game_ptr)

	delta_seconds := f32(delta.seconds())

	// Key handling
	if game.keyboard.is_pressed(.key_w) {
		game.camera.move(mathf.vec3<f32>(0, 0, 1), delta_seconds)
	}
	if game.keyboard.is_pressed(.key_s) {
		game.camera.move(mathf.vec3<f32>(0, 0, -1), delta_seconds)
	}
	if game.keyboard.is_pressed(.key_d) {
		game.camera.move(mathf.vec3<f32>(1, 0, 0), delta_seconds)
	}
	if game.keyboard.is_pressed(.key_a) {
		game.camera.move(mathf.vec3<f32>(-1, 0, 0), delta_seconds)
	}
	if game.keyboard.is_pressed(.key_escape) {
		glfw.show_mouse(game.window)
	}

	game.rotation += delta_seconds * 0.25

	for i, obj in game.world.objects {
		/*
		game.world.meshes[i].ubo.update_ubo(game.fov, f32(game.width) / f32(game.height),
			game.near_plane, game.far_plane, game.camera.look_at(), mesh.position, mesh.rotation,
			mesh.scale)
		game.world.uniform_buffers[i].map_buffer<mathf.UBO>(&mesh.ubo) ?*/
	}
}
