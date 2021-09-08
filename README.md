# oz-jp
Japan-optimized server-side over-zooming implementation

Added 'divide-and-conquer' strategy to manage each task size controllable: use z=6 tiles as the production lots. 

# Specifications
The specifications are subject to change. See `constants.rb` for the actual specifications.

- z=6 to define the production lots.
- z=15 as the source tile.
- z=16..20 for over-zoom tiles.

# See also
- https://github.com/unvt/oz
- https://github.com/optgeo/jp-tile-list
