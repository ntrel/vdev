struct ArrayIterMut<E> {
    arr []E
}

// arr is an array of generic type E
fn (arr []E) iter_mut() ArrayIterMut<E>
{
    return ArrayIterMut<E>{arr}
}

// iterate each pointer to element
fn (mut it ArrayIterMut<E>) next() &E?
{
    if arr.len == 0 {return none}
    e := &arr[0]
    arr = arr[1..]
    return e
}

fn (it ArrayIterMut<E>) each(f fn(&E))
{
    mut mi := it
    for {
        ptr := mi.next() or {break}
        f(ptr)
    }
}

fn test_iter()
{
    it := [1,2,3].iter_mut()
    it.each(fn(p &int){(*p)++})
    assert(it.arr == [2,3,4])
    it.each(fn(p &int){println(*p)})
}
