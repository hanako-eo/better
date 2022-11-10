module result

pub struct Ok<T> {
	v &T
}

pub struct Err<E> {
	v &E
}

fn (ok Ok<T>) str() string {
	return 'Ok(${*ok.v})'
}

fn (err Err<T>) str() string {
	return 'Err(${*err.v})'
}

pub type Result<T, E> = Err<E> | Ok<T>

pub fn (r Result<T, E>) str<T, E>() string {
	return match r {
		Ok<T> { r.str() }
		Err<E> { r.str() }
	}
}

pub fn ok<T, E>(v T) Result<T, E> {
	return Result<T, E>(Ok<T>{
		v: &v
	})
}

pub fn err<T, E>(e E) Result<T, E> {
	return Result<T, E>(Err<E>{
		v: &e
	})
}

[inline]
pub fn (r Result<T, E>) is_ok<T, E>() bool {
	return match r {
		Ok<T> { true }
		Err<E> { false }
	}
}

[inline]
pub fn (r Result<T, E>) is_err<T, E>() bool {
	return match r {
		Ok<T> { false }
		Err<E> { true }
	}
}

[inline]
pub fn (r Result<T, E>) unwrap<T, E>() T {
	if r is Ok<T> {
		return *r.v
	}
	err := r as Err<E>
	panic("can't unwrap Err(${*err.v}) value")
}

[inline]
pub fn (r Result<T, E>) unwrap_or<T, E>(default T) T {
	return match r {
		Ok<T> { *r.v }
		Err<E> { default }
	}
}

[inline]
pub fn (r Result<T, E>) unwrap_err<T, E>() E {
	if r is Err<E> {
		return *r.v
	}
	ok := r as Ok<T>
	panic("can't unwrap Ok(${*ok.v}) value")
}

[inline]
pub fn (r Result<T, E>) unwrap_err_or<T, E>(default E) E {
	return match r {
		Ok<T> { default }
		Err<E> { *r.v }
	}
}

/// Boolean operators
[inline]
pub fn (r Result<T, E>) and<T, E>(r2 Result<T, E>) Result<T, E> {
	return match r {
		Err<E> { r }
		else { r2 }
	}
}

[inline]
pub fn (r Result<T, E>) and_then<T, E>(f fn (v T) Result<T, E>) Result<T, E> {
	return match r {
		Ok<T> { f(*r.v) }
		else { r }
	}
}

[inline]
pub fn (r Result<T, E>) @or<T, E>(r2 Result<T, E>) Result<T, E> {
	return match r {
		Ok<T> { r }
		else { r2 }
	}
}

[inline]
pub fn (r Result<T, E>) or_else<T, E>(f fn (v E) Result<T, E>) Result<T, E> {
	return match r {
		Err<E> { f(*r.v) }
		else { r }
	}
}

/// Modifier operations
// wait a correction of this issue https://github.com/vlang/v/issues/16340
// [inline]
// pub fn (r Result<T, E>) map<T, E, U>(f fn (v T) U) Result<U, E> {
// 	return match r {
// 		Ok<T> { ok<U, E>(f(*r.v)) }
// 		else { r }
// 	}
// }

// [inline]
// pub fn (r Result<T, E>) map_err<T, E, F>(f fn (v E) F) Result<T, F> {
// 	return match r {
// 		Err<E> { err<T, F>(f(*r.v)) }
// 		else { r }
// 	}
// }

/// Utils methods
[inline]
pub fn (r Result<T, E>) native<T, E>() !T {
	return match r {
		Ok<T> { r }
		Err<E> { error('Err(${*r.v})') }
	}
}

// [inline]
// pub fn (r Result<&T, E>) clone<T, E>() Result<T, E> {
// 	return match r {
// 		Ok<&T> { ok<&T, E>(*(*r.v as &T)) }
// 		else { r }
// 	}
// }

// [inline]
// pub fn (r &Result<T, E>) as_ref<T, E>() Result<&T, &E> {
// 	return match r {
// 		Ok<T> { ok<&T, &E>(r.v) }
// 		Err<E> { err<&T, &E>(r.v) }
// 	}
// }

[inline; unsafe]
pub fn (mut r Result<T, E>) redefine<T, E>(new_result Result<T, E>) {
	r = new_result //.clone()
}

[inline; unsafe]
pub fn (mut r Result<T, E>) replace<T, E>(new_value T) {
	r = ok<T, E>(new_value)
}
