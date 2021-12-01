module terrain

import mathf

pub type MapGen = fn (int, int, int, f32, f32) []f64

pub struct Heightmap {
	width  int
	height int
pub mut:
	pixels []f64
}

pub fn init_heightmap(width int, height int, pixels []f64) Heightmap {
	return Heightmap{
		width: width
		height: height
		pixels: pixels[0..width * height]
	}
}

pub fn create_random_heightmap(seed int, width int, height int, freq f32, depth f32, gen MapGen) Heightmap {
	return Heightmap{
		width: width
		height: height
		pixels: gen(seed, width, height, freq, depth)
	}
}

pub fn (a Heightmap) * (b Heightmap) Heightmap {
	if a.width != b.width || a.height != b.height {
		return a
	}
	mut data := []f64{len: a.width * b.height}
	for i in 0 .. data.len {
		data[i] = a.pixels[i] * b.pixels[i]
	}
	return Heightmap{
		width: a.width
		height: b.height
		pixels: data
	}
}

pub fn (mut h Heightmap) mult_f(b f64) {
	for i, p in h.pixels {
		h.pixels[i] = p * b
	}
}

pub fn (mut h Heightmap) math(b f64, mf mathf.DFunction) {
	for i, p in h.pixels {
		h.pixels[i] = mf(p, b)
	}
}
