module main

import glfw
import vulkan
import misc

const (
	shader_path = './assets/shader/bin'
	nullptr     = voidptr(0)
)

struct Game {
mut:
	instance                     C.VkInstance
	device                       C.VkDevice
	surface                      C.VkSurfaceKHR
	swapchain                    C.VkSwapchainKHR
	pipeline_layout              C.VkPipelineLayout
	render_pass                  C.VkRenderPass
	command_pool                 C.VkCommandPool
	command_buffers              []C.VkCommandBuffer
	pipelines                    []C.VkPipeline
	image_views                  []C.VkImageView
	framebuffers                 []C.VkFramebuffer
	window                       &C.GLFWwindow
	required_instance_extensions []string
	shaders                      map[string]C.VkShaderModule
	width                        u32
	height                       u32
}

fn main() {
	mut game := Game{
		window: 0
		width: 400
		height: 300
	}
	game.start_glfw()
	game.start_vulkan() or { panic(err) }
	game.game_loop()
	game.shutdown_vulkan()
	game.shutdown_glfw()
}

fn (mut game Game) start_glfw() {
	glfw.glfw_init()
	glfw.window_hint(C.GLFW_CLIENT_API, C.GLFW_NO_API)
	glfw.window_hint(C.GLFW_RESIZABLE, C.GLFW_FALSE)
	game.window = glfw.create_window(int(game.width), int(game.height), 'Testing vulkan',
		nullptr)
	game.required_instance_extensions = glfw.get_required_instance_extensions()
}

fn (mut game Game) start_vulkan() ? {
	app_info := vulkan.create_vk_application_info(nullptr, 'Vulkan Test', misc.make_version(0,
		0, 1), 'Test Engine', misc.make_version(0, 0, 1), misc.make_version(1, 0, 0))
	instance_create_info := vulkan.create_vk_instance_create_info(nullptr, 0, &app_info,
		[
		'VK_LAYER_KHRONOS_validation',
	], game.required_instance_extensions)
	game.instance = vulkan.create_vk_instance(instance_create_info) ?

	game.surface = vulkan.create_vk_create_window_surface(game.instance, game.window,
		nullptr) ?

	physical_devices := vulkan.get_vk_physical_devices(game.instance) ?
	all_settings, idx := vulkan.analyse(physical_devices, [u32(C.VK_QUEUE_GRAPHICS_BIT)]) ?

	settings := all_settings[idx]
	physical_device := physical_devices[idx]

	device_queue_create_info := vulkan.create_vk_device_queue_create_info(nullptr, 0,
		settings.queue_family_idx, 1, []f32{len: 1, init: 1.0})
	enabled_features := C.VkPhysicalDeviceFeatures{}
	device_create_info := vulkan.create_vk_device_create_info(nullptr, 0, [
		device_queue_create_info,
	], [], [
		string(charptr(C.VK_KHR_SWAPCHAIN_EXTENSION_NAME)),
	], &enabled_features)
	game.device = vulkan.create_vk_device(physical_device, device_create_info) ?
	queue := vulkan.get_vk_device_queue(game.device, settings.queue_family_idx, 0)

	capibilities := vulkan.get_vk_physical_device_surface_capabilities(physical_device,
		game.surface) ?
	formats := vulkan.get_vk_physical_device_surface_formats(physical_device, game.surface) ?
	presents := vulkan.get_vk_physical_device_surface_present_modes(physical_device, game.surface) ?

	mut min_image_count := u32(3)
	if capibilities.minImageCount > min_image_count {
		min_image_count = capibilities.minImageCount
	} else if capibilities.maxImageCount < min_image_count && capibilities.maxImageCount != 0 {
		min_image_count = capibilities.maxImageCount
	}

	res := formats.filter(it.format == C.VK_FORMAT_B8G8R8A8_UNORM)
	mut format := res[0]
	if res.len == 0 {
		format = formats[0]
	}

	image_extent := capibilities.currentExtent
	mut present_mode := vulkan.VkPresentModeKHR(u32(C.VK_PRESENT_MODE_FIFO_KHR))

	if present_mode !in presents {
		present_mode = presents[0]
	}

	game.setup_swapchain(format, min_image_count, image_extent, present_mode, physical_device) ?
	game.setup_pipeline(format) ?

	for view in game.image_views {
		framebuffer_info := vulkan.create_vk_framebuffer_create_info(nullptr, 0, game.render_pass, [view], game.width, game.height, 1)
		game.framebuffers << vulkan.create_vk_framebuffer(game.device, &framebuffer_info, nullptr) ?
	}
	command_pool_create_info := vulkan.create_vk_command_pool_create_info(nullptr, 0, settings.queue_family_idx)
	game.command_pool = vulkan.create_vk_command_pool(game.device, &command_pool_create_info, nullptr) ?

	command_buffer_allocate_info := vulkan.create_vk_command_buffer_allocate_info(nullptr, game.command_pool, .vk_command_buffer_level_primary, u32(game.image_views.len))
	game.command_buffers = vulkan.allocate_vk_command_buffers(game.device, &command_buffer_allocate_info) ?

	command_buffer_begin_info := vulkan.create_vk_command_buffer_begin_info(nullptr, u32(C.VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT), nullptr)

	for i, buffer in game.command_buffers {
		vulkan.vk_begin_command_buffer(buffer, &command_buffer_begin_info) ?

		render_area := vulkan.create_vk_rect_2d(0, 0, game.width, game.height)

		render_pass_begin_info := vulkan.create_vk_render_pass_begin_info(nullptr, game.render_pass, game.framebuffers[i], render_area, [vulkan.create_vk_clear_value(0.0, 0.0, 0.0, 1.0)])

		vulkan.vk_cmd_begin_render_pass(buffer, &render_pass_begin_info, u32(C.VK_SUBPASS_CONTENTS_INLINE))

		vulkan.vk_cmd_bind_pipeline(buffer, .vk_pipeline_bind_point_graphics, game.pipelines[0])

		vulkan.vk_cmd_end_render_pass(buffer)
		vulkan.vk_end_command_buffer(buffer) ?
	}
}

fn (mut game Game) setup_swapchain(format C.VkSurfaceFormatKHR, min_image_count u32, image_extent C.VkExtent2D, present_mode vulkan.VkPresentModeKHR, physical_device C.VkPhysicalDevice) ? {
	swapchain_support := vulkan.vk_physical_device_surface_support(physical_device, 1,
		game.surface) ?

	if !swapchain_support {
		panic('The device do not support Surfaces')
	}

	swapchain_create_info := vulkan.create_vk_swapchain_create_info(nullptr, 0, game.surface,
		min_image_count, format, image_extent, 1, u32(C.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT),
		u32(C.VK_SHARING_MODE_EXCLUSIVE), [], u32(C.VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR),
		u32(C.VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR), present_mode, vulkan.vk_true, vulkan.null<C.VkSwapchainKHR>())
	game.swapchain = vulkan.create_vk_swapchain(game.device, &swapchain_create_info, nullptr) ?

	swapchain_images := vulkan.get_vk_swapchain_image(game.device, game.swapchain) ?

	game.image_views = []C.VkImageView{len: swapchain_images.len}

	for i, image in swapchain_images {
		image_view_create_info := vulkan.create_vk_image_view_create_info(nullptr, 0,
			image, u32(C.VK_IMAGE_VIEW_TYPE_2D), format.format, vulkan.create_identity_mapping_component(),
			vulkan.create_vk_image_subresource_range(u32(C.VK_IMAGE_ASPECT_COLOR_BIT),
			0, 1, 0, 1))
		game.image_views[i] = vulkan.create_vk_image_view(game.device, image_view_create_info,
			nullptr) ?
	}
}

fn (mut game Game) setup_pipeline(format C.VkSurfaceFormatKHR) ? {
	fragment_shader_code := misc.load_shader('$shader_path/frag.spv') ?
	vertex_shader_code := misc.load_shader('$shader_path/vert.spv') ?

	fragment_shader_module, fragment_pipeline_create_info := vulkan.create_shader(nullptr,
		0, fragment_shader_code, game.device, .fragment, 'main') ?
	vertex_shader_module, vertex_pipeline_create_info := vulkan.create_shader(nullptr,
		0, vertex_shader_code, game.device, .vertex, 'main') ?

	game.shaders['fragment'] = fragment_shader_module
	game.shaders['vertex'] = vertex_shader_module

	mut stage_infos := [fragment_pipeline_create_info, vertex_pipeline_create_info]

	vertex_input_create_info := vulkan.create_vk_pipeline_vertex_input_state_create_info(nullptr,
		0, [], [])
	input_assembly_create_info := vulkan.create_vk_pipeline_input_assembly_state_create_info(nullptr,
		0, u32(C.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST), vulkan.vk_false)

	viewport := vulkan.create_vk_viewport(0.0, 0.0, game.width, game.height, 0.0, 1.0)
	scissor := vulkan.create_vk_rect_2d(0, 0, game.width, game.height)

	pipeline_viewport_state_info := vulkan.create_vk_pipeline_viewport_state_create_info(nullptr,
		0, [viewport], [scissor])
	pipeline_rasterization_state_info := vulkan.create_vk_pipeline_rasterization_state_create_info(nullptr,
		0, vulkan.vk_false, vulkan.vk_false, u32(C.VK_POLYGON_MODE_FILL), u32(C.VK_CULL_MODE_BACK_BIT),
		u32(C.VK_FRONT_FACE_CLOCKWISE), vulkan.vk_false, 0, 0, 0, 1)
	pipeline_multisample_state_info := vulkan.create_vk_pipeline_multisample_state_create_info(nullptr,
		0, u32(C.VK_SAMPLE_COUNT_1_BIT), vulkan.vk_false, 1.0, nullptr, vulkan.vk_false,
		vulkan.vk_false)
	pipeline_color_blend_attachment_state := vulkan.create_vk_pipeline_color_blend_attachment_state(vulkan.vk_true,
		.vk_blend_factor_src_alpha, .vk_blend_factor_one_minus_src_alpha, .vk_blend_op_add,
		.vk_blend_factor_one, .vk_blend_factor_zero, .vk_blend_op_add, vulkan.vk_color_component_all)
	pipeline_blend_create_info := vulkan.create_vk_pipeline_color_blend_state_create_info(nullptr,
		0, vulkan.vk_false, .vk_logic_op_no_op, [
		pipeline_color_blend_attachment_state,
	], []f32{len: 4, init: 0.0})
	pipeline_layout_create_info := vulkan.create_vk_pipeline_layout_create_info(nullptr,
		0, [], [])

	game.pipeline_layout = vulkan.create_vk_pipeline_layout(game.device, pipeline_layout_create_info,
		nullptr) ?

	attachment_description := vulkan.create_vk_attachment_description(0, format.format,
		u32(C.VK_SAMPLE_COUNT_1_BIT), .vk_attachment_load_op_clear, .vk_attachment_store_op_store,
		.vk_attachment_load_op_dont_care, .vk_attachment_store_op_dont_care, .vk_image_layout_undefined,
		.vk_image_layout_present_src_khr)

	attachment_ref := vulkan.create_vk_attachment_reference(0, .vk_image_layout_color_attachment_optimal)

	subpass_description := vulkan.create_vk_subpass_description(0, .vk_pipeline_bind_point_graphics,
		[], [attachment_ref], [], [], [])

	render_pass_create_info := vulkan.create_vk_render_pass_create_info(nullptr, 0, [
		attachment_description,
	], [subpass_description], [])

	game.render_pass = vulkan.create_vk_render_pass(game.device, &render_pass_create_info,
		nullptr) ?

	graphics_pipeline_create_info := vulkan.create_vk_graphics_pipeline_create_info(nullptr,
		0, stage_infos, &vertex_input_create_info, &input_assembly_create_info, nullptr,
		&pipeline_viewport_state_info, &pipeline_rasterization_state_info, &pipeline_multisample_state_info,
		nullptr, &pipeline_blend_create_info, nullptr, game.pipeline_layout, game.render_pass,
		0, vulkan.null<C.VkPipeline>(), -1)

	game.pipelines = vulkan.create_vk_graphics_pipelines(game.device, vulkan.null<C.VkPipelineCache>(),
		[graphics_pipeline_create_info], nullptr) ?
}

fn (mut game Game) game_loop() {
	for !glfw.should_close(game.window) {
		glfw.poll_events()
	}
}

fn (mut game Game) shutdown_vulkan() {
	vulkan.vk_device_wait_idle(game.device)
	vulkan.vk_destroy_command_pool(game.device, game.command_pool, nullptr)
	for framebuffer in game.framebuffers {
		vulkan.vk_destroy_framebuffer(game.device, framebuffer, nullptr)
	}
	for pipeline in game.pipelines {
		vulkan.vk_destroy_graphics_pipeline(game.device, pipeline, nullptr)
	}
	vulkan.vk_destroy_render_pass(game.device, game.render_pass, nullptr)
	vulkan.vk_destroy_pipeline_layout(game.device, game.pipeline_layout, nullptr)
	for view in game.image_views {
		vulkan.vk_destroy_image_view(game.device, view, nullptr)
	}
	for _, shader in game.shaders {
		vulkan.vk_destroy_shader_module(game.device, shader, nullptr)
	}
	vulkan.vk_destroy_swapchain(game.device, game.swapchain, nullptr)
	vulkan.vk_destroy_device(game.device, nullptr)
	vulkan.vk_destroy_surface(game.instance, game.surface, nullptr)
	vulkan.vk_destroy_instance(game.instance, nullptr)
}

fn (mut game Game) shutdown_glfw() {
	glfw.destroy_window(game.window)
}
