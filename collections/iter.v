module collections

import option { Maybe }

pub interface Iterable<T> {
	len u32
	get(i u32) Maybe<T>
}

pub fn str_iter<T>(iter Iterable<T>, prefix string, suffix string) string {
	mut str := prefix
	for x, i := iter.get(0), u32(1); x.is_some(); x = iter.get(i++) {
		str += '$x.unwrap()'
		if i < iter.len {
			str += ', '
		}
	}
	return str + suffix
}

[manualfree]
pub struct Iter<T> {
	iter Iterable<T>
mut:
	i u32
}

pub fn from_iterable<T>(iterable Iterable<T>) Iter<T> {
	return Iter<T>{
		iter: iterable
		i: 0
	}
}

fn (mut iterator Iter<T>) next() ?T {
	defer {
		iterator.i++
		if iterator.i == iterator.iter.len {
			unsafe { free(iterator) }
		}
	}
	return iterator.iter.get(iterator.i).native()
}
