module main

import time
import gg.m4
import vulkan
import mathf

fn loop_fn(delta time.Duration, game_ptr voidptr) ? {
	mut game := &Game(game_ptr)

	delta_seconds := f32(delta.seconds())

	game.rotation += delta_seconds * 0.5

	translate := mathf.translate(0, 0, 10)
	scale := mathf.scale(1, -1, 1)
	rot_x := mathf.rot_x(0)
	rot_z := mathf.rot_z(0)

	projection := mathf.perspective(90, f32(game.height) / f32(game.width), 0.001, 100)
	game.ubo.projection = mathf.make_vulkan_mat(projection)
	game.ubo.view = m4.unit_m4()
	game.ubo.model = mathf.make_vulkan_mat(rot_z * rot_x * translate * scale)
	game.ubo.light_color = mathf.vec4(game.world.light_color, game.world.ambient_strenght)
	ptr := vulkan.vk_map_memory(game.device, game.uniform_memory, 0, sizeof(UBO), 0) ?
	unsafe { vmemcpy(ptr, &game.ubo, int(sizeof(UBO))) }
	vulkan.vk_unmap_memory(game.device, game.uniform_memory)
}
