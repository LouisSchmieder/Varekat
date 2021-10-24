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
	// Error when 2 layers or extensions are used

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

pub fn create_vk_device(physical_device C.VkPhysicalDevice, device_create_info &C.VkDeviceCreateInfo) ?C.VkDevice {
	mut device := unsafe { &C.VkDevice(malloc(int(sizeof(C.VkDevice)))) }
	result := C.vkCreateDevice(physical_device, device_create_info, voidptr(0), device)
	handle_error(result) ?
	return *device
}
