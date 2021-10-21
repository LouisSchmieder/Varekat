module vulkan

type VkResult = u32

[typedef; heap]
struct C.VkApplicationInfo {
	sType int
	pNext voidptr
	pApplicationName charptr
	applicationVersion u32
	pEngineName charptr
	engineVersion u32
	apiVersion u32
}

[typedef]
struct C.VkInstanceCreateInfo {
	sType int
	pNext voidptr
	flags u32
	pApplicationInfo &C.VkApplicationInfo
	enabledLayerCount u32
	ppEnabledLayerNames &charptr
	enabledExtensionCount u32
	ppEnabledExtensionNames &charptr
}

[typedef]
struct C.VkInstance {}