module collections

import option { Maybe }

pub interface Iterable<T> {
	len u64
	get(i u64) Maybe<T>
}

pub struct Iter<T> {
	iter Iterable<T>
mut:
	index u64
}

pub fn from_iterable<T>(i Iterable<T>) Iter<T> {
	return Iter<T>{
		index: 0
		iter: i
	}
}

fn (mut i Iter<T>) next() ?T {
	defer {
		i.index++
		if i.index == i.iter.len {
			unsafe { free(i) }
		}
	}
	return i.iter.get(i.index).native()
}
