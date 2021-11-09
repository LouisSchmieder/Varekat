module mathf

pub type DFunction = fn (f64, f64) f64

pub fn add_d(a f64, b f64) f64 {
	return a + b
}

pub fn sub_d(a f64, b f64) f64 {
	return a - b
}

pub fn mult_d(a f64, b f64) f64 {
	return a * b
}

pub fn div_d(a f64, b f64) f64 {
	return a / b
}
