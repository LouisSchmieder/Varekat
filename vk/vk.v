module vk

import vulkan
import misc

const (
	nullptr         = voidptr(0)
	engine_name     = 'Varekat'
	engine_version  = misc.make_version(0, 0, 1)
	min_api_version = misc.make_version(1, 0, 0)
)

pub struct InstanceSettings {
	shaders                    map[string][]Shader
	name                       string
	version                    misc.Version
	validation                 bool
	enabled_layers             []string
	enabled_extensions         []string
	enabled_ph_device_features C.VkPhysicalDeviceFeatures
	window                     &C.GLFWwindow
	format_type                int
	present_mode_type          u32
	binding_desc               C.VkVertexInputBindingDescription
	attrs_descs                []C.VkVertexInputAttributeDescription
mut:
	min_image_count u32
}

pub struct Instance {
	InstanceSettings
mut:
	// Vulkan things
	instance  C.VkInstance
	surface   C.VkSurfaceKHR
	device    C.VkDevice
	ph_device C.VkPhysicalDevice
	queue     C.VkQueue

	swapchain Swapchain
	// Display
	format       C.VkSurfaceFormatKHR
	present_mode vulkan.VkPresentModeKHR
	// Other
	settings vulkan.AnalysedGPUSettings
}

pub struct SwapchainInstanceInfo {
	ph_device       &C.VkPhysicalDevice
	device          &C.VkDevice
	surface         &C.VkSurfaceKHR
	min_image_count &u32
	format          &C.VkSurfaceFormatKHR
	settings        vulkan.AnalysedGPUSettings
	present_mode    &vulkan.VkPresentModeKHR
	queue           &C.VkQueue
}

pub struct PipelineInstanceInfo {
	shaders      []Shader
	device       &C.VkDevice
	binding_desc C.VkVertexInputBindingDescription
	attrs_descs  []C.VkVertexInputAttributeDescription
	format       &C.VkSurfaceFormatKHR
	settings     vulkan.AnalysedGPUSettings
	ph_device    &C.VkPhysicalDevice
	queue        &C.VkQueue
}

pub fn create_instance(settings InstanceSettings) Instance {
	return Instance{
		InstanceSettings: settings
	}
}

pub fn (mut instance Instance) setup() ? {
	mut layers := instance.enabled_layers
	if instance.validation {
		layers << 'VK_LAYER_KHRONOS_validation'
	}

	app_info := vulkan.create_vk_application_info(vk.nullptr, instance.name, instance.version,
		vk.engine_name, vk.engine_version, vk.min_api_version)
	instance_create_info := vulkan.create_vk_instance_create_info(vk.nullptr, 0, &app_info,
		layers, instance.enabled_extensions)

	instance.instance = vulkan.create_vk_instance(&instance_create_info) ?
	instance.surface = vulkan.create_vk_create_window_surface(instance.instance, instance.window,
		vk.nullptr) ?

	instance.setup_device() ?

	caps := vulkan.get_vk_physical_device_surface_capabilities(instance.ph_device, instance.surface) ?
	formats := vulkan.get_vk_physical_device_surface_formats(instance.ph_device, instance.surface) ?
	presents := vulkan.get_vk_physical_device_surface_present_modes(instance.ph_device,
		instance.surface) ?

	if caps.minImageCount > instance.min_image_count {
		instance.min_image_count = caps.minImageCount
	} else if caps.maxImageCount < instance.min_image_count && caps.maxImageCount != 0 {
		instance.min_image_count = caps.maxImageCount
	}

	res := formats.filter(it.format == instance.format_type)
	instance.format = res[0]
	if res.len == 0 {
		instance.format = formats[0]
	}

	instance.present_mode = vulkan.VkPresentModeKHR(instance.present_mode_type)
	if instance.present_mode !in presents {
		instance.present_mode = presents[0]
	}
}

fn (mut instance Instance) setup_device() ? {
	physical_devices := vulkan.get_vk_physical_devices(instance.instance) ?
	settings, idx := vulkan.analyse(physical_devices, [u32(C.VK_QUEUE_GRAPHICS_BIT)]) ?

	instance.settings = settings[idx]
	instance.ph_device = physical_devices[idx]

	device_queue_create_info := vulkan.create_vk_device_queue_create_info(vk.nullptr,
		0, instance.settings.queue_family_idx, 1, []f32{len: 1, init: 1.0})
	device_create_info := vulkan.create_vk_device_create_info(vk.nullptr, 0, [
		device_queue_create_info,
	], [], [unsafe { cstring_to_vstring(charptr(C.VK_KHR_SWAPCHAIN_EXTENSION_NAME)) }],
		&instance.enabled_ph_device_features)

	instance.device = vulkan.create_vk_device(instance.ph_device, device_create_info) ?
	instance.queue = vulkan.get_vk_device_queue(instance.device, instance.settings.queue_family_idx,
		0)
}

pub fn (mut instance Instance) to_swapchain_info() SwapchainInstanceInfo {
	return SwapchainInstanceInfo{
		ph_device: &instance.ph_device
		surface: &instance.surface
		device: &instance.device
		min_image_count: &instance.min_image_count
		format: &instance.format
		present_mode: &instance.present_mode
		queue: &instance.queue
		settings: instance.settings
	}
}

pub fn (mut instance Instance) to_pipeline_info(shader_group string) PipelineInstanceInfo {
	return PipelineInstanceInfo{
		shaders: instance.shaders[shader_group]
		device: &instance.device
		binding_desc: instance.binding_desc
		attrs_descs: instance.attrs_descs
		format: &instance.format
		settings: instance.settings
		ph_device: &instance.ph_device
		queue: &instance.queue
	}
}

pub fn (mut instance Instance) draw_frame() ? {
	instance.swapchain.draw_frame() ?
}

pub fn (mut instance Instance) update_swapchain() ? {
	instance.swapchain.create() ?
}

pub fn (mut instance Instance) add_swapchain(swapchain Swapchain) {
	instance.swapchain = swapchain
}

pub fn (mut instance Instance) free() {
	instance.swapchain.free()

	vulkan.vk_destroy_device(instance.device, vk.nullptr)
	vulkan.vk_destroy_surface(instance.instance, instance.surface, vk.nullptr)
	vulkan.vk_destroy_instance(instance.instance, vk.nullptr)
}
