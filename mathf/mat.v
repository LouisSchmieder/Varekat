module mathf

import gg.m4
import math

struct UBO {
mut:
	model_view m4.Mat4
	mvp        m4.Mat4
	normal     m4.Mat4
}

pub fn (mut ubo UBO) update_ubo(fov f32, ar f32, np f32, fp f32, view m4.Mat4, pos Vec3<f32>, r Vec3<f32>, s Vec3<f32>) {
	proj := perspective(fov, ar, np, fp)
	view_proj := view * proj

	rxm := rot(r.x, vec3<f32>(1, 0, 0))
	rym := rot(r.y, vec3<f32>(0, 1, 0))
	rzm := rot(r.z, vec3<f32>(0, 0, 1))

	model_pos := translate(pos)

	model_m := (rzm * rym * rxm) * model_pos
	scale_m := scale(s)

	ubo.model_view = scale_m * model_m
	ubo.normal = ubo.model_view.inverse().transpose()
	ubo.mvp = ubo.model_view * view_proj
}

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
