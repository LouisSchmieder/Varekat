module vulkan

import misc

fn C.VK_MAKE_VERSION(u32, u32, u32) u32
fn C.VK_VERSION_MAJOR(u32) u32
fn C.VK_VERSION_MINOR(u32) u32
fn C.VK_VERSION_PATCH(u32) u32

pub fn version_to_number(ver misc.Version) u32 {
	return C.VK_MAKE_VERSION(ver.major, ver.minor, ver.patch)
}

pub fn number_to_version(num u32) misc.Version {
	return misc.Version{
		major: C.VK_VERSION_MAJOR(num)
		minor: C.VK_VERSION_MINOR(num)
		patch: C.VK_VERSION_PATCH(num)
	}
}
