module vk

import vulkan

pub struct UniformBufferConfig {
pub mut:
	buffer_size     u32
	stage           vulkan.ShaderStageFlagBits
	descriptor_type vulkan.DescriptorType
}

struct UniformBuffer {
	device          &C.VkDevice
	physical_device &C.VkPhysicalDevice
mut:
	settings       UniformBufferConfig
	uniform_buffer C.VkBuffer
	uniform_memory C.VkDeviceMemory

	desc_set_layout C.VkDescriptorSetLayout
	desc_pool       C.VkDescriptorPool
	desc_set        C.VkDescriptorSet
}

pub fn (instance Instance) create_uniform_buffer<T>(settings UniformBufferConfig) ?&UniformBuffer {
	mut buffer := &UniformBuffer{
		device: &instance.device
		physical_device: &instance.ph_device
		settings: settings
	}
	buffer.settings.buffer_size = sizeof(T)
	return buffer
}

pub fn (mut buffer UniformBuffer) map_buffer<T>(data &T) ? {
	ptr := vulkan.vk_map_memory(*buffer.device, buffer.uniform_memory, 0, sizeof(T), 0) ?
	unsafe { vmemcpy(ptr, data, int(sizeof(T))) }
	vulkan.vk_unmap_memory(*buffer.device, buffer.uniform_memory)
}

pub fn (mut buffer UniformBuffer) free_pool() {
	vulkan.vk_destroy_descriptor_pool(*buffer.device, buffer.desc_pool, nullptr)
}

pub fn (mut buffer UniformBuffer) free() {
	vulkan.vk_destroy_descriptor_set_layout(*buffer.device, buffer.desc_set_layout, nullptr)
	vulkan.vk_destroy_descriptor_pool(*buffer.device, buffer.desc_pool, nullptr)

	vulkan.vk_free_memory(*buffer.device, buffer.uniform_memory, nullptr)
	vulkan.vk_destroy_buffer(*buffer.device, buffer.uniform_buffer, nullptr)
}

pub fn (mut buffer UniformBuffer) set() C.VkDescriptorSet {
	return buffer.desc_set
}

pub fn (mut buffer UniformBuffer) layout() C.VkDescriptorSetLayout {
	return buffer.desc_set_layout
}

pub fn (mut buffer UniformBuffer) create_buffer() ? {
	buffer.uniform_buffer, buffer.uniform_memory = vulkan.create_buffer(*buffer.device,
		buffer.physical_device, buffer.settings.buffer_size, [
		.vk_buffer_usage_uniform_buffer_bit,
	], u32(C.VK_SHARING_MODE_EXCLUSIVE), [], [.vk_memory_property_host_visible_bit,
		.vk_memory_property_host_coherent_bit]) ?
}

pub fn (mut buffer UniformBuffer) create_descriptor_pool() ? {
	desc_pool_size := vulkan.create_vk_descriptor_pool_size(buffer.settings.descriptor_type,
		1)
	desc_pool_create_info := vulkan.create_vk_descriptor_pool_create_info(nullptr, 0,
		1, [desc_pool_size])
	buffer.desc_pool = vulkan.create_vk_descriptor_pool(*buffer.device, &desc_pool_create_info,
		nullptr) ?
}

pub fn (mut buffer UniformBuffer) create_descriptor_set_layout() ? {
	desc_set_layout_binding := vulkan.create_vk_descriptor_set_layout_binding(0, 1, buffer.settings.descriptor_type,
		buffer.settings.stage, [])
	desc_set_layout_create_info := vulkan.create_vk_descriptor_set_layout_create_info(nullptr,
		0, [desc_set_layout_binding])
	buffer.desc_set_layout = vulkan.create_vk_descriptor_set_layout(*buffer.device, &desc_set_layout_create_info,
		nullptr) ?
}

pub fn (mut buffer UniformBuffer) create_descriptor_set() ? {
	desc_set_allocate_info := vulkan.create_vk_descriptor_set_allocate_info(nullptr, buffer.desc_pool,
		[buffer.desc_set_layout])
	buffer.desc_set = vulkan.allocate_vk_descriptor_sets(*buffer.device, &desc_set_allocate_info) ?

	desc_buffer_info := vulkan.create_vk_descriptor_buffer_info(buffer.uniform_buffer,
		0, buffer.settings.buffer_size)

	desc_write := vulkan.create_vk_write_descriptor_set(nullptr, buffer.desc_set, 0, 0,
		1, buffer.settings.descriptor_type, [], [desc_buffer_info], [])
	vulkan.vk_update_descriptor_sets(*buffer.device, [desc_write], [])
}
