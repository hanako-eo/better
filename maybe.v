module main

pub struct Noth {}

pub type Maybe<T> = Noth | T

// wait a correction of this issue https://github.com/vlang/v/issues/16340
// pub fn (m Maybe<T>) str<T>() string {
// 	return if m is T {
// 		x := m as T
// 		'Some($x)'
// 	} else {
// 		'Noth'
// 	}
// }

pub fn some<T>(v T) Maybe<T> {
	return Maybe<T>(v)
}

pub fn noth<T>() Maybe<T> {
	return Maybe<T>(Noth{})
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
		Noth { Noth{} }
		T { m2 }
	}
}

[inline]
pub fn (m Maybe<T>) and_then<T>(f fn (v T) Maybe<T>) Maybe<T> {
	return match m {
		Noth { Noth{} }
		T { f(m) }
	}
}

[inline]
pub fn (m Maybe<T>) @or<T>(m2 Maybe<T>) Maybe<T> {
	return match m {
		Noth {
			match m2 {
				Noth { Noth{} }
				T { m2 }
			}
		}
		T {
			m
		}
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
		return Noth{}
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
			return Noth{}
		}
		T {
			if !predicate(m) {
				return Noth{}
			}
			return some<T>(m)
		}
	}
}

/// Utils methods
[inline]
pub fn (m Maybe<T>) clone<T>() Maybe<T> {
	return match m {
		Noth {
			Noth{}
		}
		T {
			// this unsafe block is to allow the cloning of the value without mutability
			mut ref := unsafe { &m }
			some<T>(*ref)
		}
	}
}

[inline]
pub fn (m Maybe<T>) as_ref<T>() Maybe<T> {
	return match m {
		Noth {
			Noth{}
		}
		T {
			mut ref := unsafe { &m }
			some<&T>(ref)
		}
	}
}
