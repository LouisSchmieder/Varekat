module graphics

import mathf

pub interface Object {
mut:
	mesh Mesh
	mesh() &Mesh
}

pub struct ObjectSettings {
	position mathf.Vec3<f32>
	rotation mathf.Vec3<f32>
	scale    mathf.Vec3<f32>
}
