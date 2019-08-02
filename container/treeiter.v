import btree

fn (tree Node) iter() {
	mut n := tree
	mut prev := []Node
	for !n.left.empty() {
		prev << n
		n = n.left
	}
	return TreeIter{prev, n}
}

struct TreeIter {
	mut:
	prev []Node
	cur Node
}

fn last(a []int) int {return a[a.len - 1]}
fn drop(a mut []int, n int) {a = a.left(a.len - n)}

pub fn (it TreeIter) next() {
	e := it.cur.data
	if it.prev.len == 0 {return e}
	mut n := last(it.prev)
	if it.cur == n.left {
		n = n.right
		// TODO recurse down
	} else {
		drop(it.prev, 1)
	}
	it.cur = n
	return e
}
