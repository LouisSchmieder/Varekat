module graphics

import mathf
import vk

pub struct Object {
mut:
	settings     ObjectSettings
	model_buffer ModelBuffer
	ub           &vk.UniformBuffer
	mesh         Mesh
}

pub fn create_object(mesh &Mesh, settings &ObjectSettings) &Object {
	return &Object{
		mesh: mesh
		ub: voidptr(0)
		settings: settings
	}
}

pub fn (mut object Object) update(pos mathf.Vec3<f32>, rot mathf.Vec3<f32>, scale mathf.Vec3<f32>) {
	object.settings.update(pos, rot, scale)
	unsafe { object.model_buffer.update(pos, rot, scale) }
}

pub fn (object Object) mesh() &Mesh {
	return &object.mesh
}

pub fn (mut object Object) create_ub(instance vk.Instance) ? {
	object.ub = instance.create_uniform_buffer<ModelBuffer>(
		stage: .vk_shader_stage_vertex_bit
		descriptor_type: .vk_descriptor_type_uniform_buffer
	) ?
}
