module vk

import vulkan
import graphics

pub struct SwapchainSettings {
	width                 &u32
	height                &u32
	image_usage           u32
	sharing_mode          u32
	queue_family_indicies []u32
	pre_transform         u32
	composite_alpha       u32
	clipped               C.VkBool32

	objects []&graphics.Mesh
mut:
	image_available C.VkSemaphore
	rendering_done  C.VkSemaphore
}

pub struct Swapchain {
	SwapchainSettings
	SwapchainInstanceInfo
mut:
	swapchain   C.VkSwapchainKHR
	image_views []C.VkImageView

	created bool

	raw_pipelines []Pipeline
}

pub fn create_swapchain(settings SwapchainSettings, instance_info SwapchainInstanceInfo) Swapchain {
	return Swapchain{
		SwapchainSettings: settings
		SwapchainInstanceInfo: instance_info
		swapchain: vulkan.null<C.VkSwapchainKHR>()
	}
}

pub fn (mut sw Swapchain) create() ? {
	if sw.created {
		vulkan.vk_device_wait_idle(sw.device)
		for i, _ in sw.raw_pipelines {
			sw.raw_pipelines[i].destroy()
			sw.raw_pipelines[i].free_buffer_pool()
		}

		for view in sw.image_views {
			vulkan.vk_destroy_image_view(sw.device, view, nullptr)
		}
		sw.image_views = []C.VkImageView{}
		sc := sw.swapchain
		defer {
			vulkan.vk_destroy_swapchain(sw.device, sc, nullptr)
		}
	}

	sw.setup() ?

	mut pipeline_infos := []C.VkGraphicsPipelineCreateInfo{len: sw.raw_pipelines.len}
	for i, _ in sw.raw_pipelines {
		pipeline_infos[i] = sw.raw_pipelines[i].create() ?
	}

	pipelines := vulkan.create_vk_graphics_pipelines(sw.device, vulkan.null<C.VkPipelineCache>(),
		pipeline_infos, nullptr) ?

	for i, pipeline in pipelines {
		sw.raw_pipelines[i].set_pipeline(pipeline)
		sw.raw_pipelines[i].set_mesh(sw.objects[i])
		sw.raw_pipelines[i].setup(sw.image_views) ?
	}

	if !sw.created {
		semaphore_create_info := vulkan.create_vk_semaphore_create_info(nullptr, 0)
		sw.image_available = vulkan.create_vk_semaphore(sw.device, &semaphore_create_info,
			nullptr) ?
		sw.rendering_done = vulkan.create_vk_semaphore(sw.device, &semaphore_create_info,
			nullptr) ?
		sw.created = true
	}
}

fn (mut sw Swapchain) setup() ? {
	swapchain_support := vulkan.vk_physical_device_surface_support(sw.ph_device, sw.settings.queue_family_idx,
		sw.surface) ?

	if !swapchain_support {
		return error('The device do not support Surfaces')
	}

	caps := vulkan.get_vk_physical_device_surface_capabilities(sw.ph_device, sw.surface) ?

	mut extent := C.VkExtent2D{
		width: *sw.width
		height: *sw.height
	}

	if caps.minImageExtent.width > extent.width {
		extent.width = caps.minImageExtent.width
	}
	if caps.maxImageExtent.width < extent.width {
		extent.width = caps.maxImageExtent.width
	}

	if caps.minImageExtent.height > extent.height {
		extent.height = caps.minImageExtent.height
	}
	if caps.maxImageExtent.height < extent.height {
		extent.height = caps.maxImageExtent.height
	}

	swapchain_create_info := vulkan.create_vk_swapchain_create_info(nullptr, 0, *sw.surface,
		*sw.min_image_count, *sw.format, extent, 1, sw.image_usage, sw.sharing_mode, sw.queue_family_indicies,
		sw.pre_transform, sw.composite_alpha, *sw.present_mode, sw.clipped, sw.swapchain)

	sw.swapchain = vulkan.create_vk_swapchain(sw.device, &swapchain_create_info, nullptr) ?

	swapchain_images := vulkan.get_vk_swapchain_image(sw.device, sw.swapchain) ?
	sw.image_views = []C.VkImageView{len: swapchain_images.len}

	for i, image in swapchain_images {
		image_view_create_info := vulkan.create_vk_image_view_create_info(nullptr, 0,
			image, u32(C.VK_IMAGE_VIEW_TYPE_2D), sw.format.format, vulkan.create_identity_mapping_component(),
			vulkan.create_vk_image_subresource_range(u32(C.VK_IMAGE_ASPECT_COLOR_BIT),
			0, 1, 0, 1))
		sw.image_views[i] = vulkan.create_vk_image_view(sw.device, image_view_create_info,
			nullptr) ?
	}
}

pub fn (mut sw Swapchain) add_pipeline(pipeline Pipeline) {
	sw.raw_pipelines << pipeline
}

pub fn (mut sw Swapchain) draw_frame() ? {
	img_idx := vulkan.acquire_vk_next_image(*sw.device, sw.swapchain, u64(-1), sw.image_available,
		vulkan.null<C.VkFence>()) ?

	mut command_buffers := []C.VkCommandBuffer{len: sw.raw_pipelines.len}

	for i, _ in sw.raw_pipelines {
		command_buffers[i] = sw.raw_pipelines[i].command_buffers[img_idx]
	}

	submit_info := vulkan.create_vk_submit_info(nullptr, [sw.image_available], [
		.vk_pipeline_stage_color_attachment_output_bit,
	], command_buffers, [sw.rendering_done])

	vulkan.vk_queue_submit(sw.queue, [submit_info], vulkan.null<C.VkFence>()) ?

	present_info := vulkan.create_vk_present_info(nullptr, [sw.rendering_done], [
		sw.swapchain,
	], [img_idx], [])

	vulkan.vk_queue_present(sw.queue, present_info) ?
}

pub fn (mut sw Swapchain) free() {
	for i, _ in sw.raw_pipelines {
		sw.raw_pipelines[i].free()
	}

	vulkan.vk_destroy_semaphore(sw.device, sw.image_available, nullptr)
	vulkan.vk_destroy_semaphore(sw.device, sw.rendering_done, nullptr)

	for i, _ in sw.raw_pipelines {
		sw.raw_pipelines[i].free_pipeline()
	}

	for view in sw.image_views {
		vulkan.vk_destroy_image_view(sw.device, view, nullptr)
	}

	for i, _ in sw.raw_pipelines {
		sw.raw_pipelines[i].free_shaders()
	}

	vulkan.vk_destroy_swapchain(sw.device, sw.swapchain, nullptr)
}
