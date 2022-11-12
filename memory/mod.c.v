module memory

import math

#define ptr_sum(ptr, offset) ptr + offset
#define ptr_to_bytes(ptr) (char*)(&ptr)

fn C.ptr_sum(voidptr, u32) voidptr
fn C.ptr_to_bytes(voidptr) &u8

[inline; unsafe]
pub fn offset<T>(ptr &T, bytes_offset u32) &T {
	unsafe {
		return C.ptr_sum(ptr, bytes_offset)
	}
}

[inline; unsafe]
pub fn replace<T>(mut x T, y T) T {
	unsafe {
		temp := x
		x = y
		return temp
	}
}

[inline; unsafe]
pub fn swap<T>(mut x T, mut y T) {
	unsafe {
		temp := x
		x = y
		y = temp
	}
}

[inline; unsafe]
pub fn transmute<T, U>(from T) &U {
	sizeof_u := sizeof(U)
	to := C.calloc(1, sizeof_u)
	C.memcpy(to, C.ptr_to_bytes(from), math.min(sizeof(T), sizeof_u))
	return to
}

pub fn count<T>(ptr &T) u32 {
	mut data := &*ptr
	mut i := u32(0)
	for *data != 0 {
		data = offset(data, 1)
		i++
	}
	return i
}

pub fn size_of<T>(ptr &T) u32 {
	return sizeof(T) * count(ptr)
}

pub fn default<T>() T {
	return T{}
}
