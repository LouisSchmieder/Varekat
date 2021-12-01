module misc

[heap]
struct Progress {
pub mut:
	progress int
	max      int
}

// Create an empty progress
pub fn create_progress() &Progress {
	return &Progress{}
}

// Clear the progress, to reuse it
pub fn (mut progress Progress) clear() {
	progress.max = 0
	progress.progress = 0
}

// Init the progress
pub fn (mut progress Progress) init(max int) {
	progress.max += max
}

// Increase the progress by one unit
pub fn (mut progress Progress) update() {
	progress.progress += 1
}

// Returns the progress in procent
pub fn (mut progress Progress) get_progress() f32 {
	return f32(progress.progress) / f32(progress.max)
}
