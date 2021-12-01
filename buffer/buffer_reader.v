module buffer

import encoding.binary
import mathf
import misc

struct BinaryInputStream {
mut:
	buffer   []byte
	progress &misc.Progress
pub mut:
	idx int
}

pub fn new_binary_input_stream(buffer []byte, mut progress misc.Progress) &BinaryInputStream {
	progress.init(buffer.len - 1)
	return &BinaryInputStream{
		buffer: buffer
		progress: progress
		idx: 0
	}
}

pub fn (mut bis BinaryInputStream) read_int() int {
	return int(binary.big_endian_u32(bis.read_bytes(sizeof(int))))
}

pub fn (mut bis BinaryInputStream) read_ints(l u32) []int {
	bytes := bis.read_bytes(sizeof(int) * l)
	mut ints := []int{}
	for i in 0 .. l {
		offs := int(u32(i) * sizeof(int))
		b := bytes[offs..int(u32(offs) + sizeof(int))]
		ints << int(binary.big_endian_u32(b))
	}
	return ints
}

pub fn (mut bis BinaryInputStream) read_i8() i8 {
	return i8(bis.read_byte())
}

pub fn (mut bis BinaryInputStream) read_i8s(l u32) []i8 {
	bytes := bis.read_bytes(sizeof(i8) * l)
	mut i8s := []i8{}
	for i in 0 .. l {
		i8s << i8(bytes[i])
	}
	return i8s
}

pub fn (mut bis BinaryInputStream) read_i16() i16 {
	return i16(binary.big_endian_u16(bis.read_bytes(sizeof(i16))))
}

pub fn (mut bis BinaryInputStream) read_i16s(l u32) []i16 {
	bytes := bis.read_bytes(sizeof(i16) * l)
	mut i16s := []i16{}
	for i in 0 .. l {
		offs := int(u32(i) * sizeof(i16))
		b := bytes[offs..int(u32(offs) + sizeof(i16))]
		i16s << i16(binary.big_endian_u16(b))
	}
	return i16s
}

pub fn (mut bis BinaryInputStream) read_i64() i64 {
	return i64(binary.big_endian_u64(bis.read_bytes(sizeof(i64))))
}

pub fn (mut bis BinaryInputStream) read_i64s(l u32) []i64 {
	bytes := bis.read_bytes(sizeof(i64) * l)
	mut i64s := []i64{}
	for i in 0 .. l {
		offs := int(u32(i) * sizeof(i64))
		b := bytes[offs..int(u32(offs) + sizeof(i64))]
		i64s << i64(binary.big_endian_u64(b))
	}
	return i64s
}

pub fn (mut bis BinaryInputStream) read_byte() byte {
	defer {
		if bis.idx < bis.buffer.len - 1 {
			bis.idx++
			bis.progress.update()
		}
	}
	return bis.buffer[bis.idx]
}

pub fn (mut bis BinaryInputStream) read_bytes(l u32) []byte {
	mut bytes := []byte{len: int(l), cap: int(l)}
	for i in 0 .. l {
		bytes[i] = bis.read_byte()
	}
	return bytes
}

pub fn (mut bis BinaryInputStream) read_u16() u16 {
	return binary.big_endian_u16(bis.read_bytes(sizeof(u16)))
}

pub fn (mut bis BinaryInputStream) read_u16s(l u32) []u16 {
	bytes := bis.read_bytes(sizeof(u16) * l)
	mut u16s := []u16{}
	for i in 0 .. l {
		offs := int(u32(i) * sizeof(u16))
		b := bytes[offs..int(u32(offs) + sizeof(u16))]
		u16s << binary.big_endian_u16(b)
	}
	return u16s
}

pub fn (mut bis BinaryInputStream) read_u32() u32 {
	return binary.big_endian_u32(bis.read_bytes(sizeof(u32)))
}

pub fn (mut bis BinaryInputStream) read_u32s(l u32) []u32 {
	bytes := bis.read_bytes(sizeof(u32) * l)
	mut u32s := []u32{}
	for i in 0 .. l {
		offs := int(u32(i) * sizeof(u32))
		b := bytes[offs..int(u32(offs) + sizeof(u32))]
		u32s << binary.big_endian_u32(b)
	}
	return u32s
}

pub fn (mut bis BinaryInputStream) read_u64() u64 {
	return binary.big_endian_u64(bis.read_bytes(sizeof(u64)))
}

pub fn (mut bis BinaryInputStream) read_u64s(l u32) []u64 {
	bytes := bis.read_bytes(sizeof(u64) * l)
	mut u64s := []u64{}
	for i in 0 .. l {
		offs := int(u32(i) * sizeof(u64))
		b := bytes[offs..int(u32(offs) + sizeof(u64))]
		u64s << binary.big_endian_u64(b)
	}
	return u64s
}

pub fn (mut bis BinaryInputStream) read_f32() f32 {
	bytes := bis.read_bytes(sizeof(f32))
	f := &f32(bytes.data)
	return *f
}

pub fn (mut bis BinaryInputStream) read_f32s(l u32) []f32 {
	bytes := bis.read_bytes(sizeof(f32) * l)
	mut f32s := []f32{}
	for i in 0 .. l {
		offs := int(u32(i) * sizeof(f32))
		b := bytes[offs..int(u32(offs) + sizeof(f32))]
		f := &f32(b.data)
		unsafe {
			f32s << *f
		}
	}
	return f32s
}

pub fn (mut bis BinaryInputStream) read_f64() f64 {
	bytes := bis.read_bytes(sizeof(f64))
	f := &f64(bytes.data)
	return *f
}

pub fn (mut bis BinaryInputStream) read_f64s(l u32) []f64 {
	bytes := bis.read_bytes(sizeof(f64) * l)
	mut f64s := []f64{}
	for i in 0 .. l {
		offs := int(u32(i) * sizeof(f64))
		b := bytes[offs..int(u32(offs) + sizeof(f64))]
		f := &f64(b.data)
		unsafe {
			f64s << *f
		}
	}
	return f64s
}

pub fn (mut bis BinaryInputStream) read_string(l u32) string {
	bytes := bis.read_bytes(l)
	return unsafe { tos(bytes.data, bytes.len) }
}

pub fn (mut bis BinaryInputStream) skip(l u32) {
	bis.read_bytes(l)
}

pub fn (mut bis BinaryInputStream) read_vec3() mathf.Vec3<f32> {
	data := bis.read_f32s(3)
	return mathf.vec3(data[0], data[1], data[2])
}

pub fn (mut bis BinaryInputStream) read_vec2() mathf.Vec2<f32> {
	data := bis.read_f32s(2)
	return mathf.vec2(data[0], data[1])
}
