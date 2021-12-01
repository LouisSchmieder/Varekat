module mathf

import math

struct Vec3<T> {
pub mut:
	x T
	y T
	z T
}

struct Vec2<T> {
pub mut:
	x T
	y T
}

struct Vec4<T> {
mut:
	y T
	z T
	x T
	w T
}

pub fn vec4<T>(vec Vec3<T>, w T) Vec4<T> {
	return Vec4<T>{
		x: vec.x
		y: vec.y
		z: vec.z
		w: w
	}
}

pub fn vec2<T>(x T, y T) Vec2<T> {
	return Vec2<T>{
		x: x
		y: y
	}
}

pub fn (a Vec3<T>) - (b Vec3<T>) Vec3<T> {
	return Vec3<T>{
		x: a.x - b.x
		y: a.y - b.y
		z: a.z - b.z
	}
}

pub fn vec3<T>(x T, y T, z T) Vec3<T> {
	return Vec3<T>{
		x: x
		y: y
		z: z
	}
}

pub fn dot<T>(a Vec3<T>, b Vec3<T>) T {
	return a.x * b.x + a.y * b.y + a.z * b.z
}

pub fn cross<T>(a Vec3<T>, b Vec3<T>) Vec3<T> {
	return Vec3<T>{
		x: a.y * b.z - a.z * b.y
		y: a.z * b.x - a.x * b.z
		z: a.x * b.y - a.y * b.x
	}
}

pub fn normalize<T>(vec Vec3<T>) Vec3<T> {
	m := vec.mod()
	if m == 0 {
		return Vec3<T>{}
	}
	return Vec3<T>{
		x: vec.x * (1 / m)
		y: vec.y * (1 / m)
		z: vec.z * (1 / m)
	}
}

pub fn (vec Vec3<T>) mod() T {
	return T(math.sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z))
}

pub fn (vec Vec3<T>) location_idx() T {
	return vec.x * vec.z + vec.y
}
