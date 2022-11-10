module result

pub struct Success {}

const success_c = Success{}

pub type Attempt<E> = E | Success

pub fn (a Attempt<E>) str<E>() string {
	return if a is E {
		x := a as E
		'Fail($x)'
	} else {
		'Success'
	}
}

pub fn success<E>() Attempt<E> {
	return Attempt<E>(result.success_c)
}

pub fn fail<E>(v E) Attempt<E> {
	return Attempt<E>(v)
}

[inline]
pub fn (a Attempt<E>) is_success<E>() bool {
	return match a {
		Success { true }
		E { false }
	}
}

[inline]
pub fn (a Attempt<E>) is_fail<E>() bool {
	return match a {
		Success { false }
		E { true }
	}
}

[inline]
pub fn (a Attempt<E>) unwrap<E>() {
	if a is E {
		panic('the action fail with the explanation $a')
	}
}

[inline]
pub fn (a Attempt<E>) unwrap_fail<E>() E {
	if a is E {
		return a
	}
	panic('the action success')
}

/// Boolean operators
[inline]
pub fn (a Attempt<E>) and<E>(a2 Attempt<E>) Attempt<E> {
	return match a {
		Success { a2 }
		E { a }
	}
}

[inline]
pub fn (a Attempt<E>) and_then<E>(f fn () Attempt<E>) Attempt<E> {
	return match a {
		Success { f() }
		E { a }
	}
}

[inline]
pub fn (a Attempt<E>) @or<E>(a2 Attempt<E>) Attempt<E> {
	return match a {
		Success { result.success_c }
		E { a2 }
	}
}

[inline]
pub fn (a Attempt<E>) or_else<E>(f fn (v E) Attempt<E>) Attempt<E> {
	return match a {
		Success { result.success_c }
		E { f(a) }
	}
}

/// Utils methods
[inline]
pub fn (a Attempt<E>) native<E>() ! {
	if a is Err<E> {
		error('Fail($a)')
	}
}

[inline]
pub fn (a Attempt<E>) inspect<E>(f fn ()) Attempt<E> {
	if a is Success {
		f()
	}
	return a
}

[inline]
pub fn (a Attempt<E>) clone<E>() Attempt<E> {
	return match a {
		Success {
			result.success_c
		}
		E {
			// this unsafe block is to allow the cloning of the value without mutability
			mut ref := unsafe { &a }
			fail<E>(*ref)
		}
	}
}

[inline; unsafe]
pub fn (mut a Attempt<E>) redefine<E>(new_attempt Attempt<E>) {
	a = new_attempt.clone()
}
