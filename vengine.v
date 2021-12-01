module main

import glfw
import vulkan
import misc
import gg.m4
import time
import game as g
import mathf
import vulkan.simple

pub type GameInitFn = fn (voidptr)
pub type GameLoopFn = fn (time.Duration, voidptr) ?
pub type GameKeyFn  = fn (voidptr, misc.Key, misc.Action, int)

const (
	shader_path = './assets/shader/bin'
	nullptr     = voidptr(0)

	// Workaround
	a           = []UBO{}
)

struct Game {
mut:
	running                      bool
	instance                     C.VkInstance
	device                       C.VkDevice
	queue                        C.VkQueue
	surface                      C.VkSurfaceKHR
	swapchain                    C.VkSwapchainKHR
	pipeline_layout              C.VkPipelineLayout
	physical_device              C.VkPhysicalDevice
	render_pass                  C.VkRenderPass
	command_pool                 C.VkCommandPool
	image_available              C.VkSemaphore
	rendering_done               C.VkSemaphore
	command_buffers              []C.VkCommandBuffer
	pipelines                    []C.VkPipeline
	image_views                  []C.VkImageView
	framebuffers                 []C.VkFramebuffer
	binding_desc                 C.VkVertexInputBindingDescription
	attrs_descs                  []C.VkVertexInputAttributeDescription
	vertex_buffer                C.VkBuffer
	vertex_memory                C.VkDeviceMemory
	index_buffer                 C.VkBuffer
	index_memory                 C.VkDeviceMemory

	uniform_buffer               simple.UniformBuffer<UBO>

	window                       &C.GLFWwindow
	required_instance_extensions []string
	shaders                      map[string]C.VkShaderModule
	width                        u32
	height                       u32
	min_image_count              u32
	format                       C.VkSurfaceFormatKHR
	present_mode                 vulkan.VkPresentModeKHR
	settings                     vulkan.AnalysedGPUSettings
	fragment_shader_code         []byte
	vertex_shader_code           []byte
	ubo                          UBO
	last                         time.Time
	user_ptr                     voidptr
	game_loop_fn                 GameLoopFn
	game_init_fn                 GameInitFn
	game_key_fn                  GameKeyFn

	camera                       g.Camera

	fov                          f32
	aspec_ratio                  f32
	near_plane                   f32
	far_plane                    f32

	rotation                     f32

	world                        g.World
}

struct UBO {
mut:
	model m4.Mat4
	view m4.Mat4
	projection m4.Mat4
	light_direction mathf.Vec3<f32>
	light_color mathf.Vec4<f32>
}

fn main() {
	mut game := Game{
		window: 0
		width: 1280
		height: 720
		running: true
		last: time.now()
		game_loop_fn: loop_fn
		game_init_fn: init_fn
		game_key_fn: key_fn
		fov: 80.0
		near_plane: 0.01
		far_plane: 10.0
		camera: g.create_camera(mathf.vec3<f32>(0, 0, 0), mathf.vec3<f32>(0, 0, -1), mathf.vec3<f32>(0, 1, 0), 1)
	}
	game.user_ptr = &game
	game.world = g.create_world(name: 'test', ambient_strenght: 0.1, light_color: mathf.vec3<f32>(1, 1, 1))

	game.game_init_fn(game.user_ptr)

	game.start_glfw()
	game.binding_desc = vulkan.get_binding_description(sizeof(misc.Vertex))
	game.attrs_descs = vulkan.get_attribute_descriptions(misc.vertex_offsets(), [u32(0), 0, 0], [u32(C.VK_FORMAT_R32G32B32_SFLOAT), u32(C.VK_FORMAT_R32G32B32_SFLOAT), u32(C.VK_FORMAT_R32G32B32_SFLOAT)])
	game.start_vulkan() or { panic(err) }
	game.game_loop() or { panic(err) }
	game.shutdown_vulkan()
	game.shutdown_glfw()
}

fn on_key_input(window &C.GLFWwindow, key int, scancode int, action int, mods int) {
	mut game := &Game(glfw.get_user_ptr(window))
	game.game_key_fn(game.user_ptr, misc.Key(key), misc.Action(action), mods)
}

fn on_window_resized(window &C.GLFWwindow, width int, height int) {
	if width == 0 || height == 0 { return }
	mut game := &Game(glfw.get_user_ptr(window))
	game.width = u32(width)
	game.height = u32(height)
	game.create_swapchain(false) or {
		panic(err)
	}
}

fn (mut game Game) start_glfw() {
	glfw.glfw_init()
	glfw.window_hint(C.GLFW_CLIENT_API, C.GLFW_NO_API)
	game.window = glfw.create_window(int(game.width), int(game.height), 'Testing vulkan',
		nullptr)
	glfw.set_user_ptr(game.window, &game)
	glfw.set_window_resize_cb(game.window, on_window_resized)
	glfw.set_key_cb(game.window, on_key_input)
	game.required_instance_extensions = glfw.get_required_instance_extensions()
}

fn (mut game Game) start_vulkan() ? {
	// Get Shader code
	game.fragment_shader_code = misc.load_shader('$shader_path/frag.spv') ?
	game.vertex_shader_code = misc.load_shader('$shader_path/vert.spv') ?


	app_info := vulkan.create_vk_application_info(nullptr, 'Vulkan Test', misc.make_version(0,
		0, 1), 'Test Engine', misc.make_version(0, 0, 1), misc.make_version(1, 0, 0))
	instance_create_info := vulkan.create_vk_instance_create_info(nullptr, 0, &app_info,
		[
	//	'VK_LAYER_KHRONOS_validation',
	], game.required_instance_extensions)
	game.instance = vulkan.create_vk_instance(instance_create_info) ?

	game.surface = vulkan.create_vk_create_window_surface(game.instance, game.window,
		nullptr) ?

	physical_devices := vulkan.get_vk_physical_devices(game.instance) ?
	all_settings, idx := vulkan.analyse(physical_devices, [u32(C.VK_QUEUE_GRAPHICS_BIT)]) ?

	game.settings = all_settings[idx]
	game.physical_device = physical_devices[idx]

	game.uniform_buffer = simple.create_uniform_buffer<UBO>(&game.device, &game.physical_device, stage: .vk_shader_stage_vertex_bit, descriptor_type: .vk_descriptor_type_uniform_buffer) ?

	device_queue_create_info := vulkan.create_vk_device_queue_create_info(nullptr, 0,
		game.settings.queue_family_idx, 1, []f32{len: 1, init: 1.0})
	enabled_features := C.VkPhysicalDeviceFeatures{}
	device_create_info := vulkan.create_vk_device_create_info(nullptr, 0, [
		device_queue_create_info,
	], [], [
		unsafe { cstring_to_vstring(charptr(C.VK_KHR_SWAPCHAIN_EXTENSION_NAME)) },
	], &enabled_features)
	game.device = vulkan.create_vk_device(game.physical_device, device_create_info) ?
	game.queue = vulkan.get_vk_device_queue(game.device, game.settings.queue_family_idx, 0)

	capibilities := vulkan.get_vk_physical_device_surface_capabilities(game.physical_device,
		game.surface) ?
	formats := vulkan.get_vk_physical_device_surface_formats(game.physical_device, game.surface) ?
	presents := vulkan.get_vk_physical_device_surface_present_modes(game.physical_device, game.surface) ?

	game.min_image_count = u32(3)
	if capibilities.minImageCount > game.min_image_count {
		game.min_image_count = capibilities.minImageCount
	} else if capibilities.maxImageCount < game.min_image_count && capibilities.maxImageCount != 0 {
		game.min_image_count = capibilities.maxImageCount
	}

	res := formats.filter(it.format == C.VK_FORMAT_B8G8R8A8_UNORM)
	game.format = res[0]
	if res.len == 0 {
		game.format = formats[0]
	}

	game.present_mode = vulkan.VkPresentModeKHR(u32(C.VK_PRESENT_MODE_FIFO_KHR))

	if game.present_mode !in presents {
		game.present_mode = presents[0]
	}

	game.create_swapchain(true) ?
}

fn (mut game Game) create_swapchain(new bool) ? {
	if !new {
		vulkan.vk_device_wait_idle(game.device)
		vulkan.vk_destroy_command_pool(game.device, game.command_pool, nullptr)
		for framebuffer in game.framebuffers {
			vulkan.vk_destroy_framebuffer(game.device, framebuffer, nullptr)
		}
		game.framebuffers = []C.VkFramebuffer{}
		for pipeline in game.pipelines {
			vulkan.vk_destroy_graphics_pipeline(game.device, pipeline, nullptr)
		}
		game.pipelines = []C.VkPipeline{}
		vulkan.vk_destroy_render_pass(game.device, game.render_pass, nullptr)
		vulkan.vk_destroy_pipeline_layout(game.device, game.pipeline_layout, nullptr)
		for view in game.image_views {
			vulkan.vk_destroy_image_view(game.device, view, nullptr)
		}
		game.image_views = []C.VkImageView{}
		for _, shader in game.shaders {
			vulkan.vk_destroy_shader_module(game.device, shader, nullptr)
		}
		game.shaders = map[string]C.VkShaderModule{}
		sc := game.swapchain
		defer {
			vulkan.vk_destroy_swapchain(game.device, sc, nullptr)
		}
		game.uniform_buffer.free_pool()
	} 
	
	game.setup_swapchain(new) ?

	if new {
		game.uniform_buffer.create_descriptor_set_layout() ?
	}

	game.setup_pipeline() ?

	for view in game.image_views {
		framebuffer_info := vulkan.create_vk_framebuffer_create_info(nullptr, 0, game.render_pass, [view], game.width, game.height, 1)
		game.framebuffers << vulkan.create_vk_framebuffer(game.device, &framebuffer_info, nullptr) ?
	}
	command_pool_create_info := vulkan.create_vk_command_pool_create_info(nullptr, 0, game.settings.queue_family_idx)
	game.command_pool = vulkan.create_vk_command_pool(game.device, &command_pool_create_info, nullptr) ?

	command_buffer_allocate_info := vulkan.create_vk_command_buffer_allocate_info(nullptr, game.command_pool, .vk_command_buffer_level_primary, u32(game.image_views.len))
	game.command_buffers = vulkan.allocate_vk_command_buffers(game.device, &command_buffer_allocate_info) ?

	command_buffer_begin_info := vulkan.create_vk_command_buffer_begin_info(nullptr, u32(C.VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT), nullptr)

	// Buffer
	game.vertex_buffer, game.vertex_memory = game.create_buffer(game.world.get_world_verticies(), .vk_buffer_usage_vertex_buffer_bit) ?
	game.index_buffer, game.index_memory = game.create_buffer(game.world.get_world_indicies(), .vk_buffer_usage_index_buffer_bit) ?
	game.uniform_buffer.create_buffer() ?
	game.uniform_buffer.create_descriptor_pool() ?
	game.uniform_buffer.create_descriptor_set() ?

	for i, buffer in game.command_buffers {
		vulkan.vk_begin_command_buffer(buffer, &command_buffer_begin_info) ?

		render_area := vulkan.create_vk_rect_2d(0, 0, game.width, game.height)

		render_pass_begin_info := vulkan.create_vk_render_pass_begin_info(nullptr, game.render_pass, game.framebuffers[i], render_area, [vulkan.create_vk_clear_value(0.0, 0.0, 0.0, 1.0)])

		vulkan.vk_cmd_begin_render_pass(buffer, &render_pass_begin_info, u32(C.VK_SUBPASS_CONTENTS_INLINE))

		vulkan.vk_cmd_bind_pipeline(buffer, .vk_pipeline_bind_point_graphics, game.pipelines[0])

		viewport := vulkan.create_vk_viewport(0, 0, game.width, game.height, 0, 1)

		vulkan.vk_cmd_set_viewport(buffer, 0, [viewport])

		vulkan.vk_cmd_bind_vertex_buffers(buffer, 0, [game.vertex_buffer], [u32(0)])

		vulkan.vk_cmd_bind_index_buffer(buffer, game.index_buffer, 0, u32(C.VK_INDEX_TYPE_UINT32))

		mut idx_offset := 0

		for mesh in game.world.meshes {
			_, idx := mesh.mesh_data()

			vulkan.vk_cmd_bind_descriptor_sets(buffer, .vk_pipeline_bind_point_graphics, game.pipeline_layout, 0, [game.uniform_buffer.set()], [])

			vulkan.vk_cmd_draw_indexed(buffer, u32(idx.len), 1, 0, idx_offset, 0)
		
			idx_offset += idx.len
		}

		vulkan.vk_cmd_end_render_pass(buffer)
		vulkan.vk_end_command_buffer(buffer) ?
	}

	if new {
		semaphore_create_info := vulkan.create_vk_semaphore_create_info(nullptr, 0)
		game.image_available = vulkan.create_vk_semaphore(game.device, &semaphore_create_info, nullptr) ?
		game.rendering_done = vulkan.create_vk_semaphore(game.device, &semaphore_create_info, nullptr) ?
	}

}

fn (mut game Game) create_buffer<T>(data []T, usage vulkan.BufferUsageFlagBits) ?(C.VkBuffer, C.VkDeviceMemory) {
	buffer_size := sizeof(T) * u32(data.len)
	staging_buffer, staging_memory := vulkan.create_buffer(game.device, game.physical_device, buffer_size,
		[.vk_buffer_usage_transfer_src_bit], u32(C.VK_SHARING_MODE_EXCLUSIVE), [], [.vk_memory_property_host_visible_bit, .vk_memory_property_host_coherent_bit]) ?

	ptr := vulkan.vk_map_memory(game.device, staging_memory, 0, buffer_size, 0) ?
	unsafe { vmemcpy(ptr, data.data, int(buffer_size)) }
	vulkan.vk_unmap_memory(game.device, staging_memory)

	buffer, memory := vulkan.create_buffer(game.device, game.physical_device, buffer_size,
		[usage, .vk_buffer_usage_transfer_dst_bit], u32(C.VK_SHARING_MODE_EXCLUSIVE), [], [.vk_memory_property_device_local_bit]) ?

	vulkan.copy_buffer(staging_buffer, buffer, buffer_size, game.command_pool, game.device, game.queue) ?

	vulkan.vk_destroy_buffer(game.device, staging_buffer, nullptr)
	vulkan.vk_free_memory(game.device, staging_memory, nullptr)

	return buffer, memory
}

fn (mut game Game) setup_swapchain(new bool) ? {
	swapchain_support := vulkan.vk_physical_device_surface_support(game.physical_device, 1,
		game.surface) ?

	if !swapchain_support {
		return error('The device do not support Surfaces')
	}

	old_swapchain := if new { vulkan.null<C.VkSwapchainKHR>() } else { game.swapchain }

	swapchain_create_info := vulkan.create_vk_swapchain_create_info(nullptr, 0, game.surface,
		game.min_image_count, game.format, C.VkExtent2D{
			width: game.width
			height: game.height
		}, 1, u32(C.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT),
		u32(C.VK_SHARING_MODE_EXCLUSIVE), [], u32(C.VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR),
		u32(C.VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR), game.present_mode, vulkan.vk_true, old_swapchain)
	game.swapchain = vulkan.create_vk_swapchain(game.device, &swapchain_create_info, nullptr) ?

	swapchain_images := vulkan.get_vk_swapchain_image(game.device, game.swapchain) ?

	game.image_views = []C.VkImageView{len: swapchain_images.len}

	for i, image in swapchain_images {
		image_view_create_info := vulkan.create_vk_image_view_create_info(nullptr, 0,
			image, u32(C.VK_IMAGE_VIEW_TYPE_2D), game.format.format, vulkan.create_identity_mapping_component(),
			vulkan.create_vk_image_subresource_range(u32(C.VK_IMAGE_ASPECT_COLOR_BIT),
			0, 1, 0, 1))
		game.image_views[i] = vulkan.create_vk_image_view(game.device, image_view_create_info,
			nullptr) ?
	}
}

fn (mut game Game) setup_pipeline() ? {

	fragment_shader_module, fragment_pipeline_create_info := vulkan.create_shader(nullptr,
		0, game.fragment_shader_code, game.device, .fragment, 'main') ?
	vertex_shader_module, vertex_pipeline_create_info := vulkan.create_shader(nullptr,
		0, game.vertex_shader_code, game.device, .vertex, 'main') ?

	game.shaders['fragment'] = fragment_shader_module
	game.shaders['vertex'] = vertex_shader_module

	mut stage_infos := [fragment_pipeline_create_info, vertex_pipeline_create_info]



	vertex_input_create_info := vulkan.create_vk_pipeline_vertex_input_state_create_info(nullptr,
		0, [game.binding_desc], game.attrs_descs)
	input_assembly_create_info := vulkan.create_vk_pipeline_input_assembly_state_create_info(nullptr,
		0, u32(C.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST), vulkan.vk_false)

	viewport := vulkan.create_vk_viewport(0.0, 0.0, game.width, game.height, 0.0, 1.0)
	scissor := vulkan.create_vk_rect_2d(0, 0, game.width, game.height)

	pipeline_viewport_state_info := vulkan.create_vk_pipeline_viewport_state_create_info(nullptr,
		0, [viewport], [scissor])
	pipeline_rasterization_state_info := vulkan.create_vk_pipeline_rasterization_state_create_info(nullptr,
		0, vulkan.vk_false, vulkan.vk_false, u32(C.VK_POLYGON_MODE_LINE), u32(C.VK_CULL_MODE_BACK_BIT),
		u32(C.VK_FRONT_FACE_CLOCKWISE), vulkan.vk_false, 0, 0, 0, 1)
	pipeline_multisample_state_info := vulkan.create_vk_pipeline_multisample_state_create_info(nullptr,
		0, u32(C.VK_SAMPLE_COUNT_1_BIT), vulkan.vk_false, 1.0, nullptr, vulkan.vk_false,
		vulkan.vk_false)
	pipeline_color_blend_attachment_state := vulkan.create_vk_pipeline_color_blend_attachment_state(vulkan.vk_true,
		.vk_blend_factor_src_alpha, .vk_blend_factor_one_minus_src_alpha, .vk_blend_op_add,
		.vk_blend_factor_one, .vk_blend_factor_zero, .vk_blend_op_add, vulkan.vk_color_component_all)

	blend := [4]f32{init: 0.0}
	pipeline_blend_create_info := vulkan.create_vk_pipeline_color_blend_state_create_info(nullptr,
		0, vulkan.vk_false, .vk_logic_op_no_op, [
		pipeline_color_blend_attachment_state,
	], blend)

	dynamic_states := [vulkan.DynamicState.vk_dynamic_state_viewport]

	dynamic_state_create_info := vulkan.create_vk_pipeline_dynamic_state_create_info(nullptr, 0, dynamic_states)

	pipeline_layout_create_info := vulkan.create_vk_pipeline_layout_create_info(nullptr,
		0, [game.uniform_buffer.layout()], [])

	game.pipeline_layout = vulkan.create_vk_pipeline_layout(game.device, pipeline_layout_create_info,
		nullptr) ?

	attachment_description := vulkan.create_vk_attachment_description(0, game.format.format,
		u32(C.VK_SAMPLE_COUNT_1_BIT), .vk_attachment_load_op_clear, .vk_attachment_store_op_store,
		.vk_attachment_load_op_dont_care, .vk_attachment_store_op_dont_care, .vk_image_layout_undefined,
		.vk_image_layout_present_src_khr)

	attachment_ref := vulkan.create_vk_attachment_reference(0, .vk_image_layout_color_attachment_optimal)

	subpass_description := vulkan.create_vk_subpass_description(0, .vk_pipeline_bind_point_graphics,
		[], [attachment_ref], [], [], [])

	subpass_dependency := vulkan.create_vk_subpass_dependency(u32(C.VK_SUBPASS_EXTERNAL), 0,
		.vk_pipeline_stage_color_attachment_output_bit, .vk_pipeline_stage_color_attachment_output_bit,
		0, u32(C.VK_ACCESS_COLOR_ATTACHMENT_READ_BIT | C.VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT), 0)

	render_pass_create_info := vulkan.create_vk_render_pass_create_info(nullptr, 0, [
		attachment_description,
	], [subpass_description], [subpass_dependency])

	game.render_pass = vulkan.create_vk_render_pass(game.device, &render_pass_create_info,
		nullptr) ?

	graphics_pipeline_create_info := vulkan.create_vk_graphics_pipeline_create_info(nullptr,
		0, stage_infos, &vertex_input_create_info, &input_assembly_create_info, nullptr,
		&pipeline_viewport_state_info, &pipeline_rasterization_state_info, &pipeline_multisample_state_info,
		nullptr, &pipeline_blend_create_info, &dynamic_state_create_info, game.pipeline_layout, game.render_pass,
		0, vulkan.null<C.VkPipeline>(), -1)

	game.pipelines = vulkan.create_vk_graphics_pipelines(game.device, vulkan.null<C.VkPipelineCache>(),
		[graphics_pipeline_create_info], nullptr) ?

}

fn (mut game Game) game_loop() ? {
	for !glfw.should_close(game.window) {
		glfw.poll_events()

		now := time.now()

		delta := now - game.last
		game.last = now

		game.game_loop_fn(delta, game.user_ptr) ?

		game.draw_frame() ?
	}
	game.running = false
}

fn (mut game Game) draw_frame() ? {
	img_idx := vulkan.acquire_vk_next_image(game.device, game.swapchain, u64(-1), game.image_available, vulkan.null<C.VkFence>()) ?
	submit_info := vulkan.create_vk_submit_info(nullptr, [game.image_available], [.vk_pipeline_stage_color_attachment_output_bit], [game.command_buffers[img_idx]], [game.rendering_done])

	vulkan.vk_queue_submit(game.queue, [submit_info], vulkan.null<C.VkFence>()) ?

	present_info := vulkan.create_vk_present_info(nullptr, [game.rendering_done], [game.swapchain], [img_idx], [])

	vulkan.vk_queue_present(game.queue, present_info) ?
}

fn (mut game Game) shutdown_vulkan() {
	vulkan.vk_device_wait_idle(game.device)
	game.uniform_buffer.free()
	vulkan.vk_free_memory(game.device, game.index_memory, nullptr)
	vulkan.vk_destroy_buffer(game.device, game.index_buffer, nullptr)
	vulkan.vk_free_memory(game.device, game.vertex_memory, nullptr)
	vulkan.vk_destroy_buffer(game.device, game.vertex_buffer, nullptr)
	vulkan.vk_destroy_semaphore(game.device, game.image_available, nullptr)
	vulkan.vk_destroy_semaphore(game.device, game.rendering_done, nullptr)
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
	glfw.glfw_terminate()
}
