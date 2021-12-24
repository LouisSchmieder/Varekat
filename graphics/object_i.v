module graphics

import mathf
import gg.m4
import vk

pub interface ObjectI {
mut:
	settings ObjectSettings
	model_buffer ModelBuffer
	ub &vk.UniformBuffer
	mesh Mesh
	mesh() &Mesh
	update(pos mathf.Vec3<f32>, rot mathf.Vec3<f32>, scale mathf.Vec3<f32>)
	create_ub(instance vk.Instance) ?
}

pub struct ModelBuffer {
mut:
	model_view m4.Mat4
	normal     m4.Mat4
}

// Unsafe because it can break things if you just update this
[unsafe]
fn (mut mb ModelBuffer) update(pos mathf.Vec3<f32>, rot mathf.Vec3<f32>, scale mathf.Vec3<f32>) {
	rxm := mathf.rot(rot.x, mathf.vec3<f32>(1, 0, 0))
	rym := mathf.rot(rot.y, mathf.vec3<f32>(0, 1, 0))
	rzm := mathf.rot(rot.z, mathf.vec3<f32>(0, 0, 1))

	model_pos := mathf.translate(pos)

	model_m := (rzm * rym * rxm) * model_pos
	scale_m := mathf.scale(scale)

	mb.model_view = scale_m * model_m
	mb.normal = mb.model_view.inverse().transpose()
}

pub struct ObjectSettings {
mut:
	position mathf.Vec3<f32>
	rotation mathf.Vec3<f32>
	scale    mathf.Vec3<f32>
}

fn (mut os ObjectSettings) update(pos mathf.Vec3<f32>, rot mathf.Vec3<f32>, scale mathf.Vec3<f32>) {
	os.position = pos
	os.rotation = rot
	os.scale = scale
}
