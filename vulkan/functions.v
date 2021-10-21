module vulkan

fn C.vkCreateInstance(&C.VkInstanceCreateInfo, voidptr, &C.VkInstance) VkResult

fn handle_error(res VkResult) ? {
	if res != 0 {
		return error('Something went wrong with Vulkan. ($res)')
	}
}