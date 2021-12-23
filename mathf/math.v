module mathf

import math

pub fn to_rad(angle f32) f32 {
	return angle / 180 * math.pi
}

[inline]
pub fn cos(angle f32) f32 {
	return f32(math.cos(angle))
}

[inline]
pub fn sin(angle f32) f32 {
	return f32(math.sin(angle))
}
