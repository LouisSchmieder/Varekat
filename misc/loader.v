module misc

import os

// Get the code of the shader at `path`
pub fn load_shader(path string) ?[]byte {
	return os.read_bytes(path)
}
