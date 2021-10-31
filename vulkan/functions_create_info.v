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
	return C.VkInstanceCreateInfo{
		sType: .vk_structure_type_instance_create_info
		pNext: p_next
		flags: flags
		pApplicationInfo: app_info
		enabledLayerCount: u32(enabled_layers.len)
		ppEnabledLayerNames: terminate_vstring_array(enabled_layers)
		enabledExtensionCount: u32(enabled_extensions.len)
		ppEnabledExtensionNames: terminate_vstring_array(enabled_extensions)
	}
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

pub fn create_vk_render_pass_create_info(p_next voidptr, flags u32, attachments []C.VkAttachmentDescription, subpasses []C.VkSubpassDescription, dependencies []C.VkSubpassDependency) C.VkRenderPassCreateInfo {
	return C.VkRenderPassCreateInfo{
		sType: .vk_structure_type_render_pass_create_info
		pNext: p_next
		flags: flags
		attachmentCount: u32(attachments.len)
		pAttachments: attachments.data
		subpassCount: u32(subpasses.len)
		pSubpasses: subpasses.data
		dependencyCount: u32(dependencies.len)
		pDependencies: dependencies.data
	}
}

pub fn create_vk_graphics_pipeline_create_info(p_next voidptr, flags u32, stages []C.VkPipelineShaderStageCreateInfo, p_vertex_input_state &C.VkPipelineVertexInputStateCreateInfo, p_input_assembly_state &C.VkPipelineInputAssemblyStateCreateInfo, p_tessellation_state &C.VkPipelineTessellationStateCreateInfo, p_viewport_state &C.VkPipelineViewportStateCreateInfo, p_rasterization_state &C.VkPipelineRasterizationStateCreateInfo, p_multisample_state &C.VkPipelineMultisampleStateCreateInfo, p_depth_stencil_state &C.VkPipelineDepthStencilStateCreateInfo, p_color_blend_state &C.VkPipelineColorBlendStateCreateInfo, p_dynamic_state &C.VkPipelineDynamicStateCreateInfo, layout C.VkPipelineLayout, render_pass C.VkRenderPass, subpass u32, base_pipeline_handle C.VkPipeline, base_pipeline_index int) C.VkGraphicsPipelineCreateInfo {
	return C.VkGraphicsPipelineCreateInfo{
		sType: .vk_structure_type_graphics_pipeline_create_info
		pNext: p_next
		flags: flags
		stageCount: u32(stages.len)
		pStages: stages.data
		pVertexInputState: p_vertex_input_state
		pInputAssemblyState: p_input_assembly_state
		pTessellationState: p_tessellation_state
		pViewportState: p_viewport_state
		pRasterizationState: p_rasterization_state
		pMultisampleState: p_multisample_state
		pDepthStencilState: p_depth_stencil_state
		pColorBlendState: p_color_blend_state
		pDynamicState: p_dynamic_state
		layout: layout
		renderPass: render_pass
		subpass: subpass
		basePipelineHandle: base_pipeline_handle
		basePipelineIndex: base_pipeline_index
	}
}

pub fn create_vk_framebuffer_create_info(p_next voidptr, flags u32, render_pass C.VkRenderPass, attachments []C.VkImageView, width u32, height u32, layers u32) C.VkFramebufferCreateInfo {
	return C.VkFramebufferCreateInfo{
		sType: .vk_structure_type_framebuffer_create_info
		pNext: p_next
		flags: flags
		renderPass: render_pass
		attachmentCount: u32(attachments.len)
		pAttachments: attachments.data
		width: width
		height: height
		layers: layers
	}
}

pub fn create_vk_command_pool_create_info(p_next voidptr, flags u32, queue_family_idx u32) C.VkCommandPoolCreateInfo {
	return C.VkCommandPoolCreateInfo{
		sType: .vk_structure_type_command_pool_create_info
		pNext: p_next
		flags: flags
		queueFamilyIndex: queue_family_idx
	}
}

pub fn create_vk_command_buffer_allocate_info(p_next voidptr, command_pool C.VkCommandPool, level CommandBufferLevel, count u32) C.VkCommandBufferAllocateInfo {
	return C.VkCommandBufferAllocateInfo{
		sType: .vk_structure_type_command_buffer_allocate_info
		pNext: p_next
		commandPool: command_pool
		level: level
		commandBufferCount: count
	}
}

pub fn create_vk_command_buffer_begin_info(p_next voidptr, flags u32, inheritance_info &C.VkCommandBufferInheritanceInfo) C.VkCommandBufferBeginInfo {
	return C.VkCommandBufferBeginInfo{
		sType: .vk_structure_type_command_buffer_begin_info
		pNext: p_next
		flags: flags
		pInheritanceInfo: inheritance_info
	}
}

pub fn create_vk_render_pass_begin_info(p_next voidptr, render_pass C.VkRenderPass, framebuffer C.VkFramebuffer, render_area C.VkRect2D, clear_values []C.VkClearValue) C.VkRenderPassBeginInfo {
	return C.VkRenderPassBeginInfo{
		sType: .vk_structure_type_render_pass_begin_info
		pNext: p_next
		renderPass: render_pass
		framebuffer: framebuffer
		renderArea: render_area
		clearValueCount: u32(clear_values.len)
		pClearValues: clear_values.data
	}
}

pub fn create_vk_semaphore_create_info(p_next voidptr, flags u32) C.VkSemaphoreCreateInfo {
	return C.VkSemaphoreCreateInfo{
		sType: .vk_structure_type_semaphore_create_info
		pNext: p_next
		flags: flags
	}
}

pub fn create_vk_submit_info(p_next voidptr, wait_semaphores []C.VkSemaphore, p_wait_dst_stage_mask []PipelineStageFlagBits, command_buffers []C.VkCommandBuffer, signal_semaphores []C.VkSemaphore) C.VkSubmitInfo {
	return C.VkSubmitInfo{
		sType: .vk_structure_type_submit_info
		pNext: p_next
		waitSemaphoreCount: u32(wait_semaphores.len)
		pWaitSemaphores: wait_semaphores.data
		pWaitDstStageMask: p_wait_dst_stage_mask.data
		commandBufferCount: u32(command_buffers.len)
		pCommandBuffers: command_buffers.data
		signalSemaphoreCount: u32(signal_semaphores.len)
		pSignalSemaphores: signal_semaphores.data
	}
}

pub fn create_vk_present_info(p_next voidptr, wait_semaphores []C.VkSemaphore, swapchains []C.VkSwapchainKHR, image_indicies []u32, results []VkResult) C.VkPresentInfoKHR {
	return C.VkPresentInfoKHR{
		sType: .vk_structure_type_present_info_khr
		pNext: p_next
		waitSemaphoreCount: u32(wait_semaphores.len)
		pWaitSemaphores: wait_semaphores.data
		swapchainCount: u32(swapchains.len)
		pSwapchains: swapchains.data
		pImageIndices: image_indicies.data
		pResults: results.data
	}
}
