module main

import glfw
import vulkan
import misc

struct Game {
mut:
	instance                     C.VkInstance
	device                       C.VkDevice
	surface                      C.VkSurfaceKHR
	window                       &C.GLFWwindow
	required_instance_extensions []string
}

fn main() {
	mut game := Game{
		window: 0
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
	game.window = glfw.create_window(400, 300, 'Testing vulkan', voidptr(0))
	game.required_instance_extensions = glfw.get_required_instance_extensions()
}

fn (mut game Game) start_vulkan() ? {
	app_info := vulkan.create_vk_application_info(voidptr(0), 'Vulkan Test', misc.make_version(0,
		0, 1), 'Test Engine', misc.make_version(0, 0, 1), misc.make_version(1, 0, 0))
	instance_create_info := vulkan.create_vk_instance_create_info(voidptr(0), 0, &app_info,
		[
		'VK_LAYER_KHRONOS_validation',
	], game.required_instance_extensions)
	game.instance = vulkan.create_vk_instance(instance_create_info) ?
	physical_devices := vulkan.get_vk_physical_devices(game.instance) ?
	for device in physical_devices {
		vulkan.print_stats(device)
	}
	device_queue_create_info := vulkan.create_vk_device_queue_create_info(voidptr(0),
		0, 1, 1, []f32{len: 1, init: 1.0})
	enabled_features := C.VkPhysicalDeviceFeatures{}
	device_create_info := vulkan.create_vk_device_create_info(voidptr(0), 0, [
		device_queue_create_info,
	], [], [], &enabled_features)
	game.device = vulkan.create_vk_device(physical_devices[0], device_create_info) ?
	queue := vulkan.get_vk_device_queue(game.device, 1, 0)
}

fn (mut game Game) game_loop() {
	for !glfw.should_close(game.window) {
		glfw.poll_events()
	}
}

fn (mut game Game) shutdown_vulkan() {
	vulkan.vk_device_wait_idle(game.device)
	vulkan.vk_destroy_device(game.device, voidptr(0))
	vulkan.vk_destroy_instance(game.instance, voidptr(0))
}

fn (mut game Game) shutdown_glfw() {
	glfw.destroy_window(game.window)
}
