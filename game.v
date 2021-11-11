module main

import time
import gg.m4
import vulkan

fn loop_fn(delta time.Duration, game_ptr voidptr) ? {
	mut game := &Game(game_ptr)

	delta_seconds := f32(delta.seconds())

	game.rotation += delta_seconds * 30

	model := m4.rotate(m4.rad(0), m4.vec3(0, 0, 1))
	view := m4.look_at(m4.vec3(1, 1, 1), m4.vec3(0, 0, 0), m4.vec3(0, 1, 0))
	mut projection := m4.perspective(45, game.width / game.height, 0.1, 100)
	unsafe {
		projection.f[1][1] *= -1
	}
	game.mvp = projection * view * model

	eprintln(game.mvp)

	ptr := vulkan.vk_map_memory(game.device, game.uniform_memory, 0, sizeof(m4.Mat4),
		0) ?
	unsafe { vmemcpy(ptr, &game.mvp, int(sizeof(m4.Mat4))) }
	vulkan.vk_unmap_memory(game.device, game.uniform_memory)
}
