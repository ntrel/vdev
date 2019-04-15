import intiter

// Returns a closure
fn (it mut IntIter) map_close(f fn(int)int) fn()int?
{
    return fn {
        e := it.next()?
        return f(e)
    }
}

arr := [1,2,3]
mut it := arr.iter();
f := it.map_close(fn i -> i * i)
// print 149
for e := f()
{
    print(e)
}

//// Generic version
import iter

// Returns a closure
fn (it mut It<T!>) map_close(f fn(T)R!) fn()R?
{
    return fn {
        e := it.next()?
        return f(e)
    }
}

arr := [1,2,3]
mut it := arr.iter();
f := it.map_close(fn i -> i * i)
// print 149
for e := f()
{
    print(e)
}

