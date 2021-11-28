module buffer

import encoding.binary
import mathf

struct BinaryOutputStream {
pub mut:
	bytes []byte
}

pub fn new_binary_output_stream() &BinaryOutputStream {
	return &BinaryOutputStream{
		bytes: []byte{}
	}
}

pub fn (mut bos BinaryOutputStream) empty_buffer() {
	bos.bytes = []byte{}
}

pub fn (mut bos BinaryOutputStream) write_int(d int) {
	mut bytes := []byte{len: int(sizeof(int))}
	binary.big_endian_put_u32(mut bytes, u32(d))
	bos.bytes << bytes
}

pub fn (mut bos BinaryOutputStream) write_ints(d []int) {
	for u in d {
		mut tmp := []byte{len: int(sizeof(int))}
		binary.big_endian_put_u32(mut tmp, u32(u))
		bos.bytes << tmp
	}
}

pub fn (mut bos BinaryOutputStream) write_i8(d i8) {
	bos.bytes << byte(d)
}

pub fn (mut bos BinaryOutputStream) write_i8s(d []i8) {
	for a in d {
		bos.bytes << byte(a)
	}
}

pub fn (mut bos BinaryOutputStream) write_i16(d i16) {
	mut bytes := []byte{len: int(sizeof(i16))}
	binary.big_endian_put_u16(mut bytes, u16(d))
	bos.bytes << bytes
}

pub fn (mut bos BinaryOutputStream) write_i16s(d []i16) {
	for u in d {
		mut tmp := []byte{len: int(sizeof(i16))}
		binary.big_endian_put_u16(mut tmp, u16(u))
		bos.bytes << tmp
	}
}

pub fn (mut bos BinaryOutputStream) write_i64(d i64) {
	mut bytes := []byte{len: int(sizeof(i64))}
	binary.big_endian_put_u64(mut bytes, u64(d))
	bos.bytes << bytes
}

pub fn (mut bos BinaryOutputStream) write_i64s(d []i64) {
	for u in d {
		mut tmp := []byte{len: int(sizeof(i64))}
		binary.big_endian_put_u64(mut tmp, u64(u))
		bos.bytes << tmp
	}	
}

pub fn (mut bos BinaryOutputStream) write_byte(d byte) {
	bos.bytes << d
}

pub fn (mut bos BinaryOutputStream) write_bytes(d []byte) {
	bos.bytes << d
}

pub fn (mut bos BinaryOutputStream) write_u16(d u16) {
	mut bytes := []byte{len: int(sizeof(u16))}
	binary.big_endian_put_u16(mut bytes, d)
	bos.bytes << bytes
}

pub fn (mut bos BinaryOutputStream) write_u16s(d []u16) {
	for u in d {
		mut tmp := []byte{len: int(sizeof(u16))}
		binary.big_endian_put_u16(mut tmp, u)
		bos.bytes << tmp
	}
	
}

pub fn (mut bos BinaryOutputStream) write_u32(d u32) {
	mut bytes := []byte{len: int(sizeof(u32))}
	binary.big_endian_put_u32(mut bytes, d)
	bos.bytes << bytes
}

pub fn (mut bos BinaryOutputStream) write_u32s(d []u32) {
	
	for u in d {
		mut tmp := []byte{len: int(sizeof(u32))}
		binary.big_endian_put_u32(mut tmp, u)
		bos.bytes << tmp
	}
	
}

pub fn (mut bos BinaryOutputStream) write_u64(d u64) {
	mut bytes := []byte{len: int(sizeof(u64))}
	binary.big_endian_put_u64(mut bytes, d)
	bos.bytes << bytes
}

pub fn (mut bos BinaryOutputStream) write_u64s(d []u64) {
	
	for u in d {
		mut tmp := []byte{len: int(sizeof(u64))}
		binary.big_endian_put_u64(mut tmp, u)
		bos.bytes << tmp
	}
	
}

pub fn (mut bos BinaryOutputStream) write_f32(d f32) {
	pb := unsafe { &byte(&d) }
	mut bytes := []byte{len: int(sizeof(f32))}
	unsafe {
		for i in 0..bytes.len {
			bytes[i] = pb[i]
		}
	}
	bos.bytes << bytes
}

pub fn (mut bos BinaryOutputStream) write_f32s(d []f32) {
	
	for f in d {
		pb := unsafe { &byte(&f) }
		unsafe {
			for i in 0..int(sizeof(f32)) {
				bos.bytes << pb[i]
			}
		}
	}
	
}

pub fn (mut bos BinaryOutputStream) write_f64(d f64) {
	pb := unsafe { &byte(&d) }
	mut bytes := []byte{len: int(sizeof(f64))}
	unsafe {
		for i in 0..bytes.len {
			bytes[i] = pb[i]
		}
	}
	bos.bytes << bytes
	
}

pub fn (mut bos BinaryOutputStream) write_f64s(d []f64) {
	
	for f in d {
		pb := unsafe { &byte(&f) }
		unsafe {
			for i in 0..int(sizeof(f64)) {
				bos.bytes << pb[i]
			}
		}
	}
	
}

pub fn (mut bos BinaryOutputStream) write_string(d string) {
	bos.write_bytes(d.bytes())
}

pub fn (mut bos BinaryOutputStream) write_bool(b bool) {
	bos.write_byte(byte(if b { 0x01 } else { 0x00 }))
}

pub fn (mut bos BinaryOutputStream) write_vec3(v mathf.Vec3) {
	bos.write_f32s([v.x, v.y, v.z])
}

pub fn (mut bos BinaryOutputStream) write_vec2(v mathf.Vec2) {
	bos.write_f32s([v.x, v.y])
}