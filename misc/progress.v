module misc

[heap]
struct Progress {
pub mut:
	progress int
	max      int
}

pub fn create_progress() &Progress {
	return &Progress{}
}

pub fn (mut progress Progress) clear() {
	progress.max = 0
	progress.progress = 0
}

pub fn (mut progress Progress) init(max int) {
	progress.max += max
}

pub fn (mut progress Progress) update() {
	progress.progress += 1
}

pub fn (mut progress Progress) get_progress() f32 {
	return f32(progress.progress) / f32(progress.max)
}
