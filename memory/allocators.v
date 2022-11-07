module memory

[inline; unsafe]
pub fn alloc<T>(n_bytes u64) &T {
	sizeof_type := sizeof(T)
	return C.calloc(n_bytes, sizeof_type)
}

[inline; unsafe]
pub fn realloc<T>(ptr &T, new_size u64) &T {
	sizeof_type := sizeof(T)
	return C.realloc(ptr, sizeof_type * new_size)
}

[inline; unsafe]
pub fn copy<T>(ptr &T, bytes_offset u64, from &T, n u64) {
	sizeof_type := sizeof(T)
	C.memcpy(offset(ptr, bytes_offset), from, sizeof_type * n)
}

[inline; unsafe]
pub fn set<T>(ptr &T, bytes_offset u64, val T, n u64) {
	C.memset(offset(ptr, bytes_offset), val, n)
}
