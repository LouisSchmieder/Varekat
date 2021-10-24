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

pub fn get_vk_physical_devices(instance C.VkInstance) ?[]C.VkPhysicalDevice {
	amount := get_vk_physical_devices_amount(instance) ?
	devices := unsafe { &C.VkPhysicalDevice(malloc(int(sizeof(C.VkPhysicalDevice) * amount))) }
	result := C.vkEnumeratePhysicalDevices(instance, &amount, devices)
	handle_error(result) ?
	return to_v_array<C.VkPhysicalDevice>(devices, amount)
}

pub fn get_vk_physical_device_queue_family_properties(device C.VkPhysicalDevice) []C.VkQueueFamilyProperties {
	amount := get_vk_physical_device_queue_family_properties_amount(device)
	properties := unsafe { &C.VkQueueFamilyProperties(malloc(int(sizeof(C.VkQueueFamilyProperties) * amount))) }
	C.vkGetPhysicalDeviceQueueFamilyProperties(device, &amount, properties)
	return to_v_array<C.VkQueueFamilyProperties>(properties, amount)
}

pub fn get_vk_instance_layer_properties() ?[]C.VkLayerProperties {
	amount := get_vk_instance_layer_properties_amount() ?
	properties := unsafe { &C.VkLayerProperties(malloc(int(sizeof(C.VkLayerProperties) * amount))) }
	result := C.vkEnumerateInstanceLayerProperties(&amount, properties)
	handle_error(result) ?
	return to_v_array<C.VkLayerProperties>(properties, amount)
}

pub fn get_vk_instance_extension_properties(layer_name string) ?[]C.VkExtensionProperties {
	amount := get_vk_instance_extension_properties_amount(layer_name) ?
	mut name := layer_name.str
	if layer_name.len == 0 {
		name = charptr(0)
	}
	properties := unsafe { &C.VkExtensionProperties(malloc(int(sizeof(C.VkExtensionProperties) * amount))) }
	res := C.vkEnumerateInstanceExtensionProperties(name, &amount, properties)
	handle_error(res) ?
	return to_v_array<C.VkExtensionProperties>(properties, amount)
}
