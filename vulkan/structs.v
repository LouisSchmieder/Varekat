module vulkan

const (
	vk_true  = VkBool(1)
	vk_false = VkBool(0)
)

type VkResult = u32
type VkBool = u32

[heap; typedef]
struct C.VkApplicationInfo {
	sType              int
	pNext              voidptr
	pApplicationName   charptr
	applicationVersion u32
	pEngineName        charptr
	engineVersion      u32
	apiVersion         u32
}

[typedef]
struct C.VkInstanceCreateInfo {
	sType                   int
	pNext                   voidptr
	flags                   u32
	pApplicationInfo        &C.VkApplicationInfo
	enabledLayerCount       u32
	ppEnabledLayerNames     &charptr
	enabledExtensionCount   u32
	ppEnabledExtensionNames &charptr
}

[typedef]
struct C.VkInstance {}

[typedef]
struct C.VkPhysicalDevice {}

[typedef]
struct C.VkPhysicalDeviceProperties {
	apiVersion    u32
	driverVersion u32
	vendorID      u32
	deviceID      u32
	deviceType    u32
	deviceName    charptr
}

[typedef]
struct C.VkPhysicalDeviceFeatures {
	robustBufferAccess                      VkBool
	fullDrawIndexUint32                     VkBool
	imageCubeArray                          VkBool
	independentBlend                        VkBool
	geometryShader                          VkBool
	tessellationShader                      VkBool
	sampleRateShading                       VkBool
	dualSrcBlend                            VkBool
	logicOp                                 VkBool
	multiDrawIndirect                       VkBool
	drawIndirectFirstInstance               VkBool
	depthClamp                              VkBool
	depthBiasClamp                          VkBool
	fillModeNonSolid                        VkBool
	depthBounds                             VkBool
	wideLines                               VkBool
	largePoints                             VkBool
	alphaToOne                              VkBool
	multiViewport                           VkBool
	samplerAnisotropy                       VkBool
	textureCompressionETC2                  VkBool
	textureCompressionASTC_LDR              VkBool
	textureCompressionBC                    VkBool
	occlusionQueryPrecise                   VkBool
	pipelineStatisticsQuery                 VkBool
	vertexPipelineStoresAndAtomics          VkBool
	fragmentStoresAndAtomics                VkBool
	shaderTessellationAndGeometryPointSize  VkBool
	shaderImageGatherExtended               VkBool
	shaderStorageImageExtendedFormats       VkBool
	shaderStorageImageMultisample           VkBool
	shaderStorageImageReadWithoutFormat     VkBool
	shaderStorageImageWriteWithoutFormat    VkBool
	shaderUniformBufferArrayDynamicIndexing VkBool
	shaderSampledImageArrayDynamicIndexing  VkBool
	shaderStorageBufferArrayDynamicIndexing VkBool
	shaderStorageImageArrayDynamicIndexing  VkBool
	shaderClipDistance                      VkBool
	shaderCullDistance                      VkBool
	shaderFloat64                           VkBool
	shaderInt64                             VkBool
	shaderInt16                             VkBool
	shaderResourceResidency                 VkBool
	shaderResourceMinLod                    VkBool
	sparseBinding                           VkBool
	sparseResidencyBuffer                   VkBool
	sparseResidencyImage2D                  VkBool
	sparseResidencyImage3D                  VkBool
	sparseResidency2Samples                 VkBool
	sparseResidency4Samples                 VkBool
	sparseResidency8Samples                 VkBool
	sparseResidency16Samples                VkBool
	sparseResidencyAliased                  VkBool
	variableMultisampleRate                 VkBool
	inheritedQueries                        VkBool
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
