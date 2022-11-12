module memory

import math

[inline; unsafe]
pub fn alloc<T>(n_bytes u32) &T {
	unsafe {
		return C.calloc(n_bytes, sizeof(T))
	}
}

[inline; unsafe]
pub fn realloc<T>(ptr &T, new_size u32) &T {
	unsafe {
		return C.realloc(ptr, sizeof(T) * new_size)
	}
}

[inline; unsafe]
pub fn move<T>(from &T, to &T, n u32) {
	unsafe {
		C.memmove(to, from, sizeof(T) * n)
	}
}

[inline; unsafe]
pub fn copy<T>(ptr &T, from &T, n u32) {
	unsafe {
		C.memcpy(ptr, from, sizeof(T) * n)
	}
}

[inline; unsafe]
pub fn set<T>(ptr &T, val u8, n u32) {
	unsafe {
		C.memset(ptr, val, n)
	}
}

[inline; unsafe]
pub fn uninit<T>(ptr &T, len u32) {
	unsafe {
		C.memset(ptr, 0, sizeof(T) * math.max(len, 1))
	}
}

[inline; unsafe]
pub fn zeroed<T>() T {
	unsafe {
		return *alloc<T>(1)
	}
}
