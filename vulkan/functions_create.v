module vulkan

pub fn create_vk_subpass_description(flags u32, pipeline_bind_point PipelineBindPoint, input_attachment []C.VkAttachmentReference, color_attachments []C.VkAttachmentReference, resolve_attachments []C.VkAttachmentReference, depth_stencil_attachment []C.VkAttachmentReference, preserve_attachments []u32) C.VkSubpassDescription {
	return C.VkSubpassDescription{
		flags: flags
		pipelineBindPoint: pipeline_bind_point
		inputAttachmentCount: u32(input_attachment.len)
		pInputAttachments: input_attachment.data
		colorAttachmentCount: u32(color_attachments.len)
		pColorAttachments: color_attachments.data
		pResolveAttachments: resolve_attachments.data
		pDepthStencilAttachment: depth_stencil_attachment.data
		preserveAttachmentCount: u32(preserve_attachments.len)
		pPreserveAttachments: preserve_attachments.data
	}
}

pub fn create_vk_attachment_reference(attachment u32, layout ImageLayout) C.VkAttachmentReference {
	return C.VkAttachmentReference{
		attachment: attachment
		layout: layout
	}
}

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

pub fn create_vk_descriptor_set_layout_binding(binding u32, desc_type []DescriptorType, stage_flags ShaderStageFlagBits, immutable_samplers []C.VkSampler) C.VkDescriptorSetLayoutBinding {
	return C.VkDescriptorSetLayoutBinding{
		binding: binding
		descriptorType: desc_type.data
		descriptorCount: u32(desc_type.len)
		stageFlags: stage_flags
		pImmutableSamplers: immutable_samplers.data
	}
}

pub fn create_vk_vertex_input_binding_description(binding u32, stride u32, input_rate VertexInputRate) C.VkVertexInputBindingDescription {
	return C.VkVertexInputBindingDescription{
		binding: binding
		stride: stride
		inputRate: u32(input_rate)
	}
}

pub fn create_vk_vertex_input_attribute_description(location u32, binding u32, format u32, offset u32) C.VkVertexInputAttributeDescription {
	return C.VkVertexInputAttributeDescription{
		location: location
		binding: binding
		format: format
		offset: offset
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

pub fn create_vk_descriptor_buffer_info(buffer C.VkBuffer, offset u32, range u32) C.VkDescriptorBufferInfo {
	return C.VkDescriptorBufferInfo{
		buffer: buffer
		offset: offset
		range: range
	}
}

pub fn create_vk_clear_value(r f32, g f32, b f32, a f32) C.VkClearValue {
	mut vals := [4]f32{}
	vals[0] = r
	vals[1] = g
	vals[2] = b
	vals[3] = a
	return C.VkClearValue{
		color: C.VkClearColorValue{
			float32: vals
		}
	}
}

pub fn create_vk_descriptor_pool_size(typ DescriptorType, desc_count u32) C.VkDescriptorPoolSize {
	return C.VkDescriptorPoolSize{
		@type: typ
		descriptorCount: desc_count
	}
}

pub fn create_vk_subpass_dependency(src_subpass u32, dst_subpass u32, src_stage_mask PipelineStageFlagBits, dst_stage_mask PipelineStageFlagBits, src_access_mask u32, dst_access_mask u32, dependency_flags u32) C.VkSubpassDependency {
	return C.VkSubpassDependency{
		srcSubpass: src_subpass
		dstSubpass: dst_subpass
		srcStageMask: src_stage_mask
		dstStageMask: dst_stage_mask
		srcAccessMask: src_access_mask
		dstAccessMask: dst_access_mask
		dependencyFlags: dependency_flags
	}
}

pub fn create_vk_instance(create_info &C.VkInstanceCreateInfo) ?C.VkInstance {
	mut instance := unsafe { &C.VkInstance(malloc(int(sizeof(C.VkInstance)))) }
	result := C.vkCreateInstance(create_info, voidptr(0), instance)
	handle_error(result, 'create_vk_instance') ?
	return *instance
}

pub fn create_vk_device(physical_device C.VkPhysicalDevice, device_create_info &C.VkDeviceCreateInfo) ?C.VkDevice {
	mut device := unsafe { &C.VkDevice(malloc(int(sizeof(C.VkDevice)))) }
	result := C.vkCreateDevice(physical_device, device_create_info, voidptr(0), device)
	handle_error(result, 'create_vk_device') ?
	return *device
}

pub fn create_vk_create_window_surface(instance C.VkInstance, window &C.GLFWwindow, alloc voidptr) ?C.VkSurfaceKHR {
	mut surface := unsafe { &C.VkSurfaceKHR(malloc(int(sizeof(C.VkSurfaceKHR)))) }
	res := C.glfwCreateWindowSurface(instance, window, alloc, surface)
	handle_error(res, 'create_vk_create_window_surface') ?
	return *surface
}

pub fn create_vk_swapchain(device C.VkDevice, create_info &C.VkSwapchainCreateInfoKHR, alloc voidptr) ?C.VkSwapchainKHR {
	mut swapchain := unsafe { &C.VkSwapchainKHR(malloc(int(sizeof(C.VkSwapchainKHR)))) }
	res := C.vkCreateSwapchainKHR(device, create_info, alloc, swapchain)
	handle_error(res, 'create_vk_swapchain') ?
	return *swapchain
}

pub fn create_vk_image_view(device C.VkDevice, create_info &C.VkImageViewCreateInfo, alloc voidptr) ?C.VkImageView {
	mut image_view := unsafe { &C.VkImageView(malloc(int(sizeof(C.VkImageView)))) }
	res := C.vkCreateImageView(device, create_info, alloc, image_view)
	handle_error(res, 'create_vk_image_view') ?
	return *image_view
}

pub fn create_vk_shader_module(device C.VkDevice, create_info &C.VkShaderModuleCreateInfo, alloc voidptr) ?C.VkShaderModule {
	mut shader_module := unsafe { &C.VkShaderModule(malloc(int(sizeof(C.VkShaderModule)))) }
	res := C.vkCreateShaderModule(device, create_info, alloc, shader_module)
	handle_error(res, 'create_vk_shader_module') ?
	return *shader_module
}

pub fn create_vk_pipeline_layout(device C.VkDevice, create_info &C.VkPipelineLayoutCreateInfo, alloc voidptr) ?C.VkPipelineLayout {
	mut pipeline_layout := unsafe { &C.VkPipelineLayout(malloc(int(sizeof(C.VkPipelineLayout)))) }
	res := C.vkCreatePipelineLayout(device, create_info, alloc, pipeline_layout)
	handle_error(res, 'create_vk_pipeline_layout') ?
	return *pipeline_layout
}

pub fn create_vk_render_pass(device C.VkDevice, create_info &C.VkRenderPassCreateInfo, alloc voidptr) ?C.VkRenderPass {
	mut render_pass := unsafe { &C.VkRenderPass(malloc(int(sizeof(C.VkRenderPass)))) }
	res := C.vkCreateRenderPass(device, create_info, alloc, render_pass)
	handle_error(res, 'create_vk_render_pass') ?
	return *render_pass
}

pub fn create_vk_framebuffer(device C.VkDevice, create_info &C.VkFramebufferCreateInfo, alloc voidptr) ?C.VkFramebuffer {
	mut framebuffer := unsafe { &C.VkFramebuffer(malloc(int(sizeof(C.VkFramebuffer)))) }
	res := C.vkCreateFramebuffer(device, create_info, alloc, framebuffer)
	handle_error(res, 'create_vk_framebuffer') ?
	return *framebuffer
}

pub fn create_vk_command_pool(device C.VkDevice, create_info &C.VkCommandPoolCreateInfo, alloc voidptr) ?C.VkCommandPool {
	mut command_pool := unsafe { &C.VkCommandPool(malloc(int(sizeof(C.VkCommandPool)))) }
	res := C.vkCreateCommandPool(device, create_info, alloc, command_pool)
	handle_error(res, 'create_vk_command_pool') ?
	return *command_pool
}

pub fn create_vk_semaphore(device C.VkDevice, create_info &C.VkSemaphoreCreateInfo, alloc voidptr) ?C.VkSemaphore {
	mut semaphore := unsafe { &C.VkSemaphore(malloc(int(sizeof(C.VkSemaphore)))) }
	res := C.vkCreateSemaphore(device, create_info, alloc, semaphore)
	handle_error(res, 'create_vk_semaphore') ?
	return *semaphore
}

pub fn create_vk_buffer(device C.VkDevice, create_info &C.VkBufferCreateInfo, alloc voidptr) ?C.VkBuffer {
	mut buffer := unsafe { &C.VkBuffer(malloc(int(sizeof(C.VkBuffer)))) }
	res := C.vkCreateBuffer(device, create_info, alloc, buffer)
	handle_error(res, 'create_vk_buffer') ?
	return *buffer
}

pub fn allocate_vk_memory(device C.VkDevice, create_info &C.VkMemoryAllocateInfo, callback voidptr) ?C.VkDeviceMemory {
	mut mem := unsafe { &C.VkDeviceMemory(malloc(int(sizeof(C.VkDeviceMemory)))) }
	res := C.vkAllocateMemory(device, create_info, callback, mem)
	handle_error(res, 'allocate_vk_memory') ?
	return *mem
}

pub fn create_vk_descriptor_set_layout(device C.VkDevice, create_info &C.VkDescriptorSetLayoutCreateInfo, alloc voidptr) ?C.VkDescriptorSetLayout {
	mut set := unsafe { &C.VkDescriptorSetLayout(malloc(int(sizeof(C.VkDescriptorSetLayout)))) }
	res := C.vkCreateDescriptorSetLayout(device, create_info, alloc, set)
	handle_error(res, 'create_vk_descriptor_set_layout') ?
	return *set
}

pub fn create_vk_descriptor_pool(device C.VkDevice, create_info &C.VkDescriptorPoolCreateInfo, alloc voidptr) ?C.VkDescriptorPool {
	mut pool := unsafe { &C.VkDescriptorPool(malloc(int(sizeof(C.VkDescriptorPool)))) }
	res := C.vkCreateDescriptorPool(device, create_info, alloc, pool)
	handle_error(res, 'create_vk_descriptor_pool') ?
	return *pool
}

pub fn allocate_vk_descriptor_sets(device C.VkDevice, create_info &C.VkDescriptorSetAllocateInfo) ?C.VkDescriptorSet {
	mut set := unsafe { &C.VkDescriptorSet(malloc(int(sizeof(C.VkDescriptorSet)))) }
	res := C.vkAllocateDescriptorSets(device, create_info, set)
	handle_error(res, 'allocate_vk_descriptor_sets') ?
	return *set
}
