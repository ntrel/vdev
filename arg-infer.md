Generic function argument deduction
===
Imagine if `print` was a generic function:
```rust
fn print<T>(v T) {...}
...
print(5) // calls print<int>
print('hi') // calls print<string>
```
`T` is inferred from the type of the argument passed to `v`. Inferring the type of an argument is very common in generic code. This is a simple generic function, but others may have more complex parameters. It would be nice if we could leave out the `<T>` generic argument list:
```rust
fn print(v T) {...}
```
The problem with this is that T might be an actual type in scope, in which case `print` is non-generic. For a more complex example, https://vlang.io/docs#generics has a generic method:
```rust
fn (r Repo<T>) find_by_id(id int) T? {...}
```
This should really be:
```rust
fn (r Repo<T>) find_by_id<T>(id int) T? {...}
```
The 2nd function can basically be called:
```rust
repo := Repo<User>{}
opt := repo.find_by_id(5)
```
Notice that `find_by_id<User>` is inferred, because `repo` is of type `Repo<User>`.
For the 1st function, the problem with inferring `find_by_id<T>` from `r Repo<T>` is that T might already be a valid type name. So how does someone reading the signature know if the author meant T to be an existing type or an inferred generic type argument?

Inferred argument syntax
---
Instead, if we had syntax to mean 'infer the type of this argument' then it would be clear. I suggest `TypeName!`:
```rust
fn print(v T!) {...}
fn (r Repo<T!>) find_by_id(id int) T? {...}
```
Now the reader knows these are generic functions with an inferred argument T, not normal function signatures using an existing type T.
It's useful to easily see when an argument can be inferred - the `T!` syntax makes this obvious.

If the function doesn't need to refer to `T`, it could be allowed to infer the type just with `argument_name!` syntax:
```rust
fn print(v!) {...} // same
```
There are other potential use-cases for the `identifier!` inference syntax too (but these can wait).
