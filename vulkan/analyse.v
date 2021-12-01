module vulkan

pub struct AnalysedGPUSettings {
pub:
	queue_family_idx u32
	queues           u32
}

pub fn analyse(devices []C.VkPhysicalDevice, needed_family_flags []u32) ?([]AnalysedGPUSettings, int) {
	mut settings := []AnalysedGPUSettings{}
	for device in devices {
		settings << analyse_device(device, needed_family_flags) ?
	}
	return settings, 0
}

fn analyse_device(device C.VkPhysicalDevice, needed_family_flags []u32) ?AnalysedGPUSettings {
	analyse_properties(device)
	analyse_features(device)
	queue_family_idx, queues := analyse_family(device, needed_family_flags) ?
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

fn analyse_family(device C.VkPhysicalDevice, needed_family_flags []u32) ?(u32, u32) {
	family_properties := get_vk_physical_device_queue_family_properties(device)
	mut unset := true
	mut idx := u32(0)
	mut len := u32(0)

	mut flags := u32(0)
	for flag in needed_family_flags {
		flags |= flag
	}

	$if debug {
		eprintln('Needed family flags')
		print_queue_flags(flags)
	}

	for i, prop in family_properties {
		if len < prop.queueCount {
			$if debug {
				eprintln('Family properties $i:')
				print_queue_flags(prop.queueFlags)
			}
			
			if (prop.queueFlags & flags) == 0 {
				continue
			}

			len = prop.queueCount
			idx = u32(i)
			unset = false
		}
	}
	if unset {
		panic('No family was found which has the needed flags!')
	}

	$if debug {
		eprintln('Chosen family $idx and got queue length $len')
	}

	return idx, len
}

fn print_queue_flags(flags u32) {
	mut bits := []bool{}
	for i in 0 .. 32 {
		a := flags & (0x01 << (31 - i)) != 0
		bits << a
	}

	for i in 0 .. 32 {
		if bits[i] {
			eprint('1')
		} else {
			eprint('0')
		}
		if (i + 1) % 4 == 0 {
			eprint(' ')
		}
	}
	eprintln('')
}
