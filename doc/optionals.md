# Efficient optional values

```v
struct Option<T> {
    val T
    bool ok
}

struct Error {
    message string
    code    int
}

__global __err Error
```

`return error(` sets `__err` and returns `Option<T>{}`

`or` *statement* example:
```v
fn f() ?int {
    return error('message' + 4.str())
}

x = f() or {panic(err)}
```

Equivalent:
```v
tmp := f()
if !tmp.ok {
    err := __err
    panic(err)
}
x = tmp.val
```

`or` *expression* example:
```v
fn g() int

g(f() or {err.len}) // error, no symbol `err`
```

C gen:
```c
Option_int tmp;
g(tmp = f(), tmp.ok ? tmp.val : err.len);
```

We can assign to `tmp`, but we can't declare a variable `err` inside an 
expression in C99. If we declare `err` before the call to `g` then it 
could be accessed outside of the `or` expression, and could conflict if 
there are nested `or` expressions.
