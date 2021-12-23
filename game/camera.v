module game

import mathf
import gg.m4

pub struct Camera {
pub mut:
	pos    mathf.Vec3<f32>
	facing mathf.Vec3<f32>
	up     mathf.Vec3<f32>

	dir   mathf.Vec3<f32>
	yaw   f32
	pitch f32

	camera_speed f32 = 2.0
	sensitivity  f32 = 0.1
}

pub fn create_camera(pos mathf.Vec3<f32>, facing mathf.Vec3<f32>, up mathf.Vec3<f32>, camera_speed f32, pitch f32, yaw f32) Camera {
	mut c := Camera{
		pos: pos
		facing: facing
		up: up
		pitch: pitch
		yaw: yaw
		camera_speed: camera_speed
	}
	c.look(0, 0)
	return c
}

pub fn (mut c Camera) move(dir mathf.Vec3<f32>, delta_seconds f32) {
	// X
	c.pos += mathf.normalize(mathf.cross(c.facing, c.up)).mult_vec(c.camera_speed * delta_seconds).mult_vec(dir.x)

	// Z
	c.pos += c.facing.mult_vec(c.camera_speed * delta_seconds).mult_vec(dir.z)
}

pub fn (mut c Camera) look(offpitch f32, offyaw f32) {
	c.yaw += offyaw * c.sensitivity
	c.pitch += offpitch * c.sensitivity

	if c.pitch > 89 {
		c.pitch = 89
	}
	if c.pitch < -89 {
		c.pitch = -89
	}

	c.dir.x = mathf.cos(mathf.to_rad(c.yaw)) * mathf.cos(mathf.to_rad(c.pitch))
	c.dir.y = mathf.sin(mathf.to_rad(c.pitch))
	c.dir.z = mathf.sin(mathf.to_rad(c.yaw)) * mathf.cos(mathf.to_rad(c.pitch))

	c.facing = mathf.normalize(c.dir)
}

pub fn (mut c Camera) look_at() m4.Mat4 {
	return mathf.look_at(c.pos, c.pos + c.facing, c.up)
}
