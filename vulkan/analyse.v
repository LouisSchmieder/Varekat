module vulkan

pub struct AnalysedGPUSettings {
pub:
	queue_family_idx u32
	queues           u32
}

pub fn analyse(devices []C.VkPhysicalDevice) ([]AnalysedGPUSettings, int) {
	mut settings := []AnalysedGPUSettings{}
	for device in devices {
		settings << analyse_device(device)
	}
	return settings, 0
}

fn analyse_device(device C.VkPhysicalDevice) AnalysedGPUSettings {
	analyse_properties(device)
	analyse_features(device)
	queue_family_idx, queues := analyse_family(device)
	_ := get_vk_physical_device_memory_properties(device)
	return AnalysedGPUSettings{
		queue_family_idx: queue_family_idx
		queues: queues
	}
}

fn analyse_properties(device C.VkPhysicalDevice) {
	_ := get_vk_physical_device_properties(device)
}

fn analyse_features(device C.VkPhysicalDevice) {
	_ := get_vk_physical_device_features(device)
}

fn analyse_family(device C.VkPhysicalDevice) (u32, u32) {
	family_properties := get_vk_physical_device_queue_family_properties(device)
	mut idx := u32(0)
	mut len := u32(0)

	for i, prop in family_properties {
		if len < prop.queueCount {
			len = prop.queueCount
			idx = u32(i)
		}
	}

	return idx, len
}
