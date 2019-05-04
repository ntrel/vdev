// int to int version
import intiter

// Returns a closure
fn (iter IntIter) map_close(f fn(int)int) fn()?int
{
    mut it := iter
    return fn {
        e := it.next()?
        return f(e)
    }
}

fn test_map()
{
    arr := [1,2,3]
    mut it := arr.iter();
    f := it.map_close(fn i {i * i})
    // print 149
    for
    {
        e := f() or {break}
        print(e)
    }
}

//// Generic version
import iter

// Returns a closure
fn (iter It!) map_close(f fn(IterElement<It>)R!) fn()?R
{
    mut it := iter
    return fn {
        e := it.next()?
        return f(e)
    }
}
