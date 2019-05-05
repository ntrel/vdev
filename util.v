// these might need moving to more specific modules

type CommonType<T1, T2> = typeof(if true {rvalue!T1} else {rvalue!T2})

fn min(v1!, v2!)!
{
	return if v1 < v2 {v1} else {v2}
}

// these functions don't need a body, they're only for use in `type(expr)`
/// get an instance of T
fn rvalue<T>() T

// this method needs to be in the Optional<T> module
/// get the value type from an optional
fn (opt ?T!) unwrap() T
