module misc

pub struct Keyboard {
mut:
	keys map[Key]Action
	mods map[Key]int
}

pub fn create_keyboard() Keyboard {
	return Keyboard{}
}

pub fn (mut keyboard Keyboard) update(key Key, action Action, mod int) {
	keyboard.keys[key] = action
	keyboard.mods[key] = mod
}

pub fn (mut keyboard Keyboard) get_action(key Key) Action {
	if key in keyboard.keys {
		return keyboard.keys[key]
	}
	return .release
}

pub fn (mut keyboard Keyboard) get_mod(key Key) int {
	if key in keyboard.mods {
		return keyboard.mods[key]
	}
	return 0
}

pub fn (mut keyboard Keyboard) is_pressed(key Key) bool {
	return keyboard.get_action(key) == .press || keyboard.get_action(key) == .repeat
}
