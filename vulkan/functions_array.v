module vulkan

fn to_v_array<T>(d &T, len u32) []T {
	mut res := []T{len: int(len)}
	for i in 0 .. len {
		unsafe {
			res[i] = d[i]
		}
	}
	unsafe {
		free(d)
	}
	return res
}

fn create_c_array<T>(len u32) &T {
	return unsafe { &T(malloc(int(sizeof(T) * len))) }
}

pub fn get_vk_physical_devices(instance C.VkInstance) ?[]C.VkPhysicalDevice {
	amount := get_vk_physical_devices_amount(instance) ?
	devices := create_c_array<C.VkPhysicalDevice>(amount)
	result := C.vkEnumeratePhysicalDevices(instance, &amount, devices)
	handle_error(result, 'get_vk_physical_devices') ?
	return to_v_array<C.VkPhysicalDevice>(devices, amount)
}

pub fn get_vk_physical_device_queue_family_properties(device C.VkPhysicalDevice) []C.VkQueueFamilyProperties {
	amount := get_vk_physical_device_queue_family_properties_amount(device)
	properties := create_c_array<C.VkQueueFamilyProperties>(amount)
	C.vkGetPhysicalDeviceQueueFamilyProperties(device, &amount, properties)
	return to_v_array<C.VkQueueFamilyProperties>(properties, amount)
}

pub fn get_vk_instance_layer_properties() ?[]C.VkLayerProperties {
	amount := get_vk_instance_layer_properties_amount() ?
	properties := create_c_array<C.VkLayerProperties>(amount)
	result := C.vkEnumerateInstanceLayerProperties(&amount, properties)
	handle_error(result, 'get_vk_instance_layer_properties') ?
	return to_v_array<C.VkLayerProperties>(properties, amount)
}

pub fn get_vk_instance_extension_properties(layer_name string) ?[]C.VkExtensionProperties {
	amount := get_vk_instance_extension_properties_amount(layer_name) ?
	mut name := layer_name.str
	if layer_name.len == 0 {
		name = charptr(0)
	}
	properties := create_c_array<C.VkExtensionProperties>(amount)
	res := C.vkEnumerateInstanceExtensionProperties(name, &amount, properties)
	handle_error(res, 'get_vk_instance_extension_properties') ?
	return to_v_array<C.VkExtensionProperties>(properties, amount)
}

pub fn get_vk_physical_device_surface_formats(device C.VkPhysicalDevice, surface C.VkSurfaceKHR) ?[]C.VkSurfaceFormatKHR {
	amount := get_vk_physical_device_surface_formats_amount(device, surface) ?
	formats := create_c_array<C.VkSurfaceFormatKHR>(amount)
	res := C.vkGetPhysicalDeviceSurfaceFormatsKHR(device, surface, &amount, formats)
	handle_error(res, 'get_vk_physical_device_surface_formats') ?
	return to_v_array<C.VkSurfaceFormatKHR>(formats, amount)
}

pub fn get_vk_physical_device_surface_present_modes(device C.VkPhysicalDevice, surface C.VkSurfaceKHR) ?[]VkPresentModeKHR {
	amount := get_vk_physical_device_surface_present_modes_amount(device, surface) ?
	modes := create_c_array<VkPresentModeKHR>(amount)
	res := C.vkGetPhysicalDeviceSurfacePresentModesKHR(device, surface, &amount, modes)
	handle_error(res, 'get_vk_physical_device_surface_present_modes') ?
	return to_v_array<VkPresentModeKHR>(modes, amount)
}

pub fn get_vk_swapchain_image(device C.VkDevice, swapchain C.VkSwapchainKHR) ?[]C.VkImage {
	amount := get_vk_swapchain_image_amount(device, swapchain) ?
	images := create_c_array<C.VkImage>(amount)
	res := C.vkGetSwapchainImagesKHR(device, swapchain, &amount, images)
	handle_error(res, 'get_vk_swapchain_image') ?
	return to_v_array<C.VkImage>(images, amount)
}

pub fn create_vk_graphics_pipelines(device C.VkDevice, cache C.VkPipelineCache, create_infos []C.VkGraphicsPipelineCreateInfo, alloc voidptr) ?[]C.VkPipeline {
	mut pipelines := create_c_array<C.VkPipeline>(u32(create_infos.len))
	res := C.vkCreateGraphicsPipelines(device, cache, create_infos.len, create_infos.data,
		alloc, pipelines)
	handle_error(res, 'create_vk_graphics_pipelines') ?
	return to_v_array<C.VkPipeline>(pipelines, u32(create_infos.len))
}

pub fn allocate_vk_command_buffers(device C.VkDevice, create_info &C.VkCommandBufferAllocateInfo) ?[]C.VkCommandBuffer {
	mut buffers := create_c_array<C.VkCommandBuffer>(create_info.commandBufferCount)
	res := C.vkAllocateCommandBuffers(device, create_info, buffers)
	handle_error(res, 'allocate_vk_command_buffers') ?
	return to_v_array<C.VkCommandBuffer>(buffers, create_info.commandBufferCount)
}