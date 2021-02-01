import os

fn bail(msg string) {
	eprintln(msg)
	exit(1)
}

if os.args.len <= 2 {
	bail('Usage: ${os.args[0]} v_compiler filenames')
}
compiler := os.args[1]
if !os.exists(compiler.all_before(' ')) {
	bail('$compiler does not exist')
}
fnames := os.args[2..]
for fname in fnames {
	if !os.exists(fname) {
		bail('$fname does not exist')
	}
	if !fname.ends_with('.vv') {
		bail('$fname should end with .vv')
	}
}
for fname in fnames {
	cmd := '$compiler $fname'
	println('Executing: $cmd')
	r := os.exec(cmd) or {
		bail(err)
		return
	}
	outf := fname[..fname.len-3] + '.out'
	println('Writing to $outf')
	os.write_file(outf, r.output + '\n') or {
		bail('error writing file: $err')
	}
}
