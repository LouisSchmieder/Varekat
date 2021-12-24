module graphics

import misc
import mathf
import game.loader

pub fn load_mesh(path string, mut progress misc.Progress) ?Mesh {
	if loader.exists(path.split('/').last()) {
		return load_saved_mesh(path.split('/').last(), mut progress)
	}

	go save_mesh(mut progress, path, path.split('/').last())
	verticies, indicies := misc.load_obj(path, mut progress, false) ?
	return create_mesh(verticies, indicies, path)
}

fn save_mesh(mut progress misc.Progress, path string, name string) {
	eprintln('Optimize mesh...')
	verticies, indicies := misc.load_obj(path, mut progress, true) or { panic(err) }
	eprintln('Loaded mesh...')
	mesh := create_mesh(verticies, indicies, path)
	loader := loader.create_loader(name, mesh)
	loader.store() or { panic(err) }
	eprintln('Stored mesh...')
}

fn load_saved_mesh(name string, mut progress misc.Progress) Mesh {
	mut loader := loader.create_loader(name, Mesh{})
	loader.load(mut progress) or { panic(err) }
	return loader.data
}
