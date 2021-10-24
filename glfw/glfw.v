module glfw

#define GLFW_INCLUDE_VULKAN

#pkgconfig glfw3
#include <GLFW/glfw3.h>

[typedef]
struct C.GLFWwindow {}

[typedef]
struct C.GLFWmonitor {}

fn C.glfwInit()
fn C.glfwWindowHint(int, int)
fn C.glfwCreateWindow(int, int, charptr, &C.GLFWmonitor, &C.GLFWwindow) &C.GLFWwindow
fn C.glfwPollEvents()
fn C.glfwWindowShouldClose(&C.GLFWwindow) int
fn C.glfwDestroyWindow(&C.GLFWwindow)
fn C.glfwGetRequiredInstanceExtensions(&u32) &charptr

pub fn glfw_init() {
	C.glfwInit()
}

pub fn window_hint(hint int, value int) {
	C.glfwWindowHint(hint, value)
}

pub fn create_window(width int, height int, title string, monitor &C.GLFWmonitor) &C.GLFWwindow {
	return C.glfwCreateWindow(width, height, title.str, monitor, voidptr(0))
}

pub fn poll_events() {
	C.glfwPollEvents()
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
			res[i] = string(ptr[i])
		}
	}
	return res
}
