module vulkan

import strings

const (
	passable_error_codes = [0, 1000001003]
)

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
fn C.vkCreateCommandPool(C.VkDevice, &C.VkCommandPoolCreateInfo, voidptr, &C.VkCommandPool) VkResult
fn C.vkCreateSemaphore(C.VkDevice, &C.VkSemaphoreCreateInfo, voidptr, &C.VkSemaphore) VkResult
fn C.vkCreateBuffer(C.VkDevice, &C.VkBufferCreateInfo, voidptr, &C.VkBuffer) VkResult
fn C.vkCreateDescriptorSetLayout(C.VkDevice, &C.VkDescriptorSetLayoutCreateInfo, voidptr, &C.VkDescriptorSetLayout) VkResult
fn C.vkCreateDescriptorPool(C.VkDevice, &C.VkDescriptorPoolCreateInfo, voidptr, &C.VkDescriptorPool) VkResult
fn C.vkAllocateDescriptorSets(C.VkDevice, &C.VkDescriptorSetAllocateInfo, &C.VkDescriptorSet) VkResult

fn C.vkAllocateMemory(C.VkDevice, &C.VkMemoryAllocateInfo, voidptr, &C.VkDeviceMemory) VkResult
fn C.vkAllocateCommandBuffers(C.VkDevice, &C.VkCommandBufferAllocateInfo, &C.VkCommandBuffer) VkResult
fn C.vkBeginCommandBuffer(C.VkCommandBuffer, &C.VkCommandBufferBeginInfo) VkResult
fn C.vkAcquireNextImageKHR(C.VkDevice, C.VkSwapchainKHR, u64, C.VkSemaphore, C.VkFence, &u32) VkResult
fn C.vkQueueSubmit(C.VkQueue, u32, &C.VkSubmitInfo, C.VkFence) VkResult
fn C.vkQueuePresentKHR(C.VkQueue, &C.VkPresentInfoKHR) VkResult

fn C.vkEndCommandBuffer(C.VkCommandBuffer) VkResult
fn C.vkCmdBeginRenderPass(C.VkCommandBuffer, &C.VkRenderPassBeginInfo, u32)
fn C.vkCmdEndRenderPass(C.VkCommandBuffer)
fn C.vkCmdBindPipeline(C.VkCommandBuffer, PipelineBindPoint, C.VkPipeline)
fn C.vkCmdSetViewport(C.VkCommandBuffer, u32, u32, &C.VkViewport)
fn C.vkCmdSetScissor(C.VkCommandBuffer, u32, u32, &C.VkRect2D)
fn C.vkCmdDraw(C.VkCommandBuffer, u32, u32, u32, u32)
fn C.vkCmdDrawIndexed(C.VkCommandBuffer, u32, u32, u32, int, u32)
fn C.vkCmdBindVertexBuffers(C.VkCommandBuffer, u32, u32, C.VkBuffer, &u32)
fn C.vkCmdBindIndexBuffer(C.VkCommandBuffer, C.VkBuffer, u32, u32)
fn C.vkCmdBindDescriptorSets(C.VkCommandBuffer, u32, C.VkPipelineLayout, u32, u32, &C.VkDescriptorSet, u32, voidptr)
fn C.vkCmdCopyBuffer(C.VkCommandBuffer, C.VkBuffer, C.VkBuffer, u32, &C.VkBufferCopy)

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
fn C.vkGetBufferMemoryRequirements(C.VkDevice, C.VkBuffer, &C.VkMemoryRequirements)

fn C.vkGetPhysicalDeviceSurfaceSupportKHR(C.VkPhysicalDevice, u32, C.VkSurfaceKHR, &C.VkBool32) VkResult
fn C.vkBindBufferMemory(C.VkDevice, C.VkBuffer, C.VkDeviceMemory, u32) VkResult
fn C.vkMapMemory(C.VkDevice, C.VkDeviceMemory, u32, u32, u32, &voidptr) VkResult
fn C.vkUpdateDescriptorSets(C.VkDevice, u32, &C.VkWriteDescriptorSet, u32, voidptr)

fn C.vkDeviceWaitIdle(C.VkDevice)
fn C.vkQueueWaitIdle(C.VkQueue)
fn C.vkDestroyInstance(C.VkInstance, voidptr)
fn C.vkDestroyDevice(C.VkDevice, voidptr)
fn C.vkDestroyImageView(C.VkDevice, C.VkImageView, voidptr)
fn C.vkDestroyShaderModule(C.VkDevice, C.VkShaderModule, voidptr)
fn C.vkDestroySwapchainKHR(C.VkDevice, C.VkSwapchainKHR, voidptr)
fn C.vkDestroyRenderPass(C.VkDevice, C.VkRenderPass, voidptr)
fn C.vkDestroyPipeline(C.VkDevice, C.VkPipeline, voidptr)
fn C.vkDestroySemaphore(C.VkDevice, C.VkSemaphore, voidptr)
fn C.vkDestroyCommandPool(C.VkDevice, C.VkCommandPool, voidptr)
fn C.vkDestroyFramebuffer(C.VkDevice, C.VkFramebuffer, voidptr)
fn C.vkDestroyPipelineLayout(C.VkDevice, C.VkPipelineLayout, voidptr)
fn C.vkDestroySurfaceKHR(C.VkInstance, C.VkSurfaceKHR, voidptr)
fn C.vkDestroyBuffer(C.VkDevice, C.VkBuffer, voidptr)
fn C.vkFreeMemory(C.VkDevice, C.VkDeviceMemory, voidptr)
fn C.vkUnmapMemory(C.VkDevice, C.VkDeviceMemory)
fn C.vkFreeCommandBuffers(C.VkDevice, C.VkCommandPool, u32, &C.VkCommandBuffer)
fn C.vkDestroyDescriptorSetLayout(C.VkDevice, C.VkDescriptorSetLayout, voidptr)
fn C.vkDestroyDescriptorPool(C.VkDevice, C.VkDescriptorPool, voidptr)

fn handle_error(res VkResult, loc string) ? {
	if res !in vulkan.passable_error_codes {
		return error('Something went wrong with Vulkan in $loc ($res)')
	}
}

pub fn vk_physical_device_surface_support(device C.VkPhysicalDevice, queue_family_idx u32, surface C.VkSurfaceKHR) ?bool {
	support := unsafe { &C.VkBool32(malloc(int(sizeof(C.VkBool32)))) }
	res := C.vkGetPhysicalDeviceSurfaceSupportKHR(device, queue_family_idx, surface, support)
	handle_error(res, 'vk_physical_device_surface_support') ?
	return support == vk_true
}

pub fn vk_update_descriptor_sets(device C.VkDevice, writers []C.VkWriteDescriptorSet, copies []voidptr) {
	C.vkUpdateDescriptorSets(device, u32(writers.len), writers.data, u32(copies.len),
		copies.data)
}

pub fn vk_device_wait_idle(device C.VkDevice) {
	C.vkDeviceWaitIdle(device)
}

pub fn vk_queue_wait_idle(queue C.VkQueue) {
	C.vkQueueWaitIdle(queue)
}

pub fn vk_map_memory(device C.VkDevice, mem C.VkDeviceMemory, offset u32, size u32, flags u32) ?voidptr {
	data := unsafe { voidptr(0) }
	res := C.vkMapMemory(device, mem, offset, size, flags, &data)
	handle_error(res, 'vk_map_memory') ?
	return data
}

pub fn vk_unmap_memory(device C.VkDevice, mem C.VkDeviceMemory) {
	C.vkUnmapMemory(device, mem)
}

pub fn vk_bind_buffer_memory(device C.VkDevice, buffer C.VkBuffer, mem C.VkDeviceMemory, offset u32) ? {
	res := C.vkBindBufferMemory(device, buffer, mem, offset)
	handle_error(res, 'vk_bind_buffer_memory') ?
}

pub fn vk_queue_submit(queue C.VkQueue, submits []C.VkSubmitInfo, fence C.VkFence) ? {
	res := C.vkQueueSubmit(queue, u32(submits.len), submits.data, fence)
	handle_error(res, 'vk_queue_submit') ?
}

pub fn vk_queue_present(queue C.VkQueue, create_info &C.VkPresentInfoKHR) ? {
	res := C.vkQueuePresentKHR(queue, create_info)
	handle_error(res, 'vk_queue_present') ?
}

pub fn vk_cmd_begin_render_pass(buffer C.VkCommandBuffer, info &C.VkRenderPassBeginInfo, typ u32) {
	C.vkCmdBeginRenderPass(buffer, info, typ)
}

pub fn vk_cmd_bind_descriptor_sets(buffer C.VkCommandBuffer, pipeline_bind PipelineBindPoint, layout C.VkPipelineLayout, first_idx u32, sets []C.VkDescriptorSet, offsets []u32) {
	C.vkCmdBindDescriptorSets(buffer, u32(pipeline_bind), layout, first_idx, u32(sets.len),
		sets.data, u32(offsets.len), offsets.data)
}

pub fn vk_cmd_bind_index_buffer(buffer C.VkCommandBuffer, idx_buffer C.VkBuffer, offset u32, index_type u32) {
	C.vkCmdBindIndexBuffer(buffer, idx_buffer, offset, index_type)
}

pub fn vk_cmd_draw_indexed(buffer C.VkCommandBuffer, index_count u32, instance_count u32, first_index u32, offset int, first_instance u32) {
	C.vkCmdDrawIndexed(buffer, index_count, instance_count, first_index, offset, first_instance)
}

pub fn vk_cmd_end_render_pass(buffer C.VkCommandBuffer) {
	C.vkCmdEndRenderPass(buffer)
}

pub fn vk_cmd_copy_buffer(buffer C.VkCommandBuffer, src C.VkBuffer, dst C.VkBuffer, copies []C.VkBufferCopy) {
	C.vkCmdCopyBuffer(buffer, src, dst, u32(copies.len), copies.data)
}

pub fn vk_cmd_bind_pipeline(buffer C.VkCommandBuffer, bind_point PipelineBindPoint, pipeline C.VkPipeline) {
	C.vkCmdBindPipeline(buffer, bind_point, pipeline)
}

pub fn vk_cmd_draw(buffer C.VkCommandBuffer, vertex_count u32, instance_count u32, first_vertex u32, first_instance u32) {
	C.vkCmdDraw(buffer, vertex_count, instance_count, first_vertex, first_instance)
}

pub fn vk_cmd_bind_vertex_buffers(buffer C.VkCommandBuffer, first_binding u32, buffers []C.VkBuffer, offsets []u32) {
	C.vkCmdBindVertexBuffers(buffer, first_binding, u32(buffers.len), buffers.data, offsets.data)
}

pub fn vk_cmd_set_viewport(buffer C.VkCommandBuffer, first_viewport u32, viewports []C.VkViewport) {
	C.vkCmdSetViewport(buffer, first_viewport, u32(viewports.len), viewports.data)
}

pub fn vk_cmd_set_scissor(buffer C.VkCommandBuffer, first_scissor u32, scissors []C.VkRect2D) {
	C.vkCmdSetViewport(buffer, first_scissor, u32(scissors.len), scissors.data)
}

pub fn vk_begin_command_buffer(buffer C.VkCommandBuffer, info &C.VkCommandBufferBeginInfo) ? {
	res := C.vkBeginCommandBuffer(buffer, info)
	handle_error(res, 'vk_begin_command_buffer') ?
}

pub fn vk_end_command_buffer(buffer C.VkCommandBuffer) ? {
	res := C.vkEndCommandBuffer(buffer)
	handle_error(res, 'vk_end_command_buffer') ?
}

pub fn vk_free_memory(device C.VkDevice, mem C.VkDeviceMemory, callbacks voidptr) {
	C.vkFreeMemory(device, mem, callbacks)
}

pub fn vk_free_command_buffers(device C.VkDevice, command_pool C.VkCommandPool, buffers []C.VkCommandBuffer) {
	C.vkFreeCommandBuffers(device, command_pool, u32(buffers.len), buffers.data)
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

pub fn vk_destroy_descriptor_set_layout(device C.VkDevice, desc_set_layout C.VkDescriptorSetLayout, alloc voidptr) {
	C.vkDestroyDescriptorSetLayout(device, desc_set_layout, alloc)
}

pub fn vk_destroy_descriptor_pool(device C.VkDevice, desc_pool C.VkDescriptorPool, alloc voidptr) {
	C.vkDestroyDescriptorPool(device, desc_pool, alloc)
}

pub fn vk_destroy_buffer(device C.VkDevice, buffer C.VkBuffer, allocator voidptr) {
	C.vkDestroyBuffer(device, buffer, allocator)
}

pub fn vk_destroy_framebuffer(device C.VkDevice, framebuffer C.VkFramebuffer, allocator voidptr) {
	C.vkDestroyFramebuffer(device, framebuffer, allocator)
}

pub fn vk_destroy_semaphore(device C.VkDevice, semaphore C.VkSemaphore, allocator voidptr) {
	C.vkDestroySemaphore(device, semaphore, allocator)
}

pub fn vk_destroy_graphics_pipeline(device C.VkDevice, pipeline C.VkPipeline, allocator voidptr) {
	C.vkDestroyPipeline(device, pipeline, allocator)
}

pub fn vk_destroy_command_pool(device C.VkDevice, command_pool C.VkCommandPool, allocator voidptr) {
	C.vkDestroyCommandPool(device, command_pool, allocator)
}

pub fn vk_destroy_device(device C.VkDevice, allocator voidptr) {
	C.vkDestroyDevice(device, allocator)
}

pub fn vk_destroy_shader_module(device C.VkDevice, modul C.VkShaderModule, alloc voidptr) {
	C.vkDestroyShaderModule(device, modul, alloc)
}

pub fn get_binding_description(size u32) C.VkVertexInputBindingDescription {
	return create_vk_vertex_input_binding_description(0, size, .vk_vertex_input_rate_vertex)
}

pub fn get_attribute_descriptions(offsets []u32, binding []u32, format []u32) []C.VkVertexInputAttributeDescription {
	mut desc := []C.VkVertexInputAttributeDescription{}
	for i, offset in offsets {
		desc << create_vk_vertex_input_attribute_description(u32(i), binding[i], format[i],
			offset)
	}
	return desc
}

pub fn create_buffer(device C.VkDevice, p_device C.VkPhysicalDevice, buffer_size u32, usage []BufferUsageFlagBits, sharing_mode u32, queue_families []u32, required_mem_types []MemoryPropertyFlagBits) ?(C.VkBuffer, C.VkDeviceMemory) {
	mut usage_bit := u32(usage[0])
	for i in 1 .. usage.len {
		usage_bit |= u32(usage[i])
	}

	buffer_create_info := create_vk_buffer_create_info(voidptr(0), 0, buffer_size, usage_bit,
		sharing_mode, queue_families)
	buffer := create_vk_buffer(device, &buffer_create_info, voidptr(0)) ?
	mem_req := get_vk_memory_requirements(device, buffer)
	memory_allocate_info := create_vk_memory_allocate_info(voidptr(0), mem_req.size, find_memory_type_idx(mem_req.memoryTypeBits,
		required_mem_types, p_device) ?)
	buffer_memory := allocate_vk_memory(device, &memory_allocate_info, voidptr(0)) ?
	vk_bind_buffer_memory(device, buffer, buffer_memory, 0) ?
	return buffer, buffer_memory
}

pub fn copy_buffer(src C.VkBuffer, dst C.VkBuffer, size u32, command_pool C.VkCommandPool, device C.VkDevice, queue C.VkQueue) ? {
	create_info := create_vk_command_buffer_allocate_info(voidptr(0), command_pool, .vk_command_buffer_level_primary,
		u32(1))
	buffers := allocate_vk_command_buffers(device, &create_info) ?

	command_buffer := buffers[0]

	begin_info := create_vk_command_buffer_begin_info(voidptr(0), u32(C.VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT),
		voidptr(0))
	vk_begin_command_buffer(command_buffer, &begin_info) ?

	buffer_copy := C.VkBufferCopy{
		srcOffset: 0
		dstOffset: 0
		size: size
	}

	vk_cmd_copy_buffer(command_buffer, src, dst, [buffer_copy])
	vk_end_command_buffer(command_buffer) ?

	submit_info := create_vk_submit_info(voidptr(0), [], [], [command_buffer], [])

	vk_queue_submit(queue, [submit_info], null<C.VkFence>()) ?
	vk_queue_wait_idle(queue)
	vk_free_command_buffers(device, command_pool, buffers)
}

pub fn create_shader(p_next voidptr, flags u32, code []byte, device C.VkDevice, shader_type ShaderType, entry_point string) ?(C.VkShaderModule, C.VkPipelineShaderStageCreateInfo) {
	info := create_vk_shader_module_create_info(p_next, flags, code)
	shader_module := create_vk_shader_module(device, info, voidptr(0)) ?

	pipeline_stage_info := create_vk_pipeline_shader_stage_create_info(voidptr(0), 0,
		u32(shader_type), shader_module, entry_point, voidptr(0))

	return shader_module, pipeline_stage_info
}

pub fn find_memory_type_idx(filter u32, flags_array []MemoryPropertyFlagBits, device C.VkPhysicalDevice) ?u32 {
	physical_device_props := get_vk_physical_device_memory_properties(device)
	mut flags := u32(flags_array[0])
	for i in 1 .. flags_array.len {
		flags |= u32(flags_array[i])
	}

	for i in 0 .. physical_device_props.memoryTypeCount {
		prop_flag := unsafe { physical_device_props.memoryTypes[i].propertyFlags }

		mut found := true

		for s in 0 .. sizeof(u32) {
			shift := u32(1 << s)
			s_flags := flags & shift == shift
			s_filter := filter & shift == shift
			s_prop_flag := prop_flag & shift == shift
			if !s_flags {
				continue
			}
			if s_flags && !(s_flags == s_prop_flag && s_filter) {
				found = false
				break
			}
		}
		if found {
			return u32(i)
		}
	}

	return error('Found no correct memory type')
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
