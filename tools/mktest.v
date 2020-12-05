import os

fn bail(msg string) {
	eprintln(msg)
	exit(1)
}

if os.args.len < 2 {
	bail('Usage: ${os.args[0]} filename')
}
fname := os.args.last()
if !os.exists(fname) {
	bail('$fname does not exist')
}
if !fname.ends_with('.vv') {
	bail('$fname should end with .vv')
}
mut compiler := './v'
$if windows {
	compiler = 'v.exe'
}
if !os.exists(compiler) {
	bail('$compiler does not exist')
}
cmd := '$compiler -W $fname'
println(cmd)
r := os.exec(cmd)?
outf := fname[..fname.len-3] + '.out'
println('Writing to $outf')
os.write_file(outf, r.output + '\n') or {
	bail('error writing file: $err')
}
