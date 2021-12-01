if exists('bin') {
	rmdir_all('bin') or { panic(err) }
}

mkdir('bin') or { panic(err) }

shaders := read_file('shaders.list') or { '' }
for shader in shaders.fields() {
	s := shader.trim_space().split('.')
	res := execute('glslangValidator -V ${shader.trim_space()}')
	if res.exit_code != 0 {
		eprintln(res.output)
		exit(res.exit_code)
	}
	mv('${s[1]}.spv', './bin/${s[1]}.spv') or { panic(err) }
}
