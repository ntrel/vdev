= General

= Generic & functional programming

== Expression function definitions & Lambdas
Lambdas don't contain statements, only an expression.
Argument types and return type are inferred:
```v
fn named(a){return expr}
fn (arg1){return expr} // anonymous fn
fn named(a) = expr
fn (arg1) = expr // lambda

_ = arr.map(fn(e){return e * 2})
_ = arr.map(fn(e) = e * 2)
_ = arr.sort(fn(a, b) = a < b)
```

== Inlining lambdas
Inlining functions that take lambdas allows the lambda to also be inlined,
so there are no function calls.
```v
[inline]
fn count(iter Iterable<E>, fn(E)bool) isize
[inline]
fn map(iter Iterable<E>, fn(E)R) Iterable<R>
```

== Pipeline fn calls
The above generic algorithms that work on any container cannot be methods.
Yet method call syntax reads better. With the `->` pipeline operator,
argument order is the same as methods. This avoids hard to read nested
function calls:

```v
iter := container.iter()
odd := count(map(iter, e => e.int()), e => e & 1) // huh?
odd := iter->map(e => e.int())->count(e => e & 1) // ok
```

