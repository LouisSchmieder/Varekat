module misc

pub fn create_location_index(x int, y int, height int) u32 {
	return u32(x * height + y)
}
