// these probably need moving to more specific modules

type CommonType<T1, T2> = typeof(if true {rvalue!T1} else {rvalue!T2})

fn min(v1!, v2!)!
{
	return if v1 < v2 {v1} else {v2}
}
