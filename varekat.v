module main

import glfw
import vulkan
import misc
import time
import game as g
import mathf
import vk

pub type GameInitFn = fn (voidptr)

pub type GameLoopFn = fn (time.Duration, voidptr) ?

pub type GameKeyFn = fn (voidptr, misc.Key, misc.Action, int)

pub type GameMouseFn = fn (voidptr)

const (
	shader_path = './assets/shader/bin'
	nullptr     = voidptr(0)
)

struct Game {
mut:
	instance vk.Instance

	running bool

	window                       &C.GLFWwindow
	required_instance_extensions []string
	width                        u32
	height                       u32
	last                         time.Time
	user_ptr                     voidptr
	game_loop_fn                 GameLoopFn
	game_init_fn                 GameInitFn
	game_key_fn                  GameKeyFn
	game_mouse_fn                GameMouseFn

	camera g.Camera

	fov        f32
	near_plane f32
	far_plane  f32

	rotation f32

	world g.World

	keyboard misc.Keyboard
	mouse    misc.Mouse
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
		game_mouse_fn: mouse_fn
		//	game_key_fn: key_fn
		fov: 80.0
		near_plane: 0.01
		far_plane: 100.0
		camera: g.create_camera(mathf.vec3<f32>(0, 0, -3), mathf.vec3<f32>(0, 0, 1), mathf.vec3<f32>(0,
			1, 0), 2, 0, 90)
		keyboard: misc.create_keyboard()
		mouse: misc.create_mouse()
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
	game.keyboard.update(misc.Key(key), misc.Action(action), mods)
	// game.game_key_fn(game.user_ptr, misc.Key(key), misc.Action(action), mods)
}

fn on_mouse_input(window &C.GLFWwindow, x f64, y f64) {
	mut game := &Game(glfw.get_user_ptr(window))
	game.mouse.update(f32(x), f32(y))
	game.game_mouse_fn(game.user_ptr)
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
	glfw.hide_mouse(game.window)
	glfw.set_user_ptr(game.window, &game)
	glfw.set_mouse_cb(game.window, on_mouse_input)
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

	swapchain_settings := vk.SwapchainSettings{
		width: &game.width
		height: &game.height
		image_usage: u32(C.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT)
		sharing_mode: u32(C.VK_SHARING_MODE_EXCLUSIVE)
		queue_family_indicies: []
		pre_transform: u32(C.VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR)
		composite_alpha: u32(C.VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR)
		clipped: vulkan.vk_true
		objects: game.world.to_vk_meshes()
	}

	mut swapchain := vk.create_swapchain(swapchain_settings, game.instance.to_swapchain_info())

	eprint('Camera ')
	game.camera.create_ub(game.instance) ?

	for i, obj in game.world.objects {
		game.world.objects[i].create_ub(game.instance) ?
		swapchain.add_pipeline(vk.create_pipeline(vk.default_pipeline_settings(&game.width,
			&game.height, obj.ub, game.camera.buffer), game.instance.to_pipeline_info('cube')))
	}

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
	game.instance.free()
}

fn (mut game Game) shutdown_glfw() {
	glfw.destroy_window(game.window)
	glfw.glfw_terminate()
}
