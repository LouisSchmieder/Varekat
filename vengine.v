module main

import glfw
import vulkan
import misc

struct Game {
mut:
	instance                     C.VkInstance
	device                       C.VkDevice
	surface                      C.VkSurfaceKHR
	swapchain                    C.VkSwapchainKHR
	window                       &C.GLFWwindow
	image_views                  []C.VkImageView
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

	game.surface = vulkan.create_vk_create_window_surface(game.instance, game.window,
		voidptr(0)) ?

	physical_devices := vulkan.get_vk_physical_devices(game.instance) ?
	all_settings, idx := vulkan.analyse(physical_devices)

	settings := all_settings[idx]
	physical_device := physical_devices[idx]

	device_queue_create_info := vulkan.create_vk_device_queue_create_info(voidptr(0),
		0, settings.queue_family_idx, 1, []f32{len: 1, init: 1.0})
	enabled_features := C.VkPhysicalDeviceFeatures{}
	device_create_info := vulkan.create_vk_device_create_info(voidptr(0), 0, [
		device_queue_create_info,
	], [], [
		string(charptr(C.VK_KHR_SWAPCHAIN_EXTENSION_NAME)),
	], &enabled_features)
	game.device = vulkan.create_vk_device(physical_device, device_create_info) ?
	queue := vulkan.get_vk_device_queue(game.device, settings.queue_family_idx, 0)

	capibilities := vulkan.get_vk_physical_device_surface_capabilities(physical_device,
		game.surface) ?
	formats := vulkan.get_vk_physical_device_surface_formats(physical_device, game.surface) ?
	presents := vulkan.get_vk_physical_device_surface_present_modes(physical_device,
		game.surface) ?

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

	swapchain_support := vulkan.vk_physical_device_surface_support(physical_device,
		1, game.surface) ?

	if !swapchain_support {
		panic('The device do not support Surfaces')
	}

	swapchain_create_info := vulkan.create_vk_swapchain_create_info(voidptr(0), 0, game.surface,
		min_image_count, format, image_extent, 1, u32(C.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT),
		u32(C.VK_SHARING_MODE_EXCLUSIVE), [], u32(C.VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR),
		u32(C.VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR), present_mode, vulkan.vk_true, vulkan.null<C.VkSwapchainKHR>())
	game.swapchain = vulkan.create_vk_swapchain(game.device, &swapchain_create_info, voidptr(0)) ?

	swapchain_images := vulkan.get_vk_swapchain_image(game.device, game.swapchain) ?

	game.image_views = []C.VkImageView{len: swapchain_images.len}

	for i, image in swapchain_images {
		image_view_create_info := vulkan.create_vk_image_view_create_info(voidptr(0),
			0, image, u32(C.VK_IMAGE_VIEW_TYPE_2D), format.format, vulkan.create_identity_mapping_component(),
			vulkan.create_vk_image_subresource_range(u32(C.VK_IMAGE_ASPECT_COLOR_BIT),
			0, 1, 0, 1))
		game.image_views[i] = vulkan.create_vk_image_view(game.device, image_view_create_info,
			voidptr(0)) ?
	}
}

fn (mut game Game) game_loop() {
	for !glfw.should_close(game.window) {
		glfw.poll_events()
	}
}

fn (mut game Game) shutdown_vulkan() {
	vulkan.vk_device_wait_idle(game.device)
	for view in game.image_views {
		vulkan.vk_destroy_image_view(game.device, view, voidptr(0))
	}
	vulkan.vk_destroy_swapchain(game.device, game.swapchain, voidptr(0))
	vulkan.vk_destroy_device(game.device, voidptr(0))
	vulkan.vk_destroy_surface(game.instance, game.surface, voidptr(0))
	vulkan.vk_destroy_instance(game.instance, voidptr(0))
}

fn (mut game Game) shutdown_glfw() {
	glfw.destroy_window(game.window)
}
