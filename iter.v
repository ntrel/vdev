// See intiter.v for non-generic code

struct ArrayIter<T>
{
    // these can be null but will never be read when null
    // so we can avoid using optional types
    ptr mut *T
    end *T
}
// arr is an array of generic type T, which iter<T> is inferred for
fn (arr []T!) iter() ArrayIter<T>
{
    unsafe {
        // Array<int>.ptr should be readable in unsafe code
        p := arr.ptr
        return {p, p + arr.len}
    }
}
fn (it mut ArrayIter<T!>) next() T?
{
    if it.ptr == it.end {return error()}
    e := *it.ptr
    unsafe {
        it.ptr++
    }
    return e
}

fn test_iter()
{
	arr := [1,2,3]
	mut it := arr.iter()
	// next returns an optional value
	e := it.next() or {0}
	assert e == 1
}

import util
// correct way to find element type, doesn't rely on Iter type arguments
/// Element type of Iter
type IterElement<Iter> = typeof(rvalue<Iter>().next().unwrap())

// array<Iter> is inferred from `it`
fn (it mut Iter!) array() []IterElement<Iter>
{
    // TODO pre-allocate [;it.len()] if len defined?
    mut a := []IterElement<Iter>
    for e := it.next()
    {
        a << e
    }
    return a
}

fn test_array()
{
    arr := [1,2,3]
    mut it := arr.iter()
    assert it.array() == arr
    assert it.next() == none
}

// iterator for lazy map
struct Map<T,R>
{
    it mut It<T>
    f fn(T)R
}
fn (it mut Map<T!,R!>) next() T?
{
    e := it.next()?
    return it.f(e)
}
// Returns an iterator
fn (it mut It<T!>) map(f fn(T)R!) Map<T,R>
{
    return {it, f}
}

fn test_map()
{
    arr := [1,2,3]
    mut it := arr.iter()
    mut mi := it.map(fn i {i * i})
    assert mi.array() == [1,4,9]
    assert mi.next() == none
}

// both iterators need to be mutable, so we need a tuple method
fn (i1 mut I1!, i2 mut I2!) equal() bool
{
	for
	{
		e := i1.next()
		if e != i2.next() {return false}
		if e == none {return true}
	}
}

fn test_equal()
{
	a := [1,2,3]
	mut it := a.iter()
	assert (it, a.iter()).equal()
	assert it.next() == none
}
