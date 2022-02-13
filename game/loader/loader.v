module loader

import os
import misc

const (
	path = 'assets/content'
)

struct Loader<T> {
mut:
	name string
pub mut:
	data T
}

pub fn create_loader<T>(name string, data T) Loader<T> {
	if !os.exists(loader.path) {
		os.mkdir(loader.path) or { panic(err) }
	}
	return Loader<T>{
		name: name
		data: data
	}
}

pub fn (loader Loader<T>) store() ? {
	loader.data.store('$loader.path/${loader.name}.vbin')
}

pub fn (mut loader Loader<T>) load(mut progress misc.Progress) ? {
	loader.data.load('$loader.path/${loader.name}.vbin', mut progress)
}

// TODO add mapping file for unique file names
pub fn exists(name string) bool {
	return os.exists('$loader.path/${name}.vbin')
}
