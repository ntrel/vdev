// iterator example that uses minimal features
// see iter.v for generic version

struct IntIter
{
    // these can be null but will never be read when null
    // so we can avoid using optional types
    ptr mut *int
    end *int
}
// this method needs to be in the Array<T> module
fn (arr []int) iter() IntIter
{
    unsafe {
        // Array<int>.ptr should be readable in unsafe code
        p := arr.ptr
        return {p, p + arr.len}
    }
}
fn (it mut IntIter) next() int?
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
    mut it := arr.iter()
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
    return {it, f}
}

fn square(i int) int
{
    return i * i
}

fn test_map()
{
    arr := [1,2,3]
    it := arr.iter()
    mut mi := it.map(square)
    assert mi.array() == [1,4,9]
    // calling next again still returns none
    assert mi.next() == none
}
