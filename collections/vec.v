module collections

import math
import memory
import option { Maybe, noth, some }
import result { Attempt, fail, success }

pub enum VecError {
	out_of_range
}

pub struct Vec<T> {
pub mut:
	data &T
	len  u32
	cap  u32
}

pub fn (v Vec<T>) str() string {
	return str_iter<T>(v, 'Vec<${typeof(*v.data).name}>{', '}')
}

pub fn new_vector<T>(args... T) Vec<T> {
	mut vec := new_vector_with_cap<T>(u32(args.len))
	for arg in args {
		vec.push(arg)
	}
	return vec
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

pub fn (mut v Vec<T>) set(i u32, val T) Attempt<VecError> {
	if i >= v.len {
		return fail<VecError>(VecError.out_of_range)
	}
	unsafe {
		memory.copy<T>(memory.offset<T>(v.data, i), &val, 1)
	}
	return success<VecError>()
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
