module collections

import memory
import option { Maybe, noth, some }

[params]
pub struct SliceParams {
	start u32
	end u32
}

pub struct Slice<T> {
pub:
	data &T
	len u32
}

pub fn (s Slice<T>) get(i u32) Maybe<T> {
	if i >= s.len {
		return noth<T>()
	}
	unsafe {
		return some<T>(*memory.offset<T>(s.data, i))
	}
}

pub fn (s Slice<T>) iter() Iter<T> {
	return from_iterable<T>(s)
}

fn (s &Slice<T>) free() {
	unsafe {
		free(s)
	}
}
