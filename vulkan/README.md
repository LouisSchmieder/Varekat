# Vulkan

## What is Vulkan
**Vulkan** is a graphics api as like as **OpenGL** the only difference is that **Vulkan** is much more powerful.
The consequence by that is the problem that there is a very long way to create windows and there are
much lines of code to setup **Vulkan**. The good thing about Vulkan is that we've way much more room for
optimization.

### Create info
There are create infos for all structs which get created by functions. There we have curtain options
to use **Vulkan** in a different way. We can set there flags other struct datas and much more. But it
depends on the struct which get created.

### Misc structs
There are misc structs which just provide data for other structs to handle them, like create infos.

### Function structs
Structs which get defined by the driver are structs, which get created by functions. They need a create
info which keeps the data to initialize the struct on drivers site.

## What is Vulkan in this project
Vulkan is in this project just a backend, which will be default on *Windows* and *Linux*.

## Important
An important note if Vulkan doesn't work, it could be that there is no graphical device found, which
supports the needed flags. It could be wrong so there will be a flag, which will debug that and give
information to fix it. Since there is the problem that the program has to analyse the gpus and find the
best on, it's very WIP.
