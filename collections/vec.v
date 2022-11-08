module collections

import math
import memory
import option { Maybe, noth, some }
import result { Result, err, ok }

pub enum VecError {
	out_of_range
}

pub struct Vec<T> {
pub mut:
	data &T
	len  u32
	cap  u32
}

pub fn new_vector<T>() Vec<T> {
	return new_vector_with_cap<T>(0)
}

pub fn new_vector_with_cap<T>(cap u32) Vec<T> {
	unsafe {
		return Vec<T>{
			data: memory.alloc<T>(cap)
			len: 0
			cap: cap
		}
	}
}

fn (mut v Vec<T>) resize() {
	if v.cap == 0 {
		v.cap = 1
	}
	v.cap *= 2
	unsafe {
		v.data = memory.realloc<T>(v.data, v.cap)
	}
}

pub fn (mut v Vec<T>) unshift(item T) u32 {
	return v.insert(0, item)
}

pub fn (mut v Vec<T>) shift() Maybe<T> {
	first := v.get(0)
	if v.len > 0 {
		v.len--
	}
	unsafe {
		memory.move<T>(memory.offset<T>(v.data, 1), v.data, v.len)
	}
	return first
}

pub fn (mut v Vec<T>) push(item T) u32 {
	return v.insert(v.len, item)
}

pub fn (mut v Vec<T>) pop() Maybe<T> {
	last := v.get(v.len - 1)
	if v.len > 0 {
		v.len--
	}
	return last
}

pub fn (v Vec<T>) get(i u32) Maybe<T> {
	if i >= v.len {
		return noth<T>()
	}
	unsafe {
		return some<T>(*memory.offset<T>(v.data, i))
	}
}

pub fn (mut v Vec<T>) insert(i u32, val T) u32 {
	if v.len == v.cap {
		v.resize()
	}
	unsafe {
		memory.move<T>(memory.offset<T>(v.data, i), memory.offset<T>(v.data, i + 1), v.len - i)
	}
	v.len++
	v.set(i, val)
	return i
}

pub fn (mut v Vec<T>) set(i u32, val T) Result<u8, VecError> {
	if i >= v.len {
		return err<u8, VecError>(VecError.out_of_range)
	}
	unsafe {
		memory.copy<T>(memory.offset<T>(v.data, i), &val, 1)
	}
	return ok<u8, VecError>(0)
}

pub fn (v Vec<T>) slice(params SliceParams) Slice<T> {
	end := if params.end == 0 {
		v.len
	} else {
		math.min(v.len, params.end)
	}

	return Slice<T>{
		data: memory.offset(v.data, params.start)
		len: end - params.start
	}
}

pub fn (v Vec<T>) iter() Iter<T> {
	return from_iterable<T>(v)
}

fn (v &Vec<T>) free() {
	unsafe {
		free(v.data)
		free(v)
	}
}
