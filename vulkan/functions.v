module vulkan

fn C.vkCreateInstance(&C.VkInstanceCreateInfo, voidptr, &C.VkInstance) VkResult
fn C.vkEnumeratePhysicalDevices(C.VkInstance, &u32, &C.VkPhysicalDevice) VkResult
fn C.vkGetPhysicalDeviceProperties(C.VkPhysicalDevice, &C.VkPhysicalDeviceProperties)
fn C.vkGetPhysicalDeviceFeatures(C.VkPhysicalDevice, &C.VkPhysicalDeviceFeatures)
fn C.vkGetPhysicalDeviceMemoryProperties(C.VkPhysicalDevice, &C.VkPhysicalDeviceMemoryProperties)

fn handle_error(res VkResult) ? {
	if res != 0 {
		return error('Something went wrong with Vulkan. ($res)')
	}
}

pub fn print_stats(device C.VkPhysicalDevice) {
	properties := get_vk_physical_device_properties(device)
	features := get_vk_physical_device_features(device)
	memory_properties := get_vk_physical_device_memory_properties(device)
	eprintln(memory_properties)
}
