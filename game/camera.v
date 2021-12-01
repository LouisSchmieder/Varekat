module game

import mathf
import gg.m4

pub struct Camera {
pub mut:
	pos                          mathf.Vec3<f32>
	facing                       mathf.Vec3<f32>
	up                           mathf.Vec3<f32>

	camera_speed                 f32 = 2.0
}

pub fn create_camera(pos mathf.Vec3<f32>, facing mathf.Vec3<f32>, up mathf.Vec3<f32>, camera_speed f32) Camera {
	return Camera{
		pos: pos
		facing: facing
		up: up
		camera_speed: camera_speed
	}
}

pub fn (mut c Camera) look_at() m4.Mat4 {
	return mathf.make_vulkan_mat(mathf.look_at(c.pos, c.pos + c.facing, c.up))
}