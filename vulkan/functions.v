module vulkan

import strings

fn C.vkCreateInstance(&C.VkInstanceCreateInfo, voidptr, &C.VkInstance) VkResult
fn C.vkEnumeratePhysicalDevices(C.VkInstance, &u32, &C.VkPhysicalDevice) VkResult
fn C.vkCreateDevice(C.VkPhysicalDevice, &C.VkDeviceCreateInfo, voidptr, &C.VkDevice) VkResult
fn C.vkEnumerateInstanceLayerProperties(&u32, &C.VkLayerProperties) VkResult
fn C.vkEnumerateInstanceExtensionProperties(charptr, &u32, &C.VkExtensionProperties) VkResult

fn C.vkGetPhysicalDeviceProperties(C.VkPhysicalDevice, &C.VkPhysicalDeviceProperties)
fn C.vkGetPhysicalDeviceFeatures(C.VkPhysicalDevice, &C.VkPhysicalDeviceFeatures)
fn C.vkGetPhysicalDeviceMemoryProperties(C.VkPhysicalDevice, &C.VkPhysicalDeviceMemoryProperties)
fn C.vkGetPhysicalDeviceQueueFamilyProperties(C.VkPhysicalDevice, &u32, &C.VkQueueFamilyProperties)
fn C.vkGetDeviceQueue(C.VkDevice, u32, u32, &C.VkQueue)

fn C.vkDeviceWaitIdle(C.VkDevice)
fn C.vkDestroyInstance(C.VkInstance, voidptr)
fn C.vkDestroyDevice(C.VkDevice, voidptr)

fn handle_error(res VkResult) ? {
	if res != 0 {
		return error('Something went wrong with Vulkan. ($res)')
	}
}

pub fn vk_device_wait_idle(device C.VkDevice) {
	C.vkDeviceWaitIdle(device)
}

pub fn vk_destroy_instance(instance C.VkInstance, allocator voidptr) {
	C.vkDestroyInstance(instance, allocator)
}

pub fn vk_destroy_device(device C.VkDevice, allocator voidptr) {
	C.vkDestroyDevice(device, allocator)
}

pub fn print_stats(device C.VkPhysicalDevice) {
	properties := get_vk_physical_device_properties(device)
	features := get_vk_physical_device_features(device)
	memory_properties := get_vk_physical_device_memory_properties(device)
	family_properties := get_vk_physical_device_queue_family_properties(device)
}

pub fn print_layer_properties(layer C.VkLayerProperties) string {
	mut builder := strings.new_builder(100)
	builder.writeln('${string(layer.layerName)}:')
	builder.writeln('  SpecVersion: ${number_to_version(layer.specVersion)}')
	builder.writeln('  ImplementationVersion: ${number_to_version(layer.implementationVersion)}')
	builder.writeln('  Description: ${string(layer.description)}')
	res := builder.str()
	unsafe {
		builder.free()
	}
	return res
}

pub fn print_extension_properties(extension C.VkExtensionProperties) string {
	mut builder := strings.new_builder(100)
	builder.writeln('${string(extension.extensionName)}:')
	builder.writeln('  SpecVersion: ${number_to_version(extension.specVersion)}')
	res := builder.str()
	unsafe {
		builder.free()
	}
	return res
}

pub fn terminate_vstring(str string) charptr {
	mut bytes := str.bytes()
	bytes << `\0`
	return charptr(bytes.data)
}

pub fn terminate_vstring_array(strings []string) &charptr {
	mut ptrs := []charptr{len: strings.len}
	for i, str in strings {
		ptrs[i] = terminate_vstring(str)
	}
	return ptrs.data
}
