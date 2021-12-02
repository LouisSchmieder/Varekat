import mathf

fn test_vec_minus() {
	a := mathf.vec3(1, 1, 1)
	b := mathf.vec3(2, 1, 6)

	c := a - b

	assert c.x == -1
	assert c.y == 0
	assert c.z == -5
}

// TODO add more tests
