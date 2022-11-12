module alloc

import memory

pub struct Box<T> {
	ptr &T
}

pub fn new_box<T>(value T) Box<T> {
	return Box<T>{
		ptr: &value
	}
}

pub fn new_box_uninit<T>() Box<T> {
	return Box<T>{
		ptr: unsafe { memory.alloc<T>(1) }
	}
}

[unsafe]
pub fn box_write<T>(b Box<T>, value T) {
	unsafe {
		memory.copy(b.ptr, &value, 1)
		free(&value)
	}
}

pub fn (b Box<T>) deref() &T {
	return b.ptr
}

pub fn (b Box<T>) clone() Box<T> {
	box := new_box_uninit<T>()
	unsafe {
		box_write(box, *b.deref())
	}
	return box
}
