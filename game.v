module main

import time
import gg.m4
import vulkan
import math
import mathf

fn loop_fn(delta time.Duration, game_ptr voidptr) ? {
	mut game := &Game(game_ptr)

	delta_seconds := f32(delta.seconds())

	game.rotation += delta_seconds * 0.05

	//mut model := m4.rotate(m4.rad(0), m4.vec3(0, 0, 1)) 
	//view := mathf.look_at(mathf.vec3(0, game.rotation, 1), mathf.vec3(0, 0, 0), mathf.vec3(0, 1, 0))
	mut projection := mathf.perspective((60 * f32(math.pi) / 360), f32(game.width / game.height), 0.001, 100)
	game.mvp = mathf.make_vulkan_mat(projection)

	ptr := vulkan.vk_map_memory(game.device, game.uniform_memory, 0, sizeof(m4.Mat4),
		0) ?
	unsafe { vmemcpy(ptr, &game.mvp, int(sizeof(m4.Mat4))) }
	vulkan.vk_unmap_memory(game.device, game.uniform_memory)
}
