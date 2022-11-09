module alloc

import memory
import option { Maybe, noth, some }

interface Any {}

pub struct Tuple {
mut:
	data &Any
pub:
	len u32
}

pub fn make_tuple(args ...Any) Tuple {
	mut tuple := Tuple{
		data: unsafe { memory.alloc<Any>(u64(args.len - 1)) }
		len: u32(args.len)
	}

	for i, arg in args {
		unsafe {
			tuple.data[i] = &arg
		}
	}

	return tuple
}

pub fn (t Tuple) get<T>(i u32) Maybe<T> {
	if i >= t.len {
		return noth<T>()
	}

	value := *memory.offset(t.data, i)
	if value is T {
		return some<T>(value)
	}
	return noth<T>()
}

pub fn (t Tuple) is_type<T>(i u32) bool {
	return t.get<T>(i).is_some()
}

pub fn (mut t Tuple) pick<T>(mut x T, i u32) {
	x = t.get(i).unwrap_default()
}
