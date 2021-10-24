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
