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
pub fn move<T>(from &T, to &T, n u64) {
	sizeof_type := sizeof(T)
	C.memmove(to, from, sizeof_type * n)
}

[inline; unsafe]
pub fn copy<T>(ptr &T, from &T, n u64) {
	sizeof_type := sizeof(T)
	C.memcpy(ptr, from, sizeof_type * n)
}

[inline; unsafe]
pub fn set<T>(ptr &T, val T, n u64) {
	C.memset(ptr, val, n)
}