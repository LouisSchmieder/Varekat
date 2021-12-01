module terrain

import mathf

pub fn perlin_map_gen(seed int, width int, height int, freq f32, depth f32) []f64 {
	mut data := []f64{len: width * height}
	for x in 0 .. width {
		for y in 0 .. height {
			sample_x := x
			sample_y := y

			data[x * height + y] = mathf.perlin2d(seed, sample_x, sample_y, freq, depth)
		}
	}
	return data
}
