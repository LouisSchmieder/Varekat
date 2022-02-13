module vk

import vulkan

pub struct PipelineSettings {
	primitive                u32
	primitive_restart_enable C.VkBool32
	width                    &u32
	height                   &u32

	rasterizer RasterizerStateSettings
	blend      ColorBlendSettings
	subpass    SubpassDepSettings

	sample_count u32

	logic_op_enable C.VkBool32
	logic_op        vulkan.LogicOp

	bind_point vulkan.PipelineBindPoint
mut:
	uniform_buffers []&UniformBuffer
}

pub struct RasterizerStateSettings {
pub:
	depth_clamp_enabled        C.VkBool32
	rasterizer_discard_enable  C.VkBool32
	line_width                 f32
	fill_mode                  u32
	cull_mode                  u32
	front_face                 u32
	depth_bias_enable          C.VkBool32
	depth_bias_constant_factor f32
	depth_bias_clamp           f32
	depth_bias_slope_factor    f32
}

pub struct ColorBlendSettings {
pub:
	blend_enable           C.VkBool32
	src_color_blend_factor vulkan.BlendFactor
	dst_color_blend_factor vulkan.BlendFactor
	color_blend_op         vulkan.BlendOp
	src_alpha_blend_factor vulkan.BlendFactor
	dst_alpha_blend_factor vulkan.BlendFactor
	alpha_blend_op         vulkan.BlendOp
	color_write_mask       u32
}

pub struct SubpassDepSettings {
pub:
	src_subpass      u32
	dst_subpass      u32
	src_stage_mask   vulkan.PipelineStageFlagBits
	dst_stage_mask   vulkan.PipelineStageFlagBits
	src_access_mask  u32
	dst_access_mask  u32
	dependency_flags u32
}

pub struct Pipeline {
	PipelineSettings
	PipelineInstanceInfo
mut:
	shader_modules  []C.VkShaderModule
	pipeline_layout C.VkPipelineLayout
	render_pass     C.VkRenderPass
	pipeline        C.VkPipeline

	framebuffers []C.VkFramebuffer
	command_pool C.VkCommandPool

	mesh Mesh

	vertex_buffer C.VkBuffer
	vertex_memory C.VkDeviceMemory
	index_buffer  C.VkBuffer
	index_memory  C.VkDeviceMemory
pub mut:
	command_buffers []C.VkCommandBuffer
}

pub fn create_pipeline(settings PipelineSettings, instance_info PipelineInstanceInfo) Pipeline {
	return Pipeline{
		mesh: Mesh{}
		PipelineInstanceInfo: instance_info
		PipelineSettings: settings
	}
}

pub fn (mut p Pipeline) create() ?C.VkGraphicsPipelineCreateInfo {
	// Uniform buffers
	for i, _ in p.uniform_buffers {
		p.uniform_buffers[i].create_descriptor_set_layout() ?
	}

	mut stage_infos := []C.VkPipelineShaderStageCreateInfo{len: p.shaders.len}

	for i, shader in p.shaders {
		sh_module, sh_pipeline_create_info := vulkan.create_shader(nullptr, 0, shader.code,
			p.device, shader.typ, shader.entry_point) ?
		stage_infos[i] = sh_pipeline_create_info
		p.shader_modules << sh_module
	}

	vertex_input_create_info := vulkan.create_vk_pipeline_vertex_input_state_create_info(nullptr,
		0, [p.binding_desc], p.attrs_descs)
	input_assembly_creat_info := vulkan.create_vk_pipeline_input_assembly_state_create_info(nullptr,
		0, p.primitive, p.primitive_restart_enable)

	viewport := vulkan.create_vk_viewport(0.0, 0.0, *p.width, *p.height, 0.0, 1.0)
	scissor := vulkan.create_vk_rect_2d(0, 0, p.width, p.height)

	pipeline_viewport_state_info := vulkan.create_vk_pipeline_viewport_state_create_info(nullptr,
		0, [viewport], [scissor])
	pipeline_rasterization_state_info := vulkan.create_vk_pipeline_rasterization_state_create_info(nullptr,
		0, p.rasterizer.depth_clamp_enabled, p.rasterizer.rasterizer_discard_enable, p.rasterizer.fill_mode,
		p.rasterizer.cull_mode, p.rasterizer.front_face, p.rasterizer.depth_bias_enable,
		p.rasterizer.depth_bias_constant_factor, p.rasterizer.depth_bias_clamp, p.rasterizer.depth_bias_slope_factor,
		p.rasterizer.line_width)
	pipeline_multisample_state_info := vulkan.create_vk_pipeline_multisample_state_create_info(nullptr,
		0, p.sample_count, vulkan.vk_false, 1.0, nullptr, vulkan.vk_false, vulkan.vk_false)
	pipeline_color_blend_attachment_state := vulkan.create_vk_pipeline_color_blend_attachment_state(p.blend.blend_enable,
		p.blend.src_color_blend_factor, p.blend.dst_color_blend_factor, p.blend.color_blend_op,
		p.blend.src_alpha_blend_factor, p.blend.dst_alpha_blend_factor, p.blend.alpha_blend_op,
		p.blend.color_write_mask)

	blend := [4]f32{init: 0.0}
	pipeline_blend_create_info := vulkan.create_vk_pipeline_color_blend_state_create_info(nullptr,
		0, p.logic_op_enable, p.logic_op, [pipeline_color_blend_attachment_state], blend)

	dynamic_states := [vulkan.DynamicState.vk_dynamic_state_viewport]
	dynamic_state_create_info := vulkan.create_vk_pipeline_dynamic_state_create_info(nullptr,
		0, dynamic_states)

	mut set_layouts := []C.VkDescriptorSetLayout{}
	for i, _ in p.uniform_buffers {
		set_layouts << p.uniform_buffers[i].layout()
	}

	pipeline_layout_create_info := vulkan.create_vk_pipeline_layout_create_info(nullptr,
		0, set_layouts, [])
	p.pipeline_layout = vulkan.create_vk_pipeline_layout(p.device, pipeline_layout_create_info,
		nullptr) ?

	attachment_description := vulkan.create_vk_attachment_description(0, p.format.format,
		u32(C.VK_SAMPLE_COUNT_1_BIT), .vk_attachment_load_op_clear, .vk_attachment_store_op_store,
		.vk_attachment_load_op_dont_care, .vk_attachment_store_op_dont_care, .vk_image_layout_undefined,
		.vk_image_layout_present_src_khr)

	attachment_ref := vulkan.create_vk_attachment_reference(0, .vk_image_layout_color_attachment_optimal)

	subpass_desc := vulkan.create_vk_subpass_description(0, p.bind_point, [], [
		attachment_ref,
	], [], [], [])

	subpass_dep := vulkan.create_vk_subpass_dependency(p.subpass.src_subpass, p.subpass.dst_subpass,
		p.subpass.src_stage_mask, p.subpass.dst_stage_mask, p.subpass.src_access_mask,
		p.subpass.dst_access_mask, p.subpass.dependency_flags)

	render_pass_create_info := vulkan.create_vk_render_pass_create_info(nullptr, 0, [
		attachment_description,
	], [subpass_desc], [subpass_dep])

	p.render_pass = vulkan.create_vk_render_pass(p.device, &render_pass_create_info, nullptr) ?

	return vulkan.create_vk_graphics_pipeline_create_info(nullptr, 0, stage_infos, &vertex_input_create_info,
		&input_assembly_creat_info, nullptr, &pipeline_viewport_state_info, &pipeline_rasterization_state_info,
		&pipeline_multisample_state_info, nullptr, &pipeline_blend_create_info, &dynamic_state_create_info,
		p.pipeline_layout, p.render_pass, 0, vulkan.null<C.VkPipeline>(), -1)
}

pub fn (mut p Pipeline) set_pipeline(pipeline C.VkPipeline) {
	p.pipeline = pipeline
}

pub fn (mut p Pipeline) set_mesh(mesh Mesh) {
	p.mesh = mesh
}

pub fn (mut p Pipeline) setup(image_views []C.VkImageView) ? {
	p.setup_image_views(image_views) ?
	p.setup_command_pool(u32(image_views.len)) ?
}

fn (mut p Pipeline) setup_command_pool(len u32) ? {
	command_pool_create_info := vulkan.create_vk_command_pool_create_info(nullptr, 0,
		p.settings.queue_family_idx)
	p.command_pool = vulkan.create_vk_command_pool(p.device, &command_pool_create_info,
		nullptr) ?

	command_buffer_allocate_info := vulkan.create_vk_command_buffer_allocate_info(nullptr,
		p.command_pool, .vk_command_buffer_level_primary, len)
	p.command_buffers = vulkan.allocate_vk_command_buffers(p.device, &command_buffer_allocate_info) ?

	command_buffer_begin_info := vulkan.create_vk_command_buffer_begin_info(nullptr, u32(C.VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT),
		nullptr)

	p.vertex_buffer, p.vertex_memory = p.create_buffer(p.mesh.verticies, .vk_buffer_usage_vertex_buffer_bit) ?
	p.index_buffer, p.index_memory = p.create_buffer(p.mesh.indicies, .vk_buffer_usage_index_buffer_bit) ?

	for i, _ in p.uniform_buffers {
		p.uniform_buffers[i].create_buffer() ?
		p.uniform_buffers[i].create_descriptor_pool() ?
		p.uniform_buffers[i].create_descriptor_set() ?
	}

	// Uniform buffers

	for i, buffer in p.command_buffers {
		vulkan.vk_begin_command_buffer(buffer, &command_buffer_begin_info) ?

		render_area := vulkan.create_vk_rect_2d(0, 0, p.width, p.height)

		render_pass_begin_info := vulkan.create_vk_render_pass_begin_info(nullptr, p.render_pass,
			p.framebuffers[i], render_area, [
			vulkan.create_vk_clear_value(0.0, 0.0, 0.0, 1.0),
		])

		vulkan.vk_cmd_begin_render_pass(buffer, &render_pass_begin_info, u32(C.VK_SUBPASS_CONTENTS_INLINE))

		vulkan.vk_cmd_bind_pipeline(buffer, .vk_pipeline_bind_point_graphics, p.pipeline)

		viewport := vulkan.create_vk_viewport(0, 0, *p.width, *p.height, 0, 1)

		vulkan.vk_cmd_set_viewport(buffer, 0, [viewport])

		vulkan.vk_cmd_bind_vertex_buffers(buffer, 0, [p.vertex_buffer], [u32(0)])

		vulkan.vk_cmd_bind_index_buffer(buffer, p.index_buffer, 0, u32(C.VK_INDEX_TYPE_UINT32))

		mut sets := []C.VkDescriptorSet{}

		for x, _ in p.uniform_buffers {
			sets << p.uniform_buffers[x].set()
		}

		vulkan.vk_cmd_bind_descriptor_sets(buffer, .vk_pipeline_bind_point_graphics, p.pipeline_layout,
			0, sets, [])

		vulkan.vk_cmd_draw_indexed(buffer, u32(p.mesh.indicies.len), 1, 0, 0, 0)

		vulkan.vk_cmd_end_render_pass(buffer)
		vulkan.vk_end_command_buffer(buffer) ?
	}
}

fn (mut p Pipeline) setup_image_views(image_views []C.VkImageView) ? {
	for view in image_views {
		framebuffer_info := vulkan.create_vk_framebuffer_create_info(nullptr, 0, p.render_pass,
			[view], p.width, p.height, 1)
		p.framebuffers << vulkan.create_vk_framebuffer(p.device, &framebuffer_info, nullptr) ?
	}
}

fn (mut p Pipeline) create_buffer<T>(data []T, usage vulkan.BufferUsageFlagBits) ?(C.VkBuffer, C.VkDeviceMemory) {
	buffer_size := sizeof(T) * u32(data.len)
	staging_buffer, staging_memory := vulkan.create_buffer(p.device, p.ph_device, buffer_size,
		[.vk_buffer_usage_transfer_src_bit], u32(C.VK_SHARING_MODE_EXCLUSIVE), [], [
		.vk_memory_property_host_visible_bit,
		.vk_memory_property_host_coherent_bit,
	]) ?

	ptr := vulkan.vk_map_memory(p.device, staging_memory, 0, buffer_size, 0) ?
	unsafe { vmemcpy(ptr, data.data, int(buffer_size)) }
	vulkan.vk_unmap_memory(p.device, staging_memory)

	buffer, memory := vulkan.create_buffer(p.device, p.ph_device, buffer_size, [usage,
		.vk_buffer_usage_transfer_dst_bit], u32(C.VK_SHARING_MODE_EXCLUSIVE), [], [
		.vk_memory_property_device_local_bit,
	]) ?

	vulkan.copy_buffer(staging_buffer, buffer, buffer_size, p.command_pool, p.device,
		p.queue) ?

	vulkan.vk_destroy_buffer(p.device, staging_buffer, nullptr)
	vulkan.vk_free_memory(p.device, staging_memory, nullptr)

	return buffer, memory
}

pub fn (mut p Pipeline) destroy() {
	vulkan.vk_destroy_command_pool(p.device, p.command_pool, nullptr)
	for framebuffer in p.framebuffers {
		vulkan.vk_destroy_framebuffer(p.device, framebuffer, nullptr)
	}
	p.framebuffers = []C.VkFramebuffer{}
	vulkan.vk_destroy_graphics_pipeline(p.device, p.pipeline, nullptr)
	vulkan.vk_destroy_render_pass(p.device, p.render_pass, nullptr)
	vulkan.vk_destroy_pipeline_layout(p.device, p.pipeline_layout, nullptr)

	for m in p.shader_modules {
		vulkan.vk_destroy_shader_module(p.device, m, nullptr)
	}

	p.shader_modules = []C.VkShaderModule{}
}

pub fn (mut p Pipeline) free_buffer_pool() {
	for i, _ in p.uniform_buffers {
		p.uniform_buffers[i].free_pool()
	}
}

pub fn (mut p Pipeline) free() {
	for i, _ in p.uniform_buffers {
		p.uniform_buffers[i].free()
		vulkan.vk_free_memory(p.device, p.index_memory, nullptr)
		vulkan.vk_destroy_buffer(p.device, p.index_buffer, nullptr)
		vulkan.vk_free_memory(p.device, p.vertex_memory, nullptr)
		vulkan.vk_destroy_buffer(p.device, p.vertex_buffer, nullptr)
	}
}

pub fn (mut p Pipeline) free_pipeline() {
	vulkan.vk_destroy_command_pool(p.device, p.command_pool, nullptr)
	for framebuffer in p.framebuffers {
		vulkan.vk_destroy_framebuffer(p.device, framebuffer, nullptr)
	}
	p.framebuffers = []C.VkFramebuffer{}
	vulkan.vk_destroy_graphics_pipeline(p.device, p.pipeline, nullptr)
	vulkan.vk_destroy_render_pass(p.device, p.render_pass, nullptr)
	vulkan.vk_destroy_pipeline_layout(p.device, p.pipeline_layout, nullptr)
}

pub fn (mut p Pipeline) free_shaders() {
	for m in p.shader_modules {
		vulkan.vk_destroy_shader_module(p.device, m, nullptr)
	}
}