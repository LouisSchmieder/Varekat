module vulkan

[heap; typedef]
struct C.VkApplicationInfo {
	sType              StructureType
	pNext              voidptr
	pApplicationName   charptr
	applicationVersion u32
	pEngineName        charptr
	engineVersion      u32
	apiVersion         u32
}

[typedef]
struct C.VkInstanceCreateInfo {
	sType                   StructureType
	pNext                   voidptr
	flags                   u32
	pApplicationInfo        &C.VkApplicationInfo
	enabledLayerCount       u32
	ppEnabledLayerNames     &charptr
	enabledExtensionCount   u32
	ppEnabledExtensionNames &charptr
}

[typedef]
struct C.VkDeviceQueueCreateInfo {
	sType            StructureType
	pNext            voidptr
	flags            u32
	queueFamilyIndex u32
	queueCount       u32
	pQueuePriorities &f32
}

[typedef]
struct C.VkDeviceCreateInfo {
	sType                   StructureType
	pNext                   voidptr
	flags                   u32
	queueCreateInfoCount    u32
	pQueueCreateInfos       &C.VkDeviceQueueCreateInfo
	enabledLayerCount       u32
	ppEnabledLayerNames     &charptr
	enabledExtensionCount   u32
	ppEnabledExtensionNames &charptr
	pEnabledFeatures        &C.VkPhysicalDeviceFeatures
}

[typedef]
struct C.VkSwapchainCreateInfoKHR {
	sType                 StructureType
	pNext                 voidptr
	flags                 u32
	surface               C.VkSurfaceKHR
	minImageCount         u32
	imageFormat           u32
	imageColorSpace       u32
	imageExtent           C.VkExtent2D
	imageArrayLayers      u32
	imageUsage            u32
	imageSharingMode      u32
	queueFamilyIndexCount u32
	pQueueFamilyIndices   &u32
	preTransform          u32
	compositeAlpha        u32
	presentMode           VkPresentModeKHR
	clipped               C.VkBool32
	oldSwapchain          C.VkSwapchainKHR
}

[typedef]
struct C.VkImageViewCreateInfo {
	sType            StructureType
	pNext            voidptr
	flags            u32
	image            C.VkImage
	viewType         u32
	format           u32
	components       C.VkComponentMapping
	subresourceRange C.VkImageSubresourceRange
}

[typedef]
struct C.VkShaderModuleCreateInfo {
	sType    StructureType
	pNext    voidptr
	flags    u32
	codeSize u32
	pCode    &u32
}

[typedef]
struct C.VkPipelineShaderStageCreateInfo {
	sType               StructureType
	pNext               voidptr
	flags               u32
	stage               u32
	@module             C.VkShaderModule
	pName               charptr
	pSpecializationInfo voidptr
}

[typedef]
struct C.VkPipelineVertexInputStateCreateInfo {
	sType                           StructureType
	pNext                           voidptr
	flags                           u32
	vertexBindingDescriptionCount   u32
	pVertexBindingDescriptions      &C.VkVertexInputBindingDescription
	vertexAttributeDescriptionCount u32
	pVertexAttributeDescriptions    &C.VkVertexInputAttributeDescription
}

[typedef]
struct C.VkPipelineInputAssemblyStateCreateInfo {
	sType                  StructureType
	pNext                  voidptr
	flags                  u32
	topology               u32
	primitiveRestartEnable C.VkBool32
}

[typedef]
struct C.VkPipelineRasterizationStateCreateInfo {
	sType                   StructureType
	pNext                   voidptr
	flags                   u32
	depthClampEnable        C.VkBool32
	rasterizerDiscardEnable C.VkBool32
	polygonMode             u32
	cullMode                u32
	frontFace               u32
	depthBiasEnable         C.VkBool32
	depthBiasConstantFactor f32
	depthBiasClamp          f32
	depthBiasSlopeFactor    f32
	lineWidth               f32
}

[typedef]
struct C.VkPipelineMultisampleStateCreateInfo {
	sType                 StructureType
	pNext                 voidptr
	flags                 u32
	rasterizationSamples  u32
	sampleShadingEnable   C.VkBool32
	minSampleShading      f32
	pSampleMask           &C.VkSampleMask
	alphaToCoverageEnable C.VkBool32
	alphaToOneEnable      C.VkBool32
}

[typedef]
struct C.VkPipelineLayoutCreateInfo {
	sType                  StructureType
	pNext                  voidptr
	flags                  u32
	setLayoutCount         u32
	pSetLayouts            &C.VkDescriptorSetLayout
	pushConstantRangeCount u32
	pPushConstantRanges    &C.VkPushConstantRange
}

[typedef]
struct C.VkPipelineColorBlendStateCreateInfo {
	sType           StructureType
	pNext           voidptr
	flags           u32
	logicOpEnable   C.VkBool32
	logicOp         LogicOp
	attachmentCount u32
	pAttachments    &C.VkPipelineColorBlendAttachmentState
	blendConstants  []f32
}

[typedef]
struct C.VkPipelineViewportStateCreateInfo {
	sType         StructureType
	pNext         voidptr
	flags         u32
	viewportCount u32
	pViewports    &C.VkViewport
	scissorCount  u32
	pScissors     &C.VkRect2D
}
