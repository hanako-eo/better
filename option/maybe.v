module option

import memory

pub struct Noth {}

const noth_c = Noth{}

pub type Maybe<T> = Noth | T

pub fn (m Maybe<T>) str<T>() string {
	return if m is T {
		x := m as T
		'Some($x)'
	} else {
		'Noth'
	}
}

pub fn some<T>(v T) Maybe<T> {
	return Maybe<T>(v)
}

pub fn noth<T>() Maybe<T> {
	return Maybe<T>(option.noth_c)
}

[inline]
pub fn (m Maybe<T>) is_some<T>() bool {
	return match m {
		Noth { false }
		T { true }
	}
}

[inline]
pub fn (m Maybe<T>) is_noth<T>() bool {
	return match m {
		Noth { true }
		T { false }
	}
}

[inline]
pub fn (m Maybe<T>) unwrap<T>() T {
	if m is T {
		return m
	}
	panic("can't unwrap Noth value")
}

[inline]
pub fn (m Maybe<T>) unwrap_default<T>() T {
	if m is T {
		return m
	}
	return memory.default<T>()
}

[inline]
pub fn (m Maybe<T>) unwrap_or<T>(noth_value T) T {
	return match m {
		Noth { noth_value }
		T { m }
	}
}

/// Boolean operators
[inline]
pub fn (m Maybe<T>) and<T>(m2 Maybe<T>) Maybe<T> {
	return match m {
		Noth { option.noth_c }
		T { m2 }
	}
}

[inline]
pub fn (m Maybe<T>) and_then<T>(f fn (v T) Maybe<T>) Maybe<T> {
	return match m {
		Noth { option.noth_c }
		T { f(m) }
	}
}

[inline]
pub fn (m Maybe<T>) @or<T>(m2 Maybe<T>) Maybe<T> {
	return match m {
		Noth { m2 }
		T { m }
	}
}

[inline]
pub fn (m Maybe<T>) or_else<T>(f fn () Maybe<T>) Maybe<T> {
	return match m {
		Noth { f() }
		T { m }
	}
}

[inline]
pub fn (m Maybe<T>) xor<T>(m2 Maybe<T>) Maybe<T> {
	if (m is Noth && m2 is Noth) || (m is T && m2 is T) {
		return option.noth_c
	}
	if m2 is Noth {
		return m
	}
	return m2
}

/// Modifier operations
// wait a correction of this issue https://github.com/vlang/v/issues/16340
// [inline]
// pub fn (m Maybe<T>) map<T, U>(f fn (v T) U) Maybe<U> {
// 	return match m {
// 		Noth { noth<U>() }
// 		T {
// 	 		some<U>(f(m))
// 		}
// 	}
// }

[inline]
pub fn (m Maybe<T>) filter<T>(predicate fn (v T) bool) Maybe<T> {
	match m {
		Noth {
			return option.noth_c
		}
		T {
			if !predicate(m) {
				return option.noth_c
			}
			return some<T>(m)
		}
	}
}

/// Utils methods
pub fn (m Maybe<T>) native<T>() ?T {
	return match m {
		Noth { none }
		T { m }
	}
}

[inline]
pub fn (m Maybe<T>) clone<T>() Maybe<T> {
	return match m {
		Noth {
			option.noth_c
		}
		T {
			// this unsafe block is to allow the cloning of the value without mutability
			mut ref := unsafe { &m }
			some<T>(*ref)
		}
	}
}

// [inline]
// pub fn (m &Maybe<T>) as_ref<T>() Maybe<&T> {
// 	return match m {
// 		Noth {
// 			noth_c
// 		}
// 		T {
// 			mut ref := unsafe { &m }
// 			some<&T>(ref)
// 		}
// 	}
// }

pub fn (m Maybe<T>) inspect<T>(f fn (v T)) Maybe<T> {
	if m is T {
		f(m)
	}
	return m
}

[inline; unsafe]
pub fn (mut m Maybe<T>) redefine<T>(new_maybe Maybe<T>) {
	m = new_maybe.clone()
}

[inline; unsafe]
pub fn (mut m Maybe<T>) replace<T>(new_value T) {
	m = new_value
}
