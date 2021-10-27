all = $(shell find ./** -name "*.v")
ignore = $(shell cat .fmtignore)

files = $(filter-out $(ignore), $(all))

run: $(files)
	v fmt -w $(files)