struct Array
{
pub:
	element_size int
/*module*/ mut: // enforce only internal mutation, not public
	data  voidptr
	len   int
	start voidptr
}

// allocated on the heap
struct ArrayAlloc
{
	cap  int
	data [0]byte // variable size
}

[inline]
fn __new_array_alloc(cap, elem_size int) voidptr {
	ptr := malloc(sizeof(int) + cap * elem_size)
	aa := &ArrayAlloc(ptr)
	aa.cap = cap
	return &aa.data
}

fn __new_array(len, cap, elem_size int) Array {
	cap_ := if cap < mylen { mylen } else { cap }
	alloc = __new_array_alloc(cap_, elem_size)
	C.memset(alloc, 0, len * elem_size)
	arr := Array{
		element_size: elem_size
		data: &alloc.data
		len: len
		start: &alloc.data
	}
	return arr
}

[inline]
fn (a Array) cap() {
	if a.start != a.data {
		return a.len
	}
	alloc := &ArrayAlloc(a.start - sizeof(ArrayAlloc))
	return alloc.cap
}
