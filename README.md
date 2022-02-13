[![CI](https://github.com/LouisSchmieder/engine/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/LouisSchmieder/engine/actions/workflows/ci.yml)

# Varekat
A 3d game engine with multiple backends, written in V

# Important
You have to install vulkan via the script at the moment. Will be changed in future.

# Installing

## Glfw

### Debian
```bash
sudo apt install libglfw3-dev
```

### Fedora
```bash
sudo dnf install glfw-devel
```

### Arch
```bash
sudo pacman -S glfw-<x11/wayland>
```

### MacOS
```bash
brew install glfw
```

### Windows
```shell
start scripts\glfw_install_windows.bat
```


## Vulkan

### Linux

**ATTENTION!** Make sure you have clang installed before run `vulkan_install_linux.sh` script.

```bash
sh scripts/vulkan_install_linux.sh
```

### MacOS
```bash
sh scripts/vulkan_install_macos.sh
```

### Windows
```shell
start scripts\vulkan_install_windows.bat
```

### Uninstalling

You can use `scripts/vulkan_delete.sh` script to uninstall Vulkan. You can also remove it manually by deleting folder *vulkan* in *Varekat/libs*

### Alternative
Alternative you can try to build the whole project and install all dependencies, by using <a href="https://github.com/LouisSchmieder/Vuild">Vuild</a>. But it's in an very alpha stage.


# Why?

I've started this project to first learn vulkan, but after now a bit of time I want to
start the first 3D game engine in V. I want to achieve a multi backend engine which works
on every platform.

# Contribute
Just create a fork, create a branch and write the code. Then just push the code to your fork
and create a pull request.

# Pictures
<img src="./assets/images/cube_example.gif" alt="Cube demo" style="width: 100%">

<img src="./assets/images/dragon_demo.png" alt="Dragon demo" style="width: 100%">

<img src="./assets/images/terrain.png" alt="Terrain demo" style="width: 100%">
