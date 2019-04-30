import iter

fn test_for()
{
	arr := [1,2,3]
	// calls Iter<int>.next(), unwrapping result until none
	for e in arr.iter()
	{
	    println(e)
	}
	mut it := arr.iter()
	for i in Counter(1, 4)
	{
	    assert i == it.next()
	}
}

struct Counter
{
	start mut usize
	end usize
}
fn (c mut Counter) next() ?usize
{
	r := c.start
	if r == c.end {return none}
	c.start++
	return r
}

fn test_enumerate()
{
	arr := [1,2,3]
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
