module glfw

#define GLFW_INCLUDE_VULKAN

#pkgconfig glfw3
#include <GLFW/glfw3.h>

[typedef]
struct C.GLFWwindow {}

[typedef]
struct C.GLFWmonitor {}

type WindowSizeCb = fn (window voidptr, width int, height int)

fn C.glfwInit()
fn C.glfwWindowHint(int, int)
fn C.glfwCreateWindow(int, int, charptr, &C.GLFWmonitor, &C.GLFWwindow) &C.GLFWwindow
fn C.glfwPollEvents()
fn C.glfwWindowShouldClose(&C.GLFWwindow) int
fn C.glfwDestroyWindow(&C.GLFWwindow)
fn C.glfwGetRequiredInstanceExtensions(&u32) &charptr
fn C.glfwGetWindowUserPointer(&C.GLFWwindow) voidptr
fn C.glfwSetWindowUserPointer(&C.GLFWwindow, voidptr)
fn C.glfwSetWindowSizeCallback(&C.GLFWwindow, voidptr)
fn C.glfwTerminate()

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
