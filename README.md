# Godot 4 Quadtree Chunk Generation

This repository contains a Godot 4 script for dynamic quadtree-based chunk generation. It's designed to create and manage a world divided into chunks that are dynamically loaded and unloaded based on a focus position, which can be updated typically to the player's location. This approach helps to optimize the rendering performance by only generating the necessary level of detail where it's needed.


https://github.com/DigitallyTailored/godot4-quadtree/assets/13086157/385c1420-8700-493e-b163-f257dfdff4aa


## Features

- Dynamic LOD (Level of Detail) generation based on focus position
- Quadtree subdivision for efficient chunk management
- Customizable world size and chunk depth
- Visual representation of quadtree chunks in the Godot editor

## Installation

To use the Quadtree Chunk Generation system in your Godot project, follow these steps:

1. Copy the `QuadtreeNode.gd` script from this repository into your Godot project's script folder.
2. Attach the script to a Node3D in your scene.
3. Adjust the exported variables, such as `quadtree_size` and `max_chunk_depth`, to suit your project's needs.

## Usage

The quadtree node is designed to be used in a 3D Godot environment. Once you have added the script to a Node3D in your scene, you can configure its properties via the Inspector or through code.

### Properties

- `focus_position`: The world coordinates that the quadtree should focus on when generating detailed chunks.
- `quadtree_size`: The overall size of the world that the quadtree covers, effectively setting the bounds for chunk generation.
- `max_chunk_depth`: The maximum depth of chunk subdivision, providing control over the level of detail.

### Visualization

The script includes functionality to visualize the quadtree's chunk structure when running the Godot editor. This visualization helps to understand how the quadtree divides the world and manages the chunks.

## License

This project is licensed under the MIT License.

## Acknowledgments

Big shout out to the excellent [SimonDev](https://www.youtube.com/@simondev758) who I first learnt about quadtrees from.

---

Enjoy creating vast and optimized 3D worlds in Godot with this Quadtree Chunk Generation system! If you encounter any issues or have any questions, feel free to open an issue on this GitHub repository.
