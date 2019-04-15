/*
arr := [1,2,3]
mut it := arr.iter()
// next returns an optional value, loop while there's a value e
for e := it.next()
{
    println(e)
}
// same as above but with i counting from 0 to arr.len
for i,e in arr.iter()
{
    assert e == arr[i]
}
*/

struct IntIter
{
    ptr mut *int
    end *int
}
fn (arr []T) iter() IntIter
{
    p := &arr[0]
    return {p, p + arr.len}
}
fn (it mut IntIter) next() int?
{
    if it.ptr == it.end {return error()}
    e := *it.ptr
    it.ptr += 1
    return e
}

fn (it mut IntIter) array() []int
{
    // TODO pre-allocate [;it.len] if len defined?
    mut a := []int
    for e := it.next()
    {
        a << e
    }
    return a
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
fn (it mut IntIter) map(f fn(int)int) Map
{
    return {it, f}
}

fn square(i int) int
{
    return i * i
}

fn main()
{
    arr := [1,2,3]
    mut it := arr.iter();
    mit := it.map(square)
    // print 149
    for e := mit.next()
    {
        print(e)
    }
    assert arr.iter().map(square).array() == [1,4,9]
}
