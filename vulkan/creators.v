module vulkan

import misc

pub fn create_vk_application_info(p_next voidptr, app_name string, app_version misc.Version, engine_name string, engine_version misc.Version, api_version misc.Version) C.VkApplicationInfo {
	return C.VkApplicationInfo{
		sType: C.VK_STRUCTURE_TYPE_APPLICATION_INFO
		pNext: p_next
		pApplicationName: app_name.str
		applicationVersion: C.VK_MAKE_VERSION(app_version.major, app_version.minor, app_version.patch)
		pEngineName: engine_name.str
		engineVersion: C.VK_MAKE_VERSION(engine_version.major, engine_version.minor, engine_version.patch)
		apiVersion: C.VK_MAKE_VERSION(api_version.major, api_version.minor, api_version.patch)
	}
}

pub fn create_vk_instance_create_info(p_next voidptr, flags u32, app_info &C.VkApplicationInfo, enabled_layers []string, enabled_extensions []string) C.VkInstanceCreateInfo {
	return C.VkInstanceCreateInfo{
		sType: C.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO
		pNext: p_next
		flags: flags
		pApplicationInfo: app_info
		enabledLayerCount: u32(enabled_layers.len)
		ppEnabledLayerNames: enabled_layers.data
		enabledExtensionCount: u32(enabled_extensions.len)
		ppEnabledExtensionNames: enabled_extensions.data
	}
}

pub fn create_vk_instance(create_info &C.VkInstanceCreateInfo) ?C.VkInstance {
	mut instance := unsafe { &C.VkInstance(malloc(int(sizeof(C.VkInstance)))) }
	result := C.vkCreateInstance(create_info, voidptr(0), instance)
	handle_error(result) ?
	return *instance
}