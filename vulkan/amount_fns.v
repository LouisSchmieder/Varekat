module vulkan

pub fn get_vk_physical_devices_amount(instance C.VkInstance) ?u32 {
	mut amount := u32(0)
	result := C.vkEnumeratePhysicalDevices(instance, &amount, voidptr(0))
	handle_error(result) ?
	return amount
}

pub fn get_vk_physical_device_queue_family_properties_amount(device C.VkPhysicalDevice) u32 {
	mut amount := u32(0)
	C.vkGetPhysicalDeviceQueueFamilyProperties(device, &amount, voidptr(0))
	return amount
}

pub fn get_vk_instance_layer_properties_amount() ?u32 {
	mut amount := u32(0)
	result := C.vkEnumerateInstanceLayerProperties(&amount, voidptr(0))
	handle_error(result) ?
	return amount
}

pub fn get_vk_instance_extension_properties_amount(layer_name string) ?u32 {
	mut amount := u32(0)
	mut name := layer_name.str
	if layer_name.len == 0 {
		name = charptr(0)
	}
	result := C.vkEnumerateInstanceExtensionProperties(name, &amount, voidptr(0))
	handle_error(result) ?
	return amount
}

pub fn get_vk_physical_device_surface_formats_amount(device C.VkPhysicalDevice, surface C.VkSurfaceKHR) ?u32 {
	mut amount := u32(0)
	res := C.vkGetPhysicalDeviceSurfaceFormatsKHR(device, surface, &amount, voidptr(0))
	handle_error(res) ?
	return amount
}

pub fn get_vk_physical_device_surface_present_modes_amount(device C.VkPhysicalDevice, surface C.VkSurfaceKHR) ?u32 {
	mut amount := u32(0)
	res := C.vkGetPhysicalDeviceSurfacePresentModesKHR(device, surface, &amount, voidptr(0))
	handle_error(res) ?
	return amount
}

pub fn get_vk_swapchain_image_amount(device C.VkDevice, swapchain C.VkSwapchainKHR) ?u32 {
	mut amount := u32(0)
	res := C.vkGetSwapchainImagesKHR(device, swapchain, &amount, voidptr(0))
	handle_error(res) ?
	return amount
}
