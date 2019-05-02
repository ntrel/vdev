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
	for i in count(1, 4)
	{
	    assert i == it.next()
	}
}

struct Counter
{
	cur mut usize
	end usize
}
fn (c mut Counter) next() ?usize
{
	r := c.cur
	if r == c.end {return none}
	c.cur++
	return r
}
fn count(start, end usize) Counter
{
	return {start, end}
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
	// EnumIter.next returns a tuple of index and element
	for i,e in enumerate(arr.iter())
	{
	    assert e == arr[i]
	}
}

struct EnumIter<It>
{
	it mut It
	i mut usize
}
fn enumerate(it It!) EnumIter<It> {return {it, 0}}

fn (ei mut EnumIter<It!>) next() ?(usize, IterElement<It>)
{
	e := ei.it.next()?
	i := ei.i
	ei.i++
	return i, e
}
