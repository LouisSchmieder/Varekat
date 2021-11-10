module main

import time
import gg.m4
import vulkan


fn loop_fn(delta time.Duration, game_ptr voidptr) ? {
	mut game := &Game(game_ptr)

	delta_seconds := delta.seconds()

	model := m4.rotate(m4.rad(90), m4.vec3(0, 0, 1))
	view := m4.look_at(m4.vec3(2, 2, 2), m4.vec3(0, 0, 0), m4.vec3(0, 0, 1))
	mut projection := m4.perspective(m4.rad(45), f32(game.width) / f32(game.height), 0.1, 10)
	unsafe { projection.f[1][1] *= -1 }

	
	game.mvp = projection * view * model

	ptr := vulkan.vk_map_memory(game.device, game.uniform_memory, 0, sizeof(m4.Mat4), 0) ?
	unsafe { vmemcpy(ptr, &game.mvp, int(sizeof(m4.Mat4))) }
	vulkan.vk_unmap_memory(game.device, game.uniform_memory)

}