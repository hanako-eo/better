module memory

import math

#define ptr_to_bytes(ptr) (char*)(&ptr)

fn C.ptr_to_bytes(voidptr) &u8

[inline; unsafe]
pub fn offset<T>(ptr &T, bytes_offset u64) &T {
	unsafe {
		return ptr + bytes_offset
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

pub fn default<T>() T {
	return T{}
}
