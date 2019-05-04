// See intiter.v for non-generic code

// E = Element type
struct ArrayIter<E>
{
    // these can be null but will never be read when null
    // so we can avoid using optional types
    ptr mut *E
    end *E
}
// arr is an array of generic type E
// this would be a method in the Array<E> module
fn (arr []E!) iter() ArrayIter<E>
{
    unsafe {
        // Array<int>.ptr should be readable in unsafe code
        p := arr.ptr
        // return struct inference
        return {p, p + arr.len}
    }
}
fn (it mut ArrayIter<E!>) next() E?
{
    if it.ptr == it.end {return none}
    e := *it.ptr
    unsafe {
        it.ptr++
    }
    return e
}

fn test_iter()
{
	arr := [1,2,3]
	// calls iter<int>
	mut it := arr.iter()
	// next<int> returns an optional int
	e := it.next() or {0}
	assert e == 1
}

import util
// correct way to find element type, doesn't rely on Iter type arguments
/// Element type of Iter
type IterElement<Iter> = typeof(rvalue<Iter>().next().unwrap())

/// Create an array from an iterator
fn (it Iter!) array() []IterElement<Iter>
{
    // TODO pre-allocate [;it.len()] if len defined?
    mut a := []IterElement<Iter>
    // `for` makes a mut copy of `it`
    for e in it
    {
        a << e
    }
    return a
}

fn test_array()
{
    arr := [1,2,3]
    it := arr.iter()
    // Calls array<ArrayIter>
    assert it.array() == arr
}

fn find(iter It!, element!) It
{
    mut it := iter
    for
    {
        e := it.next() or {return it}
        if e == element {return it}
    }
}

fn test_find()
{
    it := [1,2,3].iter()
    assert it.find(7).array() == int[]
    assert it.find(2).array() == arr[1:]
}

// iterator for lazy map
struct Map<It,R>
{
    it mut It
    f fn(IterElement<It>)R
}
fn (it mut Map<It!,R!>) next() ?R
{
    e := it.next()?
    return it.f(e)
}
/// Returns an iterator
fn (it It!) map(f fn(IterElement<It>)R!) Map<It,R>
{
    return {it, f}
}

/*
Inference of R is complicated:
Calling `ArrayIter<int>.map(fn i {i * i})`, we can partially
infer `map<ArrayIter<int>, R!>`, R not known yet.
Then f is a `fn(int)R!`.
Applying this to the lambda: `fn(int i)R! {i * i}`
R is typeof(i * i) = int
*/
fn test_map()
{
    arr := [1,2,3]
    it := arr.iter()
    // calls map<ArrayIter<int>, int>
    mut mi := it.map(fn i {i * i})
    assert mi.array() == [1,4,9]
    assert mi.next() == none
}

/// Check if two iterators have equal elements
fn equal(i1!, i2!) bool
{
	mut m1 = i1
	mut m2 = i2
	for
	{
		e := m1.next()
		if e != m2.next() {return false}
		if e == none {return true}
	}
}

fn test_equal()
{
	a := [1,2,3]
	it := a.iter()
	assert equal(it, a.iter())
	assert !equal(it, [1,2].iter())
}
