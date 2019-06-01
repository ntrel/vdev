Mutability
===
For basic types like int, mutability doesn't cause type mismatches.
Each variable is only mutable if declared with `mut`.
I'll write the type of each declaration in comments: 
```rust
x := 5	// int
x += 1	// error, x is not mutable
// copy x
mut y := x	// mut int
y += 1	// OK
assert x == 5
assert y == 6
z := y	// int
z += 1	// error, z is not mutable
```
With pointers, things get more complicated:
```rust
x := 5		// int
mut y := 6	// mut int
p := &x	// *int
q := &y	// *mut int
```
Above p and q are immutable pointers, but `*q` is mutable. 
```rust
q = p	// error, q is immutable
*p = 6	// error, cannot mutate *p of type int
*q = 7	// OK
assert y == 7
```
Dereferencing a pointer must never allow mutation of data that is 
immutable.

Reassigning pointers
---
Here we declare q as mutable so it can be reassigned:
```rust
x := 5		// int
mut y := 6	// mut int
mut q := &y // mut*mut int
q = &x	// error, *q is `mut int` not `int`
*q = 7
```
V cannot allow the assignment of q from `&x`, otherwise the following 
line will set x to 7, and x is immutable.

Pointers either point to mutable OR immutable data
--- 
Another issue is protecting the meaning of immutable as data that will 
never change: 
```rust
x := 5		// int
mut y := 6	// mut int
mut p := &x	// mut*int
p = &y	// error, *p is `int` not `mut int`
```
`*p` is immutable, assigning `&y` to p would mean that `*p` can change 
if y is reassigned. V has to prevent this because immutable data can be 
freely shared across threads. If `*p` changed when being accessed by
several threads at once, there would be a low-level data race. So
immutability must be enforced here also.

A secondary benefit of disallowing `p = &y` is that the optimizer can 
safely assume that unless p itself changes, reading `*p` will never change, 
so it only needs to be read once, whatever other operations occur.
