module mathf

import math

struct Vec3 {
mut:
	x f32
	y f32
	z f32
}

struct Vec4 {
mut:
	x f32
	y f32
	z f32
	w f32
}

pub fn vec4(vec Vec3, w f32) Vec4 {
	return Vec4{
		x: vec.x
		y: vec.y
		z: vec.z
		w: w
	}
}


pub fn (a Vec3) - (b Vec3) Vec3 {
	return Vec3{
		x: a.x - b.x
		y: a.y - b.y
		z: a.z - b.z
	}
}

pub fn vec3(x f32, y f32, z f32) Vec3 {
	return Vec3{
		x: x
		y: y
		z: z
	}
}

pub fn dot(a Vec3, b Vec3) f32 {
	return a.x * b.x + a.y * b.y + a.z * b.z
}

pub fn cross(a Vec3, b Vec3) Vec3 {
	return Vec3{
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
