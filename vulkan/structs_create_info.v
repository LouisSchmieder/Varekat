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

[heap; typedef]
struct C.VkPipelineVertexInputStateCreateInfo {
	sType                           StructureType
	pNext                           voidptr
	flags                           u32
	vertexBindingDescriptionCount   u32
	pVertexBindingDescriptions      &C.VkVertexInputBindingDescription
	vertexAttributeDescriptionCount u32
	pVertexAttributeDescriptions    &C.VkVertexInputAttributeDescription
}

[heap; typedef]
struct C.VkPipelineInputAssemblyStateCreateInfo {
	sType                  StructureType
	pNext                  voidptr
	flags                  u32
	topology               u32
	primitiveRestartEnable C.VkBool32
}

[heap; typedef]
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

[heap; typedef]
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

[heap; typedef]
struct C.VkPipelineColorBlendStateCreateInfo {
	sType           StructureType
	pNext           voidptr
	flags           u32
	logicOpEnable   C.VkBool32
	logicOp         LogicOp
	attachmentCount u32
	pAttachments    &C.VkPipelineColorBlendAttachmentState
	blendConstants  [4]f32
}

[heap; typedef]
struct C.VkPipelineViewportStateCreateInfo {
	sType         StructureType
	pNext         voidptr
	flags         u32
	viewportCount u32
	pViewports    &C.VkViewport
	scissorCount  u32
	pScissors     &C.VkRect2D
}

[typedef]
struct C.VkRenderPassCreateInfo {
	sType           StructureType
	pNext           voidptr
	flags           u32
	attachmentCount u32
	pAttachments    &C.VkAttachmentDescription
	subpassCount    u32
	pSubpasses      &C.VkSubpassDescription
	dependencyCount u32
	pDependencies   &C.VkSubpassDependency
}

[typedef]
struct C.VkGraphicsPipelineCreateInfo {
	sType               StructureType
	pNext               voidptr
	flags               u32
	stageCount          u32
	pStages             &C.VkPipelineShaderStageCreateInfo
	pVertexInputState   &C.VkPipelineVertexInputStateCreateInfo
	pInputAssemblyState &C.VkPipelineInputAssemblyStateCreateInfo
	pTessellationState  &C.VkPipelineTessellationStateCreateInfo
	pViewportState      &C.VkPipelineViewportStateCreateInfo
	pRasterizationState &C.VkPipelineRasterizationStateCreateInfo
	pMultisampleState   &C.VkPipelineMultisampleStateCreateInfo
	pDepthStencilState  &C.VkPipelineDepthStencilStateCreateInfo
	pColorBlendState    &C.VkPipelineColorBlendStateCreateInfo
	pDynamicState       &C.VkPipelineDynamicStateCreateInfo
	layout              C.VkPipelineLayout
	renderPass          C.VkRenderPass
	subpass             u32
	basePipelineHandle  C.VkPipeline
	basePipelineIndex   int
}

[typedef]
struct C.VkFramebufferCreateInfo {
	sType           StructureType
	pNext           voidptr
	flags           u32
	renderPass      C.VkRenderPass
	attachmentCount u32
	pAttachments    &C.VkImageView
	width           u32
	height          u32
	layers          u32
}

[typedef]
struct C.VkCommandPoolCreateInfo {
	sType            StructureType
	pNext            voidptr
	flags            u32
	queueFamilyIndex u32
}

[typedef]
struct C.VkCommandBufferAllocateInfo {
	sType              StructureType
	pNext              voidptr
	commandPool        C.VkCommandPool
	level              CommandBufferLevel
	commandBufferCount u32
}

[typedef]
struct C.VkCommandBufferBeginInfo {
	sType            StructureType
	pNext            voidptr
	flags            u32
	pInheritanceInfo &C.VkCommandBufferInheritanceInfo
}

[typedef]
struct C.VkRenderPassBeginInfo {
	sType           StructureType
	pNext           voidptr
	renderPass      C.VkRenderPass
	framebuffer     C.VkFramebuffer
	renderArea      C.VkRect2D
	clearValueCount u32
	pClearValues    &C.VkClearValue
}

[typedef]
struct C.VkSemaphoreCreateInfo {
	sType StructureType
	pNext voidptr
	flags u32
}

[typedef]
struct C.VkSubmitInfo {
	sType                StructureType
	pNext                voidptr
	waitSemaphoreCount   u32
	pWaitSemaphores      &C.VkSemaphore
	pWaitDstStageMask    &PipelineStageFlagBits
	commandBufferCount   u32
	pCommandBuffers      &C.VkCommandBuffer
	signalSemaphoreCount u32
	pSignalSemaphores    &C.VkSemaphore
}

[typedef]
struct C.VkPresentInfoKHR {
	sType              StructureType
	pNext              voidptr
	waitSemaphoreCount u32
	pWaitSemaphores    &C.VkSemaphore
	swapchainCount     u32
	pSwapchains        &C.VkSwapchainKHR
	pImageIndices      &u32
	pResults           &VkResult
}

[heap; typedef]
struct C.VkPipelineDynamicStateCreateInfo {
	sType             StructureType
	pNext             voidptr
	flags             u32
	dynamicStateCount u32
	pDynamicStates    &DynamicState
}

[typedef]
struct C.VkBufferCreateInfo {
	sType                 StructureType
	pNext                 voidptr
	flags                 u32
	size                  u32
	usage                 u32
	sharingMode           u32
	queueFamilyIndexCount u32
	pQueueFamilyIndices   &u32
}

[typedef]
struct C.VkMemoryAllocateInfo {
	sType           StructureType
	pNext           voidptr
	allocationSize  u32
	memoryTypeIndex u32
}

[typedef]
struct C.VkDescriptorSetLayoutCreateInfo {
	sType        StructureType
	pNext        voidptr
	flags        u32
	bindingCount u32
	pBindings    &C.VkDescriptorSetLayoutBinding
}

[typedef]
struct C.VkDescriptorPoolCreateInfo {
	sType         StructureType
	pNext         voidptr
	flags         u32
	maxSets       u32
	poolSizeCount u32
	pPoolSizes    &C.VkDescriptorPoolSize
}

[typedef]
struct C.VkDescriptorSetAllocateInfo {
	sType              StructureType
	pNext              voidptr
	descriptorPool     C.VkDescriptorPool
	descriptorSetCount u32
	pSetLayouts        &C.VkDescriptorSetLayout
}

[typedef]
struct C.VkWriteDescriptorSet {
	sType            StructureType
	pNext            voidptr
	dstSet           C.VkDescriptorSet
	dstBinding       u32
	dstArrayElement  u32
	descriptorCount  u32
	descriptorType   DescriptorType
	pImageInfo       voidptr // TODO add
	pBufferInfo      &C.VkDescriptorBufferInfo
	pTexelBufferView voidptr // TODO add
}
