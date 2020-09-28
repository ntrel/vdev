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
mut:
	cap  int
	data [0]byte // variable size
}

[inline] [unsafe]
fn new_array_alloc(cap, elem_size int) voidptr {
	ptr := malloc(int(sizeof(int)) + cap * elem_size)
	mut aa := &ArrayAlloc(ptr)
	aa.cap = cap
	return voidptr(&aa.data[0])
}

fn new_array(len, cap, elem_size int) Array {
	cap_ := if cap < len { len } else { cap }
	data := new_array_alloc(cap_, elem_size)
	unsafe {C.memset(data, 0, len * elem_size)}
	arr := Array{
		element_size: elem_size
		data: data
		len: len
		start: data
	}
	return arr
}

[inline]
fn (a Array) cap() int {
	if a.start != a.data {
		return a.len
	}
	alloc := &ArrayAlloc(unsafe {a.start - sizeof(ArrayAlloc)})
	return alloc.cap
}

fn main() {
	a := new_array(2, 4, 1)
	//~ println(a.set_unsafe(0, 10))
	//~ assert a.get_unsafe(0) == 10
	//~ assert a.get_unsafe(1) == 0
	//~ println(a.get_unsafe(1))
	println(&byte(a.data)[0])
	println(&byte(a.data)[3])
	println(a.cap())
	assert a.cap() == &int(a.data)[-1]
	
	b := new_array(2, 0, 1)
	assert b.cap() == 2
}
