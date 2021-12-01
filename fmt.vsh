import v.util
import os

ignore_str := read_file('.fmtignore') or { '' }

ignore := ignore_str.fields()
v_files := util.find_all_v_files(['.']) or { panic(err) }

fmt_files := v_files.filter(it !in ignore)

if os.args.len == 1 {
	res := execute('v fmt -w ${fmt_files.join(' ')}')
	if res.exit_code != 0 {
		eprintln(res.output)
		exit(res.exit_code)
	}
	eprintln(res.output)
	return
}
if os.args[1] in ['v', 'verify'] {
	res := execute('v fmt -verify ${fmt_files.join(' ')}')
	if res.exit_code != 0 {
		eprintln(res.output)
		exit(res.exit_code)
	}
	return
}
