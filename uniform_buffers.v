module main

import vulkan
import gg.m4

fn (mut game Game) create_uniform_buffer() ? {
	buffer_size := sizeof(m4.Mat4)
	game.uniform_buffer, game.uniform_memory = vulkan.create_buffer(game.device, game.physical_device,
		buffer_size, [.vk_buffer_usage_uniform_buffer_bit], u32(C.VK_SHARING_MODE_EXCLUSIVE),
		[], [.vk_memory_property_host_visible_bit, .vk_memory_property_host_coherent_bit]) ?
}

fn (mut game Game) create_descriptor_pool() ? {
	desc_pool_size := vulkan.create_vk_descriptor_pool_size(u32(C.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER),
		1)
	desc_pool_create_info := vulkan.create_vk_descriptor_pool_create_info(nullptr, 0,
		1, [desc_pool_size])
	game.desc_pool = vulkan.create_vk_descriptor_pool(game.device, &desc_pool_create_info,
		nullptr) ?
}

fn (mut game Game) create_descriptor_set_layout() ? {
	desc_set_layout_binding := vulkan.create_vk_descriptor_set_layout_binding(0, u32(C.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER),
		1, u32(C.VK_SHADER_STAGE_VERTEX_BIT), [])
	desc_set_layout_create_info := vulkan.create_vk_descriptor_set_layout_create_info(nullptr,
		0, [desc_set_layout_binding])
	game.desc_set_layout = vulkan.create_vk_descriptor_set_layout(game.device, &desc_set_layout_create_info,
		nullptr) ?
}

fn (mut game Game) create_descriptor_set() ? {
	desc_set_allocate_info := vulkan.create_vk_descriptor_set_allocate_info(nullptr, game.desc_pool,
		[game.desc_set_layout])
	game.desc_set = vulkan.allocate_vk_descriptor_sets(game.device, &desc_set_allocate_info) ?

	desc_buffer_info := vulkan.create_vk_descriptor_buffer_info(game.uniform_buffer, 0,
		sizeof(m4.Mat4))

	desc_write := vulkan.create_vk_write_descriptor_set(nullptr, game.desc_set, 0, 0, 1, u32(C.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER),
		[], [desc_buffer_info], [])
	vulkan.vk_update_descriptor_sets(game.device, [desc_write], [])
}
