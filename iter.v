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

struct ArrayIter<T>
{
    ptr mut *T
    end *T
}
// arr is an array of generic type T, which iter<T> is inferred for
fn (arr []T!) iter() ArrayIter<T>
{
    p := &arr[0]
    return {p, p + arr.len}
}
fn (it mut ArrayIter<T!>) next() T?
{
    if it.ptr == it.end {return error()}
    e := *it.ptr
    it.ptr += 1
    return e
}

// these functions don't need a body, they're for use with typeof
/// get an instance of T
fn rvalue<T>() T;
/// get the value type from an optional
fn (optional T!?) unwrap() T;
/// Element type of Iter
type IterElement<Iter> = typeof(rvalue<Iter>.next().unwrap())

// array<Iter> is inferred from `it`
fn (it mut Iter!) array() []IterElement<Iter>
{
    // TODO pre-allocate [;it.len] if len defined?
    mut a := []IterElement<Iter>
    for e := it.next()
    {
        a << e
    }
    return a
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

arr := [1,2,3]
mut it := arr.iter();
mit := it.map(fn i! * i)
// print 149
for e := mit.next()
{
    print(e)
}
assert arr.iter().map(fn i! * i).array() == [1,4,9]
