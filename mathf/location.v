module mathf

import math

pub fn (vec Vec3<T>) length<T>(other Vec3<T>) T {
	return T(math.sqrt(vec.x * other.x + vec.y * other.y + vec.z * other.z))
}
