module vulkan

import misc

pub fn create_vk_application_info(p_next voidptr, app_name string, app_version misc.Version, engine_name string, engine_version misc.Version, api_version misc.Version) C.VkApplicationInfo {
	return C.VkApplicationInfo{
		sType: C.VK_STRUCTURE_TYPE_APPLICATION_INFO
		pNext: p_next
		pApplicationName: app_name.str
		applicationVersion: version_to_number(app_version)
		pEngineName: engine_name.str
		engineVersion: version_to_number(engine_version)
		apiVersion: version_to_number(api_version)
	}
}

pub fn create_vk_instance_create_info(p_next voidptr, flags u32, app_info &C.VkApplicationInfo, enabled_layers []string, enabled_extensions []string) C.VkInstanceCreateInfo {
	info := C.VkInstanceCreateInfo{
		sType: C.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO
		pNext: p_next
		flags: flags
		pApplicationInfo: app_info
		enabledLayerCount: u32(enabled_layers.len)
		ppEnabledLayerNames: terminate_vstring_array(enabled_layers)
		enabledExtensionCount: u32(enabled_extensions.len)
		ppEnabledExtensionNames: terminate_vstring_array(enabled_extensions)
	}
	return info
}

pub fn create_vk_instance(create_info &C.VkInstanceCreateInfo) ?C.VkInstance {
	mut instance := unsafe { &C.VkInstance(malloc(int(sizeof(C.VkInstance)))) }
	result := C.vkCreateInstance(create_info, voidptr(0), instance)
	handle_error(result) ?
	return *instance
}

pub fn create_vk_device_queue_create_info(p_next voidptr, flags u32, queue_family_idx u32, queue_count u32, queue_priorities []f32) C.VkDeviceQueueCreateInfo {
	return C.VkDeviceQueueCreateInfo{
		sType: C.VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO
		pNext: p_next
		flags: flags
		queueFamilyIndex: queue_family_idx
		queueCount: queue_count
		pQueuePriorities: queue_priorities.data
	}
}

pub fn create_vk_device_create_info(p_next voidptr, flags u32, create_infos []C.VkDeviceQueueCreateInfo, enabled_layers []string, enabled_extensions []string, enabled_features &C.VkPhysicalDeviceFeatures) C.VkDeviceCreateInfo {
	return C.VkDeviceCreateInfo{
		sType: C.VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO
		pNext: p_next
		flags: flags
		queueCreateInfoCount: u32(create_infos.len)
		pQueueCreateInfos: create_infos.data
		enabledLayerCount: u32(enabled_layers.len)
		ppEnabledLayerNames: terminate_vstring_array(enabled_layers)
		enabledExtensionCount: u32(enabled_extensions.len)
		ppEnabledExtensionNames: terminate_vstring_array(enabled_extensions)
		pEnabledFeatures: enabled_features
	}
}

pub fn create_vk_swapchain_create_info(p_next voidptr, flags u32, surface C.VkSurfaceKHR, min_image_count u32, format C.VkSurfaceFormatKHR, image_extent C.VkExtent2D, image_array_layers u32, image_usage u32, image_sharing_mode u32, queue_family_indicies []u32, pre_transform u32, composite_alpha u32, present_mode VkPresentModeKHR, clipped C.VkBool32, old_swapchain C.VkSwapchainKHR) C.VkSwapchainCreateInfoKHR {
	return C.VkSwapchainCreateInfoKHR{
		sType: C.VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR
		pNext: p_next
		flags: flags
		surface: surface
		minImageCount: min_image_count
		imageFormat: format.format
		imageColorSpace: format.colorSpace
		imageExtent: image_extent
		imageArrayLayers: image_array_layers
		imageUsage: image_usage
		imageSharingMode: image_sharing_mode
		queueFamilyIndexCount: u32(queue_family_indicies.len)
		pQueueFamilyIndices: queue_family_indicies.data
		preTransform: pre_transform
		compositeAlpha: composite_alpha
		presentMode: present_mode
		clipped: clipped
		oldSwapchain: old_swapchain
	}
}

pub fn create_vk_image_view_create_info(p_next voidptr, flags u32, image C.VkImage, view_type u32, format u32, swizzle C.VkComponentMapping, subresource_range C.VkImageSubresourceRange) C.VkImageViewCreateInfo {
	return C.VkImageViewCreateInfo{
		sType: C.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO
		pNext: p_next
		flags: flags
		image: image
		viewType: view_type
		format: format
		components: swizzle
		subresourceRange: subresource_range
	}
}

pub fn create_vk_component_mapping(r u32, g u32, b u32, a u32) C.VkComponentMapping {
	return C.VkComponentMapping{
		r: r
		g: g
		b: b
		a: a
	}
}

pub fn create_vk_image_subresource_range(aspect_mask u32, base_mip_level u32, level_count u32, base_array_layer u32, layer_count u32) C.VkImageSubresourceRange {
	return C.VkImageSubresourceRange{
		aspectMask: aspect_mask
		baseMipLevel: base_mip_level
		levelCount: level_count
		baseArrayLayer: base_array_layer
		layerCount: layer_count
	}
}

pub fn create_vk_device(physical_device C.VkPhysicalDevice, device_create_info &C.VkDeviceCreateInfo) ?C.VkDevice {
	mut device := unsafe { &C.VkDevice(malloc(int(sizeof(C.VkDevice)))) }
	result := C.vkCreateDevice(physical_device, device_create_info, voidptr(0), device)
	handle_error(result) ?
	return *device
}

pub fn create_vk_create_window_surface(instance C.VkInstance, window &C.GLFWwindow, alloc voidptr) ?C.VkSurfaceKHR {
	mut surface := unsafe { &C.VkSurfaceKHR(malloc(int(sizeof(C.VkSurfaceKHR)))) }
	res := C.glfwCreateWindowSurface(instance, window, alloc, surface)
	handle_error(res) ?
	return *surface
}

pub fn create_vk_swapchain(device C.VkDevice, create_info &C.VkSwapchainCreateInfoKHR, alloc voidptr) ?C.VkSwapchainKHR {
	mut swapchain := unsafe { &C.VkSwapchainKHR(malloc(int(sizeof(C.VkSwapchainKHR)))) }
	res := C.vkCreateSwapchainKHR(device, create_info, alloc, swapchain)
	handle_error(res) ?
	return *swapchain
}

pub fn create_vk_image_view(device C.VkDevice, create_info &C.VkImageViewCreateInfo, alloc voidptr) ?C.VkImageView {
	mut image_view := unsafe { &C.VkImageView(malloc(int(sizeof(C.VkImageView)))) }
	res := C.vkCreateImageView(device, create_info, alloc, image_view)
	handle_error(res) ?
	return *image_view
}
