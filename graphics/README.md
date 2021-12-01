# Graphics

The graphics module is the module which holds the logic behind objects placed into the world.

Everything is based on an object, which holds a mesh. A mesh is just a structure which has all
the indicies and verticies, aswell as the position, rotation and scale of the object.

```
Object
-> Plane
```

## Plane
A plane represents a flat mesh in basic. It's a grid with a height and width of possible grid points, aswell as a quad length which is valid for both sides.