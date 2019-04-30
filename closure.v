// int to int version
import intiter

// Returns a closure
fn (it mut IntIter) map_close(f fn(int)int) fn()?int
{
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
fn (it mut It!) map_close(f fn(IterElement<It>)R!) fn()?R
{
    return fn {
        e := it.next()?
        return f(e)
    }
}
