import os

fn bail(msg string) {
	eprintln(msg)
	exit(1)
}

if os.args.len <= 1 {
	bail('Usage: $0 filename')
}
fname := os.args[1]
if !os.exists(fname) {
	bail('$fname does not exist')
}
if !fname.ends_with('.vv') {
	bail('$fname should end with .vv')
}
compiler := 'v.exe'
if !os.exists(compiler) {
	bail('$compiler does not exist')
}
r := os.exec('$compiler $fname')?
outf := fname[..fname.len-3] + '.out'
println('Writing to $outf')
os.write_file(outf, r.output + '\n') or {
	bail('error writing file: $err')
}
