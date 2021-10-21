module main

import vulkan

fn main() {
	vulkan.create() or { panic(err) }
}
