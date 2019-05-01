// iterator example that uses minimal features
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

fn (it mut IntIter) array() []int
{
    // TODO pre-allocate [;it.len()] if len defined?
    mut a := []int
    for e := it.next()
    {
        a << e
    }
    return a
}

fn test_array()
{
    arr := [1,2,3]
    mut it := iter(arr)
    assert it.array() == arr
    assert it.next() == none
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
    // calling next again still returns none
    assert mi.next() == none
}
