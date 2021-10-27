module vulkan

#pkgconfig vulkan
#include <vulkan/vulkan.h>

pub const (
	vk_color_component_all = u32(C.VK_COLOR_COMPONENT_R_BIT | C.VK_COLOR_COMPONENT_G_BIT | C.VK_COLOR_COMPONENT_B_BIT | C.VK_COLOR_COMPONENT_A_BIT)
	vk_true                = C.VkBool32(C.VK_TRUE)
	vk_false               = C.VkBool32(C.VK_FALSE)
)
