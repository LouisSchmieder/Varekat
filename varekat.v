module main

import glfw
import vulkan
import misc
import gg.m4
import time
import game as g
import mathf
import vk

pub type GameInitFn = fn (voidptr)

pub type GameLoopFn = fn (time.Duration, voidptr) ?

pub type GameKeyFn = fn (voidptr, misc.Key, misc.Action, int)

const (
	shader_path = './assets/shader/bin'
	nullptr     = voidptr(0)

	// Workaround
	a           = []UBO{}
)

struct Game {
mut:
	instance vk.Instance

	running        bool
	uniform_buffer vk.UniformBuffer

	window                       &C.GLFWwindow
	required_instance_extensions []string
	width                        u32
	height                       u32
	ubo                          UBO
	last                         time.Time
	user_ptr                     voidptr
	game_loop_fn                 GameLoopFn
	game_init_fn                 GameInitFn
	game_key_fn                  GameKeyFn

	camera g.Camera

	fov        f32
	near_plane f32
	far_plane  f32

	rotation f32

	world g.World
}

struct UBO {
mut:
	model_view m4.Mat4
	mvp        m4.Mat4
	normal     m4.Mat4
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
		camera: g.create_camera(mathf.vec3<f32>(0, 0, 0), mathf.vec3<f32>(0, 0, -1), mathf.vec3<f32>(0,
			1, 0), 1)
	}
	game.user_ptr = &game
	game.world = g.create_world(
		name: 'test'
		ambient_strenght: 0.1
		light_color: mathf.vec3<f32>(1, 1, 1)
	)

	game.game_init_fn(game.user_ptr)

	game.start_glfw()
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
	if width == 0 || height == 0 {
		return
	}
	mut game := &Game(glfw.get_user_ptr(window))
	game.width = u32(width)
	game.height = u32(height)
	game.instance.update_swapchain() or { panic(err) }
}

fn on_glfw_error(code int, msg charptr) {
	unsafe { eprintln('Glfw error $code: ${cstring_to_vstring(msg)}') }
}

fn (mut game Game) start_glfw() {
	glfw.glfw_init()
	glfw.window_hint(C.GLFW_CLIENT_API, C.GLFW_NO_API)
	game.window = glfw.create_window(int(game.width), int(game.height), 'Testing vulkan',
		nullptr)
	glfw.set_user_ptr(game.window, &game)
	glfw.set_window_resize_cb(game.window, on_window_resized)
	glfw.set_key_cb(game.window, on_key_input)
	glfw.set_error_cb(on_glfw_error)
	game.required_instance_extensions = glfw.get_required_instance_extensions()
}

fn (mut game Game) start_vulkan() ? {
	binding_desc := vulkan.get_binding_description(sizeof(misc.Vertex))
	attrs_descs := vulkan.get_attribute_descriptions(misc.vertex_offsets(), [u32(0), 0, 0],
		[u32(C.VK_FORMAT_R32G32B32_SFLOAT), u32(C.VK_FORMAT_R32G32B32_SFLOAT),
		u32(C.VK_FORMAT_R32G32B32_SFLOAT)])

	shaders := {
		'cube': [vk.create_shader('$shader_path/frag.spv', .fragment, 'main') ?,
			vk.create_shader('$shader_path/vert.spv', .vertex, 'main') ?]
	}

	game.instance = vk.create_instance(
		shaders: shaders
		name: 'Test Version'
		version: misc.make_version(0, 0, 1)
		validation: true
		enabled_layers: []
		enabled_extensions: game.required_instance_extensions
		window: game.window
		format_type: C.VK_FORMAT_B8G8R8A8_UNORM
		present_mode_type: u32(C.VK_PRESENT_MODE_FIFO_KHR)
		binding_desc: binding_desc
		attrs_descs: attrs_descs
		enabled_ph_device_features: C.VkPhysicalDeviceFeatures{
			fillModeNonSolid: vulkan.vk_true
		}
	)
	game.instance.setup() ?

	game.uniform_buffer = game.instance.create_uniform_buffer<UBO>(
		stage: .vk_shader_stage_vertex_bit
		descriptor_type: .vk_descriptor_type_uniform_buffer
	) ?

	swapchain_settings := vk.SwapchainSettings{
		width: &game.width
		height: &game.height
		image_usage: u32(C.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT)
		sharing_mode: u32(C.VK_SHARING_MODE_EXCLUSIVE)
		queue_family_indicies: []
		pre_transform: u32(C.VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR)
		composite_alpha: u32(C.VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR)
		clipped: vulkan.vk_true
		objects: game.world.meshes()
	}

	mut swapchain := vk.create_swapchain(swapchain_settings, game.instance.to_swapchain_info())

	pipeline_settings := vk.PipelineSettings{
		primitive: u32(C.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST)
		primitive_restart_enable: vulkan.vk_false
		width: &game.width
		height: &game.height
		rasterizer: vk.RasterizerStateSettings{
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
		blend: vk.ColorBlendSettings{
			blend_enable: vulkan.vk_true
			src_color_blend_factor: .vk_blend_factor_src_alpha
			dst_color_blend_factor: .vk_blend_factor_one_minus_src_alpha
			color_blend_op: .vk_blend_op_add
			src_alpha_blend_factor: .vk_blend_factor_one
			dst_alpha_blend_factor: .vk_blend_factor_zero
			alpha_blend_op: .vk_blend_op_add
			color_write_mask: vulkan.vk_color_component_all
		}
		subpass: vk.SubpassDepSettings{
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
		uniform_buffers: [&game.uniform_buffer]
	}

	swapchain.add_pipeline(vk.create_pipeline(pipeline_settings, game.instance.to_pipeline_info('cube')))
	game.instance.add_swapchain(swapchain)

	game.instance.update_swapchain() ?
}

fn (mut game Game) game_loop() ? {
	for !glfw.should_close(game.window) {
		glfw.poll_events()

		now := time.now()

		delta := now - game.last
		game.last = now

		game.game_loop_fn(delta, game.user_ptr) ?

		game.instance.draw_frame() ?
	}
	game.running = false
}

fn (mut game Game) shutdown_vulkan() {
}

fn (mut game Game) shutdown_glfw() {
	glfw.destroy_window(game.window)
	glfw.glfw_terminate()
}
