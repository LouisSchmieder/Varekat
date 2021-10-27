module vulkan

import misc

pub fn create_vk_application_info(p_next voidptr, app_name string, app_version misc.Version, engine_name string, engine_version misc.Version, api_version misc.Version) C.VkApplicationInfo {
	return C.VkApplicationInfo{
		sType: .vk_structure_type_application_info
		pNext: p_next
		pApplicationName: app_name.str
		applicationVersion: version_to_number(app_version)
		pEngineName: engine_name.str
		engineVersion: version_to_number(engine_version)
		apiVersion: version_to_number(api_version)
	}
}

pub fn create_vk_instance_create_info(p_next voidptr, flags u32, app_info &C.VkApplicationInfo, enabled_layers []string, enabled_extensions []string) C.VkInstanceCreateInfo {
	info := C.VkInstanceCreateInfo{
		sType: .vk_structure_type_instance_create_info
		pNext: p_next
		flags: flags
		pApplicationInfo: app_info
		enabledLayerCount: u32(enabled_layers.len)
		ppEnabledLayerNames: terminate_vstring_array(enabled_layers)
		enabledExtensionCount: u32(enabled_extensions.len)
		ppEnabledExtensionNames: terminate_vstring_array(enabled_extensions)
	}
	return info
}

pub fn create_vk_instance(create_info &C.VkInstanceCreateInfo) ?C.VkInstance {
	mut instance := unsafe { &C.VkInstance(malloc(int(sizeof(C.VkInstance)))) }
	result := C.vkCreateInstance(create_info, voidptr(0), instance)
	handle_error(result) ?
	return *instance
}

pub fn create_vk_device_queue_create_info(p_next voidptr, flags u32, queue_family_idx u32, queue_count u32, queue_priorities []f32) C.VkDeviceQueueCreateInfo {
	return C.VkDeviceQueueCreateInfo{
		sType: .vk_structure_type_device_queue_create_info
		pNext: p_next
		flags: flags
		queueFamilyIndex: queue_family_idx
		queueCount: queue_count
		pQueuePriorities: queue_priorities.data
	}
}

pub fn create_vk_device_create_info(p_next voidptr, flags u32, create_infos []C.VkDeviceQueueCreateInfo, enabled_layers []string, enabled_extensions []string, enabled_features &C.VkPhysicalDeviceFeatures) C.VkDeviceCreateInfo {
	return C.VkDeviceCreateInfo{
		sType: .vk_structure_type_device_create_info
		pNext: p_next
		flags: flags
		queueCreateInfoCount: u32(create_infos.len)
		pQueueCreateInfos: create_infos.data
		enabledLayerCount: u32(enabled_layers.len)
		ppEnabledLayerNames: terminate_vstring_array(enabled_layers)
		enabledExtensionCount: u32(enabled_extensions.len)
		ppEnabledExtensionNames: terminate_vstring_array(enabled_extensions)
		pEnabledFeatures: enabled_features
	}
}

pub fn create_vk_swapchain_create_info(p_next voidptr, flags u32, surface C.VkSurfaceKHR, min_image_count u32, format C.VkSurfaceFormatKHR, image_extent C.VkExtent2D, image_array_layers u32, image_usage u32, image_sharing_mode u32, queue_family_indicies []u32, pre_transform u32, composite_alpha u32, present_mode VkPresentModeKHR, clipped C.VkBool32, old_swapchain C.VkSwapchainKHR) C.VkSwapchainCreateInfoKHR {
	return C.VkSwapchainCreateInfoKHR{
		sType: .vk_structure_type_swapchain_create_info_khr
		pNext: p_next
		flags: flags
		surface: surface
		minImageCount: min_image_count
		imageFormat: format.format
		imageColorSpace: format.colorSpace
		imageExtent: image_extent
		imageArrayLayers: image_array_layers
		imageUsage: image_usage
		imageSharingMode: image_sharing_mode
		queueFamilyIndexCount: u32(queue_family_indicies.len)
		pQueueFamilyIndices: queue_family_indicies.data
		preTransform: pre_transform
		compositeAlpha: composite_alpha
		presentMode: present_mode
		clipped: clipped
		oldSwapchain: old_swapchain
	}
}

pub fn create_vk_image_view_create_info(p_next voidptr, flags u32, image C.VkImage, view_type u32, format u32, swizzle C.VkComponentMapping, subresource_range C.VkImageSubresourceRange) C.VkImageViewCreateInfo {
	return C.VkImageViewCreateInfo{
		sType: .vk_structure_type_image_view_create_info
		pNext: p_next
		flags: flags
		image: image
		viewType: view_type
		format: format
		components: swizzle
		subresourceRange: subresource_range
	}
}

pub fn create_vk_shader_module_create_info(p_next voidptr, flags u32, code []byte) C.VkShaderModuleCreateInfo {
	return C.VkShaderModuleCreateInfo{
		sType: .vk_structure_type_shader_module_create_info
		pNext: p_next
		flags: flags
		codeSize: u32(code.len)
		pCode: &u32(code.data)
	}
}

pub fn create_vk_pipeline_shader_stage_create_info(p_next voidptr, flags u32, stage u32, modul C.VkShaderModule, name string, specialization_info voidptr) C.VkPipelineShaderStageCreateInfo {
	return C.VkPipelineShaderStageCreateInfo{
		sType: .vk_structure_type_pipeline_shader_stage_create_info
		pNext: p_next
		flags: flags
		stage: stage
		@module: modul
		pName: terminate_vstring(name)
		pSpecializationInfo: specialization_info
	}
}

pub fn create_vk_pipeline_vertex_input_state_create_info(p_next voidptr, flags u32, vertex_binding_desc []C.VkVertexInputBindingDescription, vertex_binding_attr []C.VkVertexInputAttributeDescription) C.VkPipelineVertexInputStateCreateInfo {
	return C.VkPipelineVertexInputStateCreateInfo{
		sType: .vk_structure_type_pipeline_vertex_input_state_create_info
		pNext: p_next
		flags: flags
		vertexBindingDescriptionCount: u32(vertex_binding_desc.len)
		pVertexBindingDescriptions: vertex_binding_desc.data
		vertexAttributeDescriptionCount: u32(vertex_binding_attr.len)
		pVertexAttributeDescriptions: vertex_binding_attr.data
	}
}

pub fn create_vk_pipeline_input_assembly_state_create_info(p_next voidptr, flags u32, topology u32, primitive_restart_enable C.VkBool32) C.VkPipelineInputAssemblyStateCreateInfo {
	return C.VkPipelineInputAssemblyStateCreateInfo{
		sType: .vk_structure_type_pipeline_input_assembly_state_create_info
		pNext: p_next
		flags: flags
		topology: topology
		primitiveRestartEnable: primitive_restart_enable
	}
}

pub fn create_vk_pipeline_viewport_state_create_info(p_next voidptr, flags u32, viewports []C.VkViewport, scissors []C.VkRect2D) C.VkPipelineViewportStateCreateInfo {
	return C.VkPipelineViewportStateCreateInfo{
		sType: .vk_structure_type_pipeline_viewport_state_create_info
		pNext: p_next
		flags: flags
		viewportCount: u32(viewports.len)
		pViewports: viewports.data
		scissorCount: u32(scissors.len)
		pScissors: scissors.data
	}
}

pub fn create_vk_pipeline_rasterization_state_create_info(p_next voidptr, flags u32, depth_clamp_enabled C.VkBool32, rasterizer_discard_enable C.VkBool32, polygon_mode u32, cull_mode u32, front_face u32, depth_bias_enable C.VkBool32, depth_bias_constant_factor f32, depth_bias_clamp f32, depth_bias_slope_factor f32, line_width f32) C.VkPipelineRasterizationStateCreateInfo {
	return C.VkPipelineRasterizationStateCreateInfo{
		sType: .vk_structure_type_pipeline_rasterization_state_create_info
		pNext: p_next
		flags: flags
		depthClampEnable: depth_clamp_enabled
		rasterizerDiscardEnable: rasterizer_discard_enable
		polygonMode: polygon_mode
		cullMode: cull_mode
		frontFace: front_face
		depthBiasEnable: depth_bias_enable
		depthBiasConstantFactor: depth_bias_constant_factor
		depthBiasClamp: depth_bias_clamp
		depthBiasSlopeFactor: depth_bias_slope_factor
		lineWidth: line_width
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

pub fn create_vk_pipeline_multisample_state_create_info(p_next voidptr, flags u32, rasterization_samples u32, sample_shading_enable C.VkBool32, min_sample_shading f32, sample_mask &C.VkSampleMask, alpha_to_coverage_enable C.VkBool32, alpha_to_one_enable C.VkBool32) C.VkPipelineMultisampleStateCreateInfo {
	return C.VkPipelineMultisampleStateCreateInfo{
		sType: .vk_structure_type_pipeline_multisample_state_create_info
		pNext: p_next
		flags: flags
		rasterizationSamples: rasterization_samples
		sampleShadingEnable: sample_shading_enable
		minSampleShading: min_sample_shading
		pSampleMask: sample_mask
		alphaToCoverageEnable: alpha_to_coverage_enable
		alphaToOneEnable: alpha_to_one_enable
	}
}

pub fn create_vk_pipeline_color_blend_attachment_state(blend_enable C.VkBool32, src_color_blend_factor BlendFactor, dst_color_blend_factor BlendFactor, color_blend_op BlendOp, src_alpha_blend_factor BlendFactor, dst_alpha_blend_factor BlendFactor, alpha_blend_op BlendOp, color_write_mask u32) C.VkPipelineColorBlendAttachmentState {
	return C.VkPipelineColorBlendAttachmentState{
		blendEnable: blend_enable
		srcColorBlendFactor: src_color_blend_factor
		dstColorBlendFactor: dst_color_blend_factor
		colorBlendOp: color_blend_op
		srcAlphaBlendFactor: src_alpha_blend_factor
		dstAlphaBlendFactor: dst_alpha_blend_factor
		alphaBlendOp: alpha_blend_op
		colorWriteMask: color_write_mask
	}
}

pub fn create_vk_pipeline_color_blend_state_create_info(p_next voidptr, flags u32, logic_op_enable C.VkBool32, logic_op LogicOp, attachments []C.VkPipelineColorBlendAttachmentState, blend_constants []f32) C.VkPipelineColorBlendStateCreateInfo {
	return C.VkPipelineColorBlendStateCreateInfo{
		sType: .vk_structure_type_pipeline_color_blend_state_create_info
		pNext: p_next
		flags: flags
		logicOpEnable: logic_op_enable
		logicOp: logic_op
		attachmentCount: u32(attachments.len)
		pAttachments: attachments.data
		blendConstants: blend_constants
	}
}

pub fn create_vk_pipeline_layout_create_info(p_next voidptr, flags u32, layouts []C.VkDescriptorSetLayout, push_constant_range []C.VkPushConstantRange) C.VkPipelineLayoutCreateInfo {
	return C.VkPipelineLayoutCreateInfo{
		sType: .vk_structure_type_pipeline_layout_create_info
		pNext: p_next
		flags: flags
		setLayoutCount: u32(layouts.len)
		pSetLayouts: layouts.data
		pushConstantRangeCount: u32(push_constant_range.len)
		pPushConstantRanges: push_constant_range.data
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
