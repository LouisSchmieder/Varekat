module vk

import vulkan

pub fn default_pipeline_settings(width &u32, height &u32, buffer ...&UniformBuffer) PipelineSettings {
	return PipelineSettings{
		primitive: u32(C.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST)
		primitive_restart_enable: vulkan.vk_false
		width: unsafe { width }
		height: unsafe { height }
		rasterizer: RasterizerStateSettings{
			depth_clamp_enabled: vulkan.vk_false
			rasterizer_discard_enable: vulkan.vk_false
			line_width: 1
			fill_mode: u32(C.VK_POLYGON_MODE_LINE)
			cull_mode: u32(C.VK_CULL_MODE_BACK_BIT)
			front_face: u32(C.VK_FRONT_FACE_CLOCKWISE)
			depth_bias_enable: vulkan.vk_false
			depth_bias_constant_factor: 0
			depth_bias_clamp: 0
			depth_bias_slope_factor: 0
		}
		blend: ColorBlendSettings{
			blend_enable: vulkan.vk_true
			src_color_blend_factor: .vk_blend_factor_src_alpha
			dst_color_blend_factor: .vk_blend_factor_one_minus_src_alpha
			color_blend_op: .vk_blend_op_add
			src_alpha_blend_factor: .vk_blend_factor_one
			dst_alpha_blend_factor: .vk_blend_factor_zero
			alpha_blend_op: .vk_blend_op_add
			color_write_mask: vulkan.vk_color_component_all
		}
		subpass: SubpassDepSettings{
			src_subpass: u32(C.VK_SUBPASS_EXTERNAL)
			dst_subpass: 0
			src_stage_mask: .vk_pipeline_stage_color_attachment_output_bit
			dst_stage_mask: .vk_pipeline_stage_color_attachment_output_bit
			src_access_mask: 0
			dst_access_mask: u32(C.VK_ACCESS_COLOR_ATTACHMENT_READ_BIT | C.VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT)
			dependency_flags: 0
		}
		sample_count: u32(C.VK_SAMPLE_COUNT_1_BIT)
		logic_op_enable: vulkan.vk_false
		logic_op: .vk_logic_op_no_op
		bind_point: .vk_pipeline_bind_point_graphics
		uniform_buffers: buffer
	}
}
