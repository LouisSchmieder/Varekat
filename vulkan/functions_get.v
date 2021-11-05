module vulkan

pub fn get_vk_physical_device_properties(device C.VkPhysicalDevice) C.VkPhysicalDeviceProperties {
	props := C.VkPhysicalDeviceProperties{}
	C.vkGetPhysicalDeviceProperties(device, &props)
	return props
}

pub fn get_vk_physical_device_features(device C.VkPhysicalDevice) C.VkPhysicalDeviceFeatures {
	features := C.VkPhysicalDeviceFeatures{}
	C.vkGetPhysicalDeviceFeatures(device, &features)
	return features
}

pub fn get_vk_physical_device_memory_properties(device C.VkPhysicalDevice) C.VkPhysicalDeviceMemoryProperties {
	mem_props := unsafe { &C.VkPhysicalDeviceMemoryProperties(malloc(int(sizeof(C.VkPhysicalDeviceMemoryProperties)))) }
	C.vkGetPhysicalDeviceMemoryProperties(device, mem_props)
	return *mem_props
}

pub fn get_vk_device_queue(device C.VkDevice, queue_family_idx u32, queue_idx u32) C.VkQueue {
	queue := unsafe { &C.VkQueue(malloc(int(sizeof(C.VkQueue)))) }
	C.vkGetDeviceQueue(device, queue_family_idx, queue_idx, queue)
	return *queue
}

pub fn get_vk_physical_device_surface_capabilities(device C.VkPhysicalDevice, surface C.VkSurfaceKHR) ?C.VkSurfaceCapabilitiesKHR {
	cap := unsafe { &C.VkSurfaceCapabilitiesKHR(malloc(int(sizeof(C.VkSurfaceCapabilitiesKHR)))) }
	res := C.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(device, surface, cap)
	handle_error(res, 'get_vk_physical_device_surface_capabilities') ?
	return *cap
}

pub fn acquire_vk_next_image(device C.VkDevice, swapchain C.VkSwapchainKHR, timeout u64, semaphore C.VkSemaphore, fence C.VkFence) ?u32 {
	idx := u32(0)
	res := C.vkAcquireNextImageKHR(device, swapchain, timeout, semaphore, fence, &idx)
	handle_error(res, 'acquire_vk_next_image') ?
	return idx
}

pub fn get_vk_memory_requirements(device C.VkDevice, buffer C.VkBuffer) C.VkMemoryRequirements {
	req := unsafe { &C.VkMemoryRequirements(malloc(int(sizeof(C.VkMemoryRequirements)))) }
	C.vkGetBufferMemoryRequirements(device, buffer, req)
	return *req
}
