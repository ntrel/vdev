import iter

fn test_for()
{
	arr := [1,2,3]
	mut it := arr.iter()
	// calls it.next(), unwrapping e until none
	for e in it
	{
	    println(e)
	}
	// built-in for on arrays
	for i,e in arr
	{
	    assert e == arr[i]
	}
	// possible generic equivalent:
	// EnumIter.next returns a tuple of element and index
	for i,e in arr.iter().enumerate()
	{
	    assert e == arr[i]
	}
}

struct EnumIter<It>
{
	it mut It
	i mut usize
}
fn (it It!) enumerate() EnumIter<It> {return {it, 0}}

fn (ei EnumIter<It!>) next() ?(usize, IterElement<It>)
{
	e := ei.next?
	i := ei.i
	ei.i++
	return i, e
}
