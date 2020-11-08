= General

= Generic & functional programming

== Defining functions with an expression
```v
fn f(arg T) R {return expr}
fn f(arg T) R = expr
fn f(arg T) = expr // inferred return type
```

== Lambdas
Lambdas don't have statements, only a result expression.
Argument types and return type can be inferred:
```v
fn(arg) R {return expr} // anonymous fn
fn(arg) = expr // lambda

_ = arr.map(fn(e){return e * 2})
_ = arr.map(fn(e) = e * 2) // less noisy
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

