module misc

pub struct Mouse {
mut:
	initial bool = true
pub mut:
	last_x f32
	last_y f32
	x      f32
	y      f32
	off_x  f32
	off_y  f32
}

pub fn create_mouse() Mouse {
	return Mouse{}
}

pub fn (mut mouse Mouse) update(x f32, y f32) {
	if mouse.initial {
		mouse.last_x = x
		mouse.last_y = y
		mouse.initial = false
	}
	mouse.x = x
	mouse.y = y

	mouse.off_x = mouse.x - mouse.last_x
	mouse.off_y = mouse.y - mouse.last_y
	mouse.last_x = x
	mouse.last_y = y
}
