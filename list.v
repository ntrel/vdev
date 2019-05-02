struct IntList
{
	data int
	next ?*IntList
}
fn prepend(l ?*IntList, e int) IntList
{
	return IntList{e, l}
}

fn test_list()
{
	n1 := prepend(none, 4)
	assert n1 == {4, none}
	n2 := prepend(&n1, 3)
	assert n2 == {3, &n1}
}

/// Generic linked list
struct List<E>
{
	data E
	next mut *List<E>
}
fn prepend(l ?*List<E!>, e E) List<E>
{
	return {e, l}
}
