# Ideas

## mut
mut primitive type args
`__global` without command-line option


## references
references shouldn't be automatically dereferenced
```v
for mut e in arr {*e = v}
```


## features
* structured concurrency
* `sum ?is T` gives an optional
    - `if v := sum ?is T {
    - `v ?is Iface`
* lambdas
    - `fn(param T){expr}`
    - no statements, just an expression
    - return type inferrence
* enforced `[pure]` functions?


## syntax

### =>
if expr => expr else expr
match expr {T => expr else expr}
fn (p T) => expr

