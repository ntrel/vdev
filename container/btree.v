// `Node` redeclared error -> Tree
struct Tree {
	mut:
	left *Tree //?*Tree
	right *Tree
	item int
}

// only supports sorted `arr` ATM
fn (cur mut Tree) add(arr []int) {
	mid := arr.len / 2
	cur.item = arr[mid]
	println(cur.item)
	mut n := &Tree{}
	if mid == 0 {return}
	n.add(arr.right(mid + 1))
	cur.right = n
	n = &Tree{}
	n.add(arr.left(mid))
	cur.left = n
}

fn empty(cur *Tree) bool {
	return isnil(voidptr(cur))
}

fn (cur Tree) print() {
	if !empty(cur.left) {cur.left.print()}
	println(cur.item)
	if !empty(cur.right) {cur.right.print()}
}

fn main() {
	mut n := Tree{}
	n.add([1,2,6,7,8,17,19])
	println('ordered:')
	n.print()
}
