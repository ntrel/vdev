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
    // temporary result of iter() is inferred as mutable
    assert arr.iter().next() == 1
}

interface Iterable<Element>
{
	next() ?Element
}

// type template
type IterElement<Iterable<E!>> = E

/// Create an array from an iterator
// 1 type parameter: type(iter), must convert to Iterable
// E inferred from type(iter).next()
// E is not a type parameter of array()
fn array(iter! : Iterable<E!>) []E
{
    // TODO pre-allocate [;it.len()] if len defined?
    mut a := []E
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
    // Uniform Function Call Syntax
    assert it.array() == arr
}

/// Gets the next element without mutating `iter`
fn elem(iter! : Iterable<E!>) ?E
{
    mut it := iter
    return it.next()
}

/// Returns `iter` advanced to the first occurrence of `element`
fn find(iter It! : Iterable<E!>, element E) It
{
    for it := iter;; it.next()
    {
        e := it.elem() or {return it}
        if e == element {return it}
    }
}

fn test_find()
{
    it := [1,2,3].iter()
    // UFCS chaining
    assert it.find(7).array() == int[]
    assert it.find(2).array() == arr[1:]
}

// iterator for lazily evaluated map()
struct Map<It : Iterable<E!>, R>
{
    it mut It
    f fn(E)R
}
fn (it mut Map<It!, R!>) next() ?R
{
    e := it.next()?
    return it.f(e)
}
/// Returns an iterator
fn (it It! : Iterable<E!>) map(f fn(E)R!) Map<It, R>
{
    return {it, f}
}

/*
Inference of R is complicated:
Calling `ArrayIter<int>.map(fn i {i * i})`, we can partially
infer `map<ArrayIter<int>, R!>`, R not known yet.
Then f is a `fn(int)R!`.
Applying this to the lambda: `fn (int i) R! {i * i}`
R is type(i * i) = int
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
// <E> not needed for inference of Iterable
fn equal(i1! : Iterable, i2! : Iterable) bool
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
