$(shell rm -rf bin/*)
shaders := $(shell find ./ | egrep '*.vert|*.frag|*.geom|*.comp')

run: $(shaders)
	glslangValidator -V $(shaders)
	mv *.spv bin/