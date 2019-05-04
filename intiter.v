// iterator example
// uses minimal features aiming to compile soon
// see iter.v for generic version

struct IntIter
{
    // Note: iter.v uses pointers
    slice mut []int
}
// this would be a method in the Array<T> module
//fn (arr []int) iter() IntIter
fn iter(arr []int) IntIter
{
    return IntIter{slice:arr}
}
fn (it mut IntIter) next() int?
{
    s := it.slice
    if !s.len {return none}
    e := s[0]
    it.slice = s[1:]
    return e
}

fn test_iter()
{
    arr := [1,2,3]
    mut it := iter(arr)
    // next returns an optional value
    e := it.next() or {0}
    assert e == 1
}

/// Create an array from an iterator
fn (it IntIter) array() []int
{
    // TODO pre-allocate [;it.len()] if len defined?
    mut a := []int
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
    it := iter(arr)
    assert it.array() == arr
}

fn (iter IntIter) find(element int) IntIter
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
    it := iter([1,2,3])
    assert it.find(7).array() == int[]
    assert it.find(2).array() == arr[1:]
}

// iterator for lazy map
struct Map
{
    it mut IntIter
    f fn(int)int
}
fn (it mut Map) next() int?
{
    e := it.next()?
    return it.f(e)
}
// Returns an iterator
fn (it IntIter) map(f fn(int)int) Map
{
    return Map{it, f}
}

fn square(i int) int
{
    return i * i
}

fn test_map()
{
    arr := [1,2,3]
    it := iter(arr)
    mut mi := it.map(square)
    assert mi.array() == [1,4,9]
    assert mi.next() == none
}

/// Check if two iterators have equal elements
fn equal(i1, i2 IntIter) bool
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
	it := iter(a)
	assert equal(it, iter(a))
	assert !equal(it, iter([1,2]))
}
