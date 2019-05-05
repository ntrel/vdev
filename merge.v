import iter

struct MergeIter<I1, I2>
{
	i1 mut I1
	i2 mut I2
}
/// Iterate two sorted iterators in order
fn merge(i1 I1! : Iterable, i2 I2! : Iterable) MergeIter<I1, I2>
{
	return {i1, i2}
}
fn (mi mut MergeIter<I1!, I2!>) next()! //?util.CommonType<IterElement<I1>, IterElement<I2>>
{
	e1 := i1.elem() or {return i2.next()}
	e2 := i2.elem() or {return i1.next()}
	return if e1 < e2 {i1.next()} else {i2.next()}
}

fn test_merge()
{
	mut mi := merge([1,4,5].iter(), [2,3,6].iter())
	assert mi.array() == [1,2,3,4,5,6]
	//assert equal(mi, [1,2,3,4,5,6].iter())
}
