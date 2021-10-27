module vulkan

pub fn create_vk_attachment_description(flags u32, format u32, samples u32, load_op AttachmentLoadOp, store_op AttachmentStoreOp, stencil_load_op AttachmentLoadOp, stencil_store_op AttachmentStoreOp, initial_layout ImageLayout, final_layout ImageLayout) C.VkAttachmentDescription {
	return C.VkAttachmentDescription{
		flags: flags
		format: format
		samples: samples
		loadOp: load_op
		storeOp: store_op
		stencilLoadOp: stencil_load_op
		stencilStoreOp: stencil_store_op
		initialLayout: initial_layout
		finalLayout: final_layout
	}
}

pub fn create_vk_viewport(x f32, y f32, width f32, height f32, min_depth f32, max_depth f32) C.VkViewport {
	return C.VkViewport{
		x: x
		y: y
		width: width
		height: height
		minDepth: min_depth
		maxDepth: max_depth
	}
}

pub fn create_vk_component_mapping(r u32, g u32, b u32, a u32) C.VkComponentMapping {
	return C.VkComponentMapping{
		r: r
		g: g
		b: b
		a: a
	}
}

pub fn create_vk_rect_2d(offset_x int, offset_y int, width u32, height u32) C.VkRect2D {
	return C.VkRect2D{
		offset: C.VkOffset2D{
			x: offset_x
			y: offset_y
		}
		extent: C.VkExtent2D{
			width: width
			height: height
		}
	}
}

pub fn create_vk_image_subresource_range(aspect_mask u32, base_mip_level u32, level_count u32, base_array_layer u32, layer_count u32) C.VkImageSubresourceRange {
	return C.VkImageSubresourceRange{
		aspectMask: aspect_mask
		baseMipLevel: base_mip_level
		levelCount: level_count
		baseArrayLayer: base_array_layer
		layerCount: layer_count
	}
}

pub fn create_vk_instance(create_info &C.VkInstanceCreateInfo) ?C.VkInstance {
	mut instance := unsafe { &C.VkInstance(malloc(int(sizeof(C.VkInstance)))) }
	result := C.vkCreateInstance(create_info, voidptr(0), instance)
	handle_error(result) ?
	return *instance
}

pub fn create_vk_device(physical_device C.VkPhysicalDevice, device_create_info &C.VkDeviceCreateInfo) ?C.VkDevice {
	mut device := unsafe { &C.VkDevice(malloc(int(sizeof(C.VkDevice)))) }
	result := C.vkCreateDevice(physical_device, device_create_info, voidptr(0), device)
	handle_error(result) ?
	return *device
}

pub fn create_vk_create_window_surface(instance C.VkInstance, window &C.GLFWwindow, alloc voidptr) ?C.VkSurfaceKHR {
	mut surface := unsafe { &C.VkSurfaceKHR(malloc(int(sizeof(C.VkSurfaceKHR)))) }
	res := C.glfwCreateWindowSurface(instance, window, alloc, surface)
	handle_error(res) ?
	return *surface
}

pub fn create_vk_swapchain(device C.VkDevice, create_info &C.VkSwapchainCreateInfoKHR, alloc voidptr) ?C.VkSwapchainKHR {
	mut swapchain := unsafe { &C.VkSwapchainKHR(malloc(int(sizeof(C.VkSwapchainKHR)))) }
	res := C.vkCreateSwapchainKHR(device, create_info, alloc, swapchain)
	handle_error(res) ?
	return *swapchain
}

pub fn create_vk_image_view(device C.VkDevice, create_info &C.VkImageViewCreateInfo, alloc voidptr) ?C.VkImageView {
	mut image_view := unsafe { &C.VkImageView(malloc(int(sizeof(C.VkImageView)))) }
	res := C.vkCreateImageView(device, create_info, alloc, image_view)
	handle_error(res) ?
	return *image_view
}

pub fn create_vk_shader_module(device C.VkDevice, create_info &C.VkShaderModuleCreateInfo, alloc voidptr) ?C.VkShaderModule {
	mut shader_module := unsafe { &C.VkShaderModule(malloc(int(sizeof(C.VkShaderModule)))) }
	res := C.vkCreateShaderModule(device, create_info, alloc, shader_module)
	handle_error(res) ?
	return *shader_module
}

pub fn create_vk_pipeline_layout(device C.VkDevice, create_info &C.VkPipelineLayoutCreateInfo, alloc voidptr) ?C.VkPipelineLayout {
	mut pipeline_layout := unsafe { &C.VkPipelineLayout(malloc(int(sizeof(C.VkPipelineLayout)))) }
	res := C.vkCreatePipelineLayout(device, create_info, alloc, pipeline_layout)
	handle_error(res) ?
	return *pipeline_layout
}
