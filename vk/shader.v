module vk

import vulkan
import misc

pub struct Shader {
	code        []byte
	typ         vulkan.ShaderType
	entry_point string
}

pub fn create_shader(path string, typ vulkan.ShaderType, entry_point string) ?Shader {
	return Shader{
		code: misc.load_shader(path) ?
		typ: typ
		entry_point: entry_point
	}
}
