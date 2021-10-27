module misc

import os

pub fn load_shader(path string) ?[]byte {
	return os.read_bytes(path)
}
