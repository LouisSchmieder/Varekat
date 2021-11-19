module mathf

import gg.m4
import math

struct Vec3 {
mut:
	x f32
	y f32
	z f32
}

pub fn (a Vec3) - (b Vec3) Vec3 {
	return Vec3{
		x: a.x - b.x
		y: a.y - b.y
		z: a.z - b.z
	}
}

pub fn vec3(x f32, y f32, z f32) Vec3 {
	return Vec3 {
		x: x
		y: y
		z: z
	}
}

pub fn dot(a Vec3, b Vec3) f32 {
	return a.x * b.x + a.y * b.y + a.z * b.z
}

pub fn cross(a Vec3, b Vec3) Vec3 {
	return Vec3 {
		x: a.y * b.z - a.z * b.y
		y: a.z * b.x - a.x * b.z
		z: a.x * b.y - a.y * b.x
	}
}

pub fn normalize(vec Vec3) Vec3 {
	m := vec.mod()
	if m == 0 {
		return Vec3{}
	}
	return Vec3{
		x: vec.x * (1 / m)
		y: vec.y * (1 / m)
		z: vec.z * (1 / m)
	}
}

pub fn (vec Vec3) mod() f32 {
	return f32(math.sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z))
}

pub fn perspective(fov f32, ar f32, n f32, f f32) m4.Mat4 {
	focal_len := f32(1 / math.tan(fov / 2))
	return m4.Mat4{e: [
		focal_len / ar, 0, 0, 0,
		0, -focal_len, 0, 0,
		0, 0, n / (f - n), n * f / (f - n),
		0, 0, -1, 0
	]!}
}

pub fn look_at(eye Vec3, at Vec3, up Vec3) m4.Mat4 {
	z_axis := normalize(eye - at)
	x_axis := normalize(cross(up, z_axis))
	y_axis := cross(z_axis, x_axis)

	return m4.Mat4{e: [
		x_axis.x, x_axis.y, x_axis.z, dot(eye, x_axis)
		y_axis.x, y_axis.y, y_axis.z, dot(eye, y_axis)
		z_axis.x, z_axis.y, z_axis.z, dot(eye, z_axis)
		0       , 0       ,        0,                 1
	]!}
}

pub fn make_vulkan_mat(mat m4.Mat4) m4.Mat4 {
	mut new := m4.Mat4{}
	for x in 0..4 {
		for y in 0..4 {
			unsafe { new.f[y][x] = mat.f[x][y] }
		}
	}
	return new
}