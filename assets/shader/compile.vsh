if exists('bin') {
	rmdir('bin') or { panic(err) }
}

mkdir('bin') or { panic(err) }

shaders := read_file('shaders.list') or { '' }
for shader in shaders.fields() {
	res := execute('glslangValidator -V $shader')
	if res.exit_code != 0 {
		eprintln(res.output)
		exit(res.exit_code)
	}
	mv('${shader}.spv', 'bin/${shader}.spv') or { panic(err) }
}
