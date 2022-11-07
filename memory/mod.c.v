module memory

#define ptr_to_bytes(ptr) (char*)(&ptr)

fn C.ptr_to_bytes(voidptr) &u8

[inline]
fn min<T>(a T, b T) T {
	return if a < b { a } else { b }
}

[inline; unsafe]
pub fn offset<T>(ptr &T, bytes_offset u64) &T {
	return ptr + bytes_offset
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
	C.memcpy(to, C.ptr_to_bytes(from), min(sizeof(T), sizeof_u))
	return to
}
