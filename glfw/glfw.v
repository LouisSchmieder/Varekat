module glfw

#define GLFW_INCLUDE_VULKAN

[typedef]
struct C.GLFWwindow {}

[typedef]
struct C.GLFWmonitor {}

type WindowSizeCb = fn (window voidptr, width int, height int)

type ErrorCb = fn (error int, msg charptr)

type KeyCb = fn (window &C.GLFWwindow, key int, scancode int, action int, mods int)

type MouseCb = fn (window &C.GLFWwindow, xpos f64, ypos f64)

fn C.glfwInit()
fn C.glfwWindowHint(int, int)
fn C.glfwCreateWindow(int, int, charptr, &C.GLFWmonitor, &C.GLFWwindow) &C.GLFWwindow
fn C.glfwPollEvents()
fn C.glfwWindowShouldClose(&C.GLFWwindow) int
fn C.glfwDestroyWindow(&C.GLFWwindow)
fn C.glfwGetRequiredInstanceExtensions(&u32) &charptr
fn C.glfwGetWindowUserPointer(&C.GLFWwindow) voidptr
fn C.glfwSetWindowUserPointer(&C.GLFWwindow, voidptr)
fn C.glfwSetInputMode(&C.GLFWwindow, int, int)
fn C.glfwTerminate()

fn C.glfwSetWindowSizeCallback(&C.GLFWwindow, voidptr)
fn C.glfwSetKeyCallback(&C.GLFWwindow, voidptr)
fn C.glfwSetCursorPosCallback(&C.GLFWwindow, voidptr)
fn C.glfwSetErrorCallback(voidptr)

pub fn glfw_init() {
	C.glfwInit()
}

pub fn glfw_terminate() {
	C.glfwTerminate()
}

pub fn window_hint(hint int, value int) {
	C.glfwWindowHint(hint, value)
}

pub fn create_window(width int, height int, title string, monitor &C.GLFWmonitor) &C.GLFWwindow {
	return C.glfwCreateWindow(width, height, title.str, monitor, voidptr(0))
}

pub fn set_user_ptr(win &C.GLFWwindow, data voidptr) {
	C.glfwSetWindowUserPointer(win, data)
}

pub fn get_user_ptr(win &C.GLFWwindow) voidptr {
	return C.glfwGetWindowUserPointer(win)
}

pub fn poll_events() {
	C.glfwPollEvents()
}

pub fn set_window_resize_cb(win &C.GLFWwindow, cb WindowSizeCb) {
	C.glfwSetWindowSizeCallback(win, cb)
}

pub fn set_key_cb(win &C.GLFWwindow, cb KeyCb) {
	C.glfwSetKeyCallback(win, cb)
}

pub fn set_mouse_cb(win &C.GLFWwindow, cb MouseCb) {
	C.glfwSetCursorPosCallback(win, cb)
}

pub fn set_error_cb(cb ErrorCb) {
	C.glfwSetErrorCallback(cb)
}

pub fn should_close(window &C.GLFWwindow) bool {
	return C.glfwWindowShouldClose(window) == 1
}

pub fn destroy_window(window &C.GLFWwindow) {
	C.glfwDestroyWindow(window)
}

pub fn get_required_instance_extensions() []string {
	amount := u32(0)
	ptr := C.glfwGetRequiredInstanceExtensions(&amount)
	mut res := []string{len: int(amount)}
	for i in 0 .. amount {
		unsafe {
			res[i] = cstring_to_vstring(ptr[i])
		}
	}
	return res
}

pub fn set_input_mode(window &C.GLFWwindow, typ int, mode int) {
	C.glfwSetInputMode(window, typ, mode)
}

pub fn hide_mouse(window &C.GLFWwindow) {
	set_input_mode(window, C.GLFW_CURSOR, C.GLFW_CURSOR_DISABLED)
}

pub fn show_mouse(window &C.GLFWwindow) {
	set_input_mode(window, C.GLFW_CURSOR, C.GLFW_CURSOR_NORMAL)
}
