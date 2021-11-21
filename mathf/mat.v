module mathf

import gg.m4
import math

pub fn perspective(fov f32, a f32, n f32, far f32) m4.Mat4 {
	f := f32(1 / math.tan(fov * 0.5 / 180 * f32(math.pi)))
	q := f / (far - n)
	return m4.Mat4{
		e: [
			f * a,
			0,
			0,
			0,
			0,
			f,
			0,
			0,
			0,
			0,
			q,
			1,
			0,
			0,
			-n * q,
			0,
		]!
	}
}

pub fn translate(x f32, y f32, z f32) m4.Mat4 {
	return m4.Mat4{
		e: [
			f32(1),
			0,
			0,
			0,
			0,
			1,
			0,
			0,
			0,
			0,
			1,
			0,
			x,
			y,
			z,
			0,
		]!
	}
}

pub fn scale(x f32, y f32, z f32) m4.Mat4 {
	return m4.Mat4{
		e: [
			x,
			0,
			0,
			0,
			0,
			y,
			0,
			0,
			0,
			0,
			z,
			0,
			0,
			0,
			0,
			0,
		]!
	}
}

pub fn transform(ox f32, oy f32, oz f32, sx f32, sy f32, sz f32) m4.Mat4 {
	return m4.Mat4{
		e: [
			sx,
			0,
			0,
			0,
			0,
			sy,
			0,
			0,
			0,
			0,
			sz,
			0,
			ox,
			oy,
			oz,
			0,
		]!
	}
}

pub fn rot_z(angle f32) m4.Mat4 {
	rad := f32(math.pi * angle)
	c := f32(math.cos(rad))
	s := f32(math.sin(rad))
	return m4.Mat4{
		e: [
			c,
			s,
			0,
			0,
			-s,
			c,
			0,
			0,
			0,
			0,
			1,
			0,
			0,
			0,
			0,
			1,
		]!
	}
}

pub fn rot_x(angle f32) m4.Mat4 {
	rad := f32(math.pi * angle / 2)
	c := f32(math.cos(rad))
	s := f32(math.sin(rad))
	return m4.Mat4{
		e: [
			f32(1),
			0,
			0,
			0,
			0,
			c,
			-s,
			0,
			0,
			s,
			c,
			0,
			0,
			0,
			0,
			1,
		]!
	}
}

pub fn make_vulkan_mat(mat m4.Mat4) m4.Mat4 {
	mut new := m4.Mat4{}
	for x in 0 .. 4 {
		for y in 0 .. 4 {
			unsafe {
				new.f[y][x] = mat.f[x][y]
			}
		}
	}
	return new
}
