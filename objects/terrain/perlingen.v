module terrain

import mathf

pub fn perlin_map_gen(seed int, width int, height int, freq f32, depth f32) []f64 {
	mut data := []f64{len: width * height}
	for y in 0 .. height {
		for x in 0 .. width {
			sample_x := x
			sample_y := y

			data[y * width + x] = mathf.perlin2d(seed, sample_x, sample_y, freq, depth)
		}
	}
	return data
}
