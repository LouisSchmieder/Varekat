module vulkan

import misc

#pkgconfig vulkan
#include <vulkan/vulkan.h>

pub fn create() ? {
	app_info := create_vk_application_info(voidptr(0), "Vulkan Test", misc.make_version(0, 0, 1), "Test Engine", misc.make_version(0, 0, 1), misc.make_version(1, 0, 0))
	instance_create_info := create_vk_instance_create_info(voidptr(0), 0, &app_info, [], [])
	instance := create_vk_instance(instance_create_info) ?
}