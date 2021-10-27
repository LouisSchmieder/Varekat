module vulkan

import strings

fn C.vkCreateInstance(&C.VkInstanceCreateInfo, voidptr, &C.VkInstance) VkResult
fn C.vkEnumeratePhysicalDevices(C.VkInstance, &u32, &C.VkPhysicalDevice) VkResult
fn C.vkCreateDevice(C.VkPhysicalDevice, &C.VkDeviceCreateInfo, voidptr, &C.VkDevice) VkResult
fn C.vkEnumerateInstanceLayerProperties(&u32, &C.VkLayerProperties) VkResult
fn C.vkEnumerateInstanceExtensionProperties(charptr, &u32, &C.VkExtensionProperties) VkResult
fn C.vkCreateSwapchainKHR(C.VkDevice, &C.VkSwapchainCreateInfoKHR, voidptr, &C.VkSwapchainKHR) VkResult
fn C.vkCreateImageView(C.VkDevice, &C.VkImageViewCreateInfo, voidptr, &C.VkImageView) VkResult
fn C.vkCreateShaderModule(C.VkDevice, &C.VkShaderModuleCreateInfo, voidptr, &C.VkShaderModule) VkResult
fn C.vkCreatePipelineLayout(C.VkDevice, &C.VkPipelineLayoutCreateInfo, voidptr, &C.VkPipelineLayout) VkResult
fn C.vkCreateRenderPass(C.VkDevice, &C.VkRenderPassCreateInfo, voidptr, &C.VkRenderPass) VkResult
fn C.vkCreateGraphicsPipelines(C.VkDevice, C.VkPipelineCache, u32, &C.VkGraphicsPipelineCreateInfo, voidptr, &C.VkPipeline) VkResult
fn C.vkCreateFramebuffer(C.VkDevice, &C.VkFramebufferCreateInfo, voidptr, &C.VkFramebuffer) VkResult
fn C.glfwCreateWindowSurface(C.VkInstance, &C.GLFWwindow, voidptr, &C.VkSurfaceKHR) VkResult

fn C.vkGetPhysicalDeviceProperties(C.VkPhysicalDevice, &C.VkPhysicalDeviceProperties)
fn C.vkGetPhysicalDeviceFeatures(C.VkPhysicalDevice, &C.VkPhysicalDeviceFeatures)
fn C.vkGetPhysicalDeviceMemoryProperties(C.VkPhysicalDevice, &C.VkPhysicalDeviceMemoryProperties)
fn C.vkGetPhysicalDeviceQueueFamilyProperties(C.VkPhysicalDevice, &u32, &C.VkQueueFamilyProperties)
fn C.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(C.VkPhysicalDevice, C.VkSurfaceKHR, &C.VkSurfaceCapabilitiesKHR) VkResult
fn C.vkGetPhysicalDeviceSurfaceFormatsKHR(C.VkPhysicalDevice, C.VkSurfaceKHR, &u32, &C.VkSurfaceFormatKHR) VkResult
fn C.vkGetPhysicalDeviceSurfacePresentModesKHR(C.VkPhysicalDevice, C.VkSurfaceKHR, &u32, &VkPresentModeKHR) VkResult
fn C.vkGetSwapchainImagesKHR(C.VkDevice, C.VkSwapchainKHR, &u32, &C.VkImage) VkResult
fn C.vkGetDeviceQueue(C.VkDevice, u32, u32, &C.VkQueue)

fn C.vkGetPhysicalDeviceSurfaceSupportKHR(C.VkPhysicalDevice, u32, C.VkSurfaceKHR, &C.VkBool32) VkResult

fn C.vkDeviceWaitIdle(C.VkDevice)
fn C.vkDestroyInstance(C.VkInstance, voidptr)
fn C.vkDestroyDevice(C.VkDevice, voidptr)
fn C.vkDestroyImageView(C.VkDevice, C.VkImageView, voidptr)
fn C.vkDestroyShaderModule(C.VkDevice, C.VkShaderModule, voidptr)
fn C.vkDestroySwapchainKHR(C.VkDevice, C.VkSwapchainKHR, voidptr)
fn C.vkDestroyRenderPass(C.VkDevice, C.VkRenderPass, voidptr)
fn C.vkDestroyPipeline(C.VkDevice, C.VkPipeline, voidptr)
fn C.vkDestroyFramebuffer(C.VkDevice, C.VkFramebuffer, voidptr)
fn C.vkDestroyPipelineLayout(C.VkDevice, C.VkPipelineLayout, voidptr)
fn C.vkDestroySurfaceKHR(C.VkInstance, C.VkSurfaceKHR, voidptr)

fn handle_error(res VkResult) ? {
	if res != 0 {
		return error('Something went wrong with Vulkan. ($res)')
	}
}

pub fn vk_physical_device_surface_support(device C.VkPhysicalDevice, queue_family_idx u32, surface C.VkSurfaceKHR) ?bool {
	support := unsafe { &C.VkBool32(malloc(int(sizeof(C.VkBool32)))) }
	res := C.vkGetPhysicalDeviceSurfaceSupportKHR(device, queue_family_idx, surface, support)
	handle_error(res) ?
	return support == vk_true
}

pub fn vk_device_wait_idle(device C.VkDevice) {
	C.vkDeviceWaitIdle(device)
}

pub fn vk_destroy_image_view(device C.VkDevice, image_view C.VkImageView, alloc voidptr) {
	C.vkDestroyImageView(device, image_view, alloc)
}

pub fn vk_destroy_instance(instance C.VkInstance, allocator voidptr) {
	C.vkDestroyInstance(instance, allocator)
}

pub fn vk_destroy_surface(instance C.VkInstance, surface C.VkSurfaceKHR, allocator voidptr) {
	C.vkDestroySurfaceKHR(instance, surface, allocator)
}

pub fn vk_destroy_swapchain(device C.VkDevice, swapchain C.VkSwapchainKHR, allocator voidptr) {
	C.vkDestroySwapchainKHR(device, swapchain, allocator)
}

pub fn vk_destroy_pipeline_layout(device C.VkDevice, pipeline_layout C.VkPipelineLayout, allocator voidptr) {
	C.vkDestroyPipelineLayout(device, pipeline_layout, allocator)
}

pub fn vk_destroy_render_pass(device C.VkDevice, render_pass C.VkRenderPass, allocator voidptr) {
	C.vkDestroyRenderPass(device, render_pass, allocator)
}

pub fn vk_destroy_framebuffer(device C.VkDevice, framebuffer C.VkFramebuffer, allocator voidptr) {
	C.vkDestroyFramebuffer(device, framebuffer, allocator)
}

pub fn vk_destroy_graphics_pipeline(device C.VkDevice, pipeline C.VkPipeline, allocator voidptr) {
	C.vkDestroyPipeline(device, pipeline, allocator)
}

pub fn vk_destroy_device(device C.VkDevice, allocator voidptr) {
	C.vkDestroyDevice(device, allocator)
}

pub fn vk_destroy_shader_module(device C.VkDevice, modul C.VkShaderModule, alloc voidptr) {
	C.vkDestroyShaderModule(device, modul, alloc)
}

pub fn create_shader(p_next voidptr, flags u32, code []byte, device C.VkDevice, shader_type ShaderType, entry_point string) ?(C.VkShaderModule, C.VkPipelineShaderStageCreateInfo) {
	info := create_vk_shader_module_create_info(p_next, flags, code)
	shader_module := create_vk_shader_module(device, info, voidptr(0)) ?

	pipeline_stage_info := create_vk_pipeline_shader_stage_create_info(voidptr(0), 0,
		u32(shader_type), shader_module, entry_point, voidptr(0))

	return shader_module, pipeline_stage_info
}

pub fn print_layer_properties(layer C.VkLayerProperties) string {
	mut builder := strings.new_builder(100)
	builder.writeln('${string(layer.layerName)}:')
	builder.writeln('  SpecVersion: ${number_to_version(layer.specVersion)}')
	builder.writeln('  ImplementationVersion: ${number_to_version(layer.implementationVersion)}')
	builder.writeln('  Description: ${string(layer.description)}')
	res := builder.str()
	unsafe {
		builder.free()
	}
	return res
}

pub fn print_extension_properties(extension C.VkExtensionProperties) string {
	mut builder := strings.new_builder(100)
	builder.writeln('${string(extension.extensionName)}:')
	builder.writeln('  SpecVersion: ${number_to_version(extension.specVersion)}')
	res := builder.str()
	unsafe {
		builder.free()
	}
	return res
}

pub fn terminate_vstring(str string) charptr {
	mut bytes := str.bytes()
	bytes << `\0`
	return charptr(bytes.data)
}

pub fn terminate_vstring_array(strings []string) &charptr {
	mut ptrs := []charptr{len: strings.len}
	for i, str in strings {
		ptrs[i] = terminate_vstring(str)
	}
	return ptrs.data
}

pub fn null<T>() T {
	return T(C.VK_NULL_HANDLE)
}
