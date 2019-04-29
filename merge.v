struct MergeIter<I1, I2>
{
	i1 mut I1
	i2 mut I2
}
fn merge(i1 I1!, i2 I2!) MergeIter<I1, I2>
{
	return {i1, i2}
}
fn (mi mut MergeIter<I1!, I2!>) next()! //?util.CommonType<IterElement<I1>, IterElement<I2>>
{
	if i1.empty() {return i2.next()}
	if i2.empty() {return i1.next()}
	return if i1.peek() < i2.peek() {i1.next()} else {i2.next()}
}

fn test_merge()
{
	import iter
	mut mi := merge([1,4,5].iter(), [2,3,6].iter())
	assert mi.array() == [1,2,3,4,5,6]
	//assert mi.equal([1,2,3,4,5,6].iter())
}
