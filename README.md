[![CI](https://github.com/LouisSchmieder/engine/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/LouisSchmieder/engine/actions/workflows/ci.yml)

# Varekat
A 3d game engine with multiple backends, written in V

# Installing

## Apt
```bash
sudo apt install libglfw3-dev libvulkan-dev
```

## Dnf
```bash
sudo dnf install glfw-devel vulkan-loader-devel
```

## Other

### Linux
https://vulkan.lunarg.com/doc/sdk/1.2.198.0/linux/getting_started.html

### MacOS
https://vulkan.lunarg.com/doc/sdk/1.2.198.0/mac/getting_started.html
```bash
brew install glfw
```

### Windows
https://vulkan.lunarg.com/doc/sdk/1.2.198.0/windows/getting_started.html


# Why?

I've started this project to first learn vulkan, but after now a bit of time I want to
start the first 3D game engine in V. I want to achieve a multi backend engine which works
on every platform.

# Roadmap
- [ ] Implement vulkan backend
- [x] Implement 3D loading
- [ ] Implement basic light
- [ ] Use multiple meshes

# Contribute
Just create a fork, create a branch and write the code. Then just push the code to your fork
and create a pull request.

# Pictures
<img src="./assets/images/cube_example.gif" alt="Cube demo" style="width: 100%">

<img src="./assets/images/dragon_demo.png" alt="Dragon demo" style="width: 100%">

<img src="./assets/images/terrain.png" alt="Terrain demo" style="width: 100%">
