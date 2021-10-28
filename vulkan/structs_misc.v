module vulkan

type VkResult = u32
type VkDeviceAddress = u64
type VkDeviceSize = u64
type VkPresentModeKHR = u32

type VkVoidFunction = fn ()

[typedef]
struct C.VkPhysicalDeviceProperties {
	apiVersion    u32
	driverVersion u32
	vendorID      u32
	deviceID      u32
	deviceType    u32
	deviceName    charptr
}

[heap; typedef]
struct C.VkPhysicalDeviceFeatures {
	robustBufferAccess                      C.VkBool32
	imageCubeArray                          C.VkBool32
	independentBlend                        C.VkBool32
	geometryShader                          C.VkBool32
	tessellationShader                      C.VkBool32
	sampleRateShading                       C.VkBool32
	dualSrcBlend                            C.VkBool32
	logicOp                                 C.VkBool32
	multiDrawIndirect                       C.VkBool32
	drawIndirectFirstInstance               C.VkBool32
	depthClamp                              C.VkBool32
	depthBiasClamp                          C.VkBool32
	fillModeNonSolid                        C.VkBool32
	depthBounds                             C.VkBool32
	wideLines                               C.VkBool32
	largePoints                             C.VkBool32
	alphaToOne                              C.VkBool32
	multiViewport                           C.VkBool32
	samplerAnisotropy                       C.VkBool32
	textureCompressionETC2                  C.VkBool32
	textureCompressionASTC_LDR              C.VkBool32
	textureCompressionBC                    C.VkBool32
	occlusionQueryPrecise                   C.VkBool32
	pipelineStatisticsQuery                 C.VkBool32
	vertexPipelineStoresAndAtomics          C.VkBool32
	fragmentStoresAndAtomics                C.VkBool32
	shaderTessellationAndGeometryPointSize  C.VkBool32
	shaderImageGatherExtended               C.VkBool32
	shaderStorageImageExtendedFormats       C.VkBool32
	shaderStorageImageMultisample           C.VkBool32
	shaderStorageImageReadWithoutFormat     C.VkBool32
	shaderStorageImageWriteWithoutFormat    C.VkBool32
	shaderUniformBufferArrayDynamicIndexing C.VkBool32
	shaderSampledImageArrayDynamicIndexing  C.VkBool32
	shaderStorageBufferArrayDynamicIndexing C.VkBool32
	shaderStorageImageArrayDynamicIndexing  C.VkBool32
	shaderClipDistance                      C.VkBool32
	shaderCullDistance                      C.VkBool32
	shaderFloat64                           C.VkBool32
	shaderInt64                             C.VkBool32
	shaderInt16                             C.VkBool32
	shaderResourceResidency                 C.VkBool32
	shaderResourceMinLod                    C.VkBool32
	sparseBinding                           C.VkBool32
	sparseResidencyBuffer                   C.VkBool32
	sparseResidencyImage2D                  C.VkBool32
	sparseResidencyImage3D                  C.VkBool32
	sparseResidency2Samples                 C.VkBool32
	sparseResidency4Samples                 C.VkBool32
	sparseResidency8Samples                 C.VkBool32
	sparseResidency16Samples                C.VkBool32
	sparseResidencyAliased                  C.VkBool32
	variableMultisampleRate                 C.VkBool32
	inheritedQueries                        C.VkBool32
}

[typedef]
struct C.VkLayerProperties {
	layerName             charptr
	specVersion           u32
	implementationVersion u32
	description           charptr
}

[typedef]
struct C.VkExtensionProperties {
	extensionName charptr
	specVersion   u32
}

[typedef]
struct C.VkPhysicalDeviceMemoryProperties {
	memoryTypeCount u32
	memoryTypes     &C.VkMemoryType
	memoryHeapCount u32
	memoryHeaps     &C.VkMemoryHeap
}

[typedef]
struct C.VkMemoryType {
	propertyFlags u32
	heapIndex     u32
}

[typedef]
struct C.VkMemoryHeap {
	size  u64
	flags u32
}

[typedef]
struct C.VkQueueFamilyProperties {
	queueFlags         u32
	queueCount         u32
	timestampValidBits u32
}

[typedef]
struct C.VkExtent2D {
	width  u32
	height u32
}

[typedef]
struct C.VkOffset2D {
	x int
	y int
}

[typedef]
struct C.VkRect2D {
	offset C.VkOffset2D
	extent C.VkExtent2D
}

[typedef]
struct C.VkSurfaceCapabilitiesKHR {
	minImageCount           u32
	maxImageCount           u32
	currentExtent           C.VkExtent2D
	minImageExtent          C.VkExtent2D
	maxImageExtent          C.VkExtent2D
	maxImageArrayLayers     u32
	supportedTransforms     u32
	currentTransform        u32
	supportedCompositeAlpha u32
	supportedUsageFlags     u32
}

[typedef]
struct C.VkSurfaceFormatKHR {
	format     u32
	colorSpace u32
}

[typedef]
struct C.VkComponentMapping {
	r u32
	g u32
	b u32
	a u32
}

[typedef]
struct C.VkImageSubresourceRange {
	aspectMask     u32
	baseMipLevel   u32
	levelCount     u32
	baseArrayLayer u32
	layerCount     u32
}

[typedef]
struct C.VkVertexInputBindingDescription {
	binding   u32
	stride    u32
	inputRate u32
}

[typedef]
struct C.VkVertexInputAttributeDescription {
	location u32
	binding  u32
	format   u32
	offset   u32
}

[typedef]
struct C.VkViewport {
	x        f32
	y        f32
	width    f32
	height   f32
	minDepth f32
	maxDepth f32
}

[typedef]
struct C.VkPipelineColorBlendAttachmentState {
	blendEnable         C.VkBool32
	srcColorBlendFactor BlendFactor
	dstColorBlendFactor BlendFactor
	colorBlendOp        BlendOp
	srcAlphaBlendFactor BlendFactor
	dstAlphaBlendFactor BlendFactor
	alphaBlendOp        BlendOp
	colorWriteMask      u32
}

[typedef]
struct C.VkPushConstantRange {
	stageFlags u32
	offset     u32
	size       u32
}

[typedef]
struct C.VkAttachmentDescription {
	flags          u32
	format         u32
	samples        u32
	loadOp         AttachmentLoadOp
	storeOp        AttachmentStoreOp
	stencilLoadOp  AttachmentLoadOp
	stencilStoreOp AttachmentStoreOp
	initialLayout  ImageLayout
	finalLayout    ImageLayout
}

[typedef]
struct C.VkAttachmentReference {
	attachment u32
	layout     ImageLayout
}

[typedef]
struct C.VkSubpassDescription {
	flags                   u32
	pipelineBindPoint       PipelineBindPoint
	inputAttachmentCount    u32
	pInputAttachments       &C.VkAttachmentReference
	colorAttachmentCount    u32
	pColorAttachments       &C.VkAttachmentReference
	pResolveAttachments     &C.VkAttachmentReference
	pDepthStencilAttachment &C.VkAttachmentReference
	preserveAttachmentCount u32
	pPreserveAttachments    &u32
}

[typedef]
struct C.VkSubpassDependency {
	// TODO fill
}

[typedef]
union C.VkClearColorValue {
	float32 [4]f32
	int32   [4]int
	uint32  [4]u32
}

[typedef]
struct C.VkClearDepthStencilValue {
	depth   f32
	stencil u32
}

[typedef]
union C.VkClearValue {
	color        C.VkClearColorValue
	depthStencil C.VkClearDepthStencilValue
}
