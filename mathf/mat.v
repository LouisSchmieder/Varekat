module mathf

import gg.m4
import math

[inline]
fn gg_vec4(x f32, y f32, z f32, w f32) m4.Vec4 {
	return m4.Vec4{
		e: [x, y, z, w]!
	}
}

[inline]
fn to_vec4(in_vec Vec3<f32>) m4.Vec4 {
	return gg_vec4(in_vec.x, in_vec.y, in_vec.z, 0)
}

pub fn perspective(fov f32, a f32, n f32, far f32) m4.Mat4 {
	return m4.perspective(fov, a, n, far)
}

pub fn translate(dim Vec3<f32>) m4.Mat4 {
	return m4.unit_m4().translate(to_vec4(dim))
}

pub fn scale(dim Vec3<f32>) m4.Mat4 {
	return m4.scale(to_vec4(dim))
}

pub fn rot(angle f32, dim Vec3<f32>) m4.Mat4 {
	rad := f32(math.pi * angle)
	return m4.rotate(rad, to_vec4(dim))
}

pub fn look_at(eye Vec3<f32>, at Vec3<f32>, up Vec3<f32>) m4.Mat4 {
	return m4.look_at(to_vec4(eye), to_vec4(at), to_vec4(up))
}
