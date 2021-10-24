module misc

pub struct Version {
pub mut:
	major u32
	minor u32
	patch u32
}

pub fn make_version(major u32, minor u32, patch u32) Version {
	return Version{
		major: major
		minor: minor
		patch: patch
	}
}

pub fn (ver Version) str() string {
	return '${ver.major}.${ver.minor}.$ver.patch'
}
