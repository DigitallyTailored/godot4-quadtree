@tool
extends Node3D

class_name QuadtreeNode

var focus_position_last: Vector3 = Vector3.ZERO
@export var focus_position: Vector3 = Vector3.ZERO
# Quadtree specific properties
@export var quadtree_size: float = 512 #basically the size of the world
@export var max_chunk_depth: int = 8 #increase to create extra subdivisions (more detail locally)

var chunks_list = {}
var chunks_list_current = {}
var material = preload("res://new_standard_material_3d.tres")

# Placeholder for the quadtree structure
var quadtree: QuadtreeChunk

# Define a Quadtree chunk class
class QuadtreeChunk:
	var bounds: AABB
	var children = []
	var depth: int
	var max_chunk_depth: int
	var identifier: String

	func _init(_bounds: AABB, _depth: int, _max_chunk_depth: int):
		bounds = _bounds
		depth = _depth
		max_chunk_depth = _max_chunk_depth
		identifier = generate_identifier()

	func generate_identifier() -> String:
		# Generate a unique identifier for the chunk based on bounds and depth
		return "%s_%s_%d" % [bounds.position, bounds.size, depth]

	func subdivide(lod_center: Vector3):
		# Calculate new bounds for children
		var half_size = bounds.size.x * 0.5
		var quarter_size = bounds.size.x * 0.25
		var half_extents = Vector3(half_size, half_size, half_size)

		var child_positions = [
			Vector3(-quarter_size, 0, -quarter_size),
			Vector3(quarter_size, 0, -quarter_size),
			Vector3(-quarter_size, 0, quarter_size),
			Vector3(quarter_size, 0, quarter_size)
		]

		for offset in child_positions:
			# Calculate the center for each child
			var child_center = bounds.position + offset
			# Check the distance to the LOD center for each child
			var child_distance = child_center.distance_to(lod_center)
			var bounds_size = bounds.size.x
			if depth < max_chunk_depth and child_distance < bounds_size * 0.65:
				# Center is within the minimum detail distance
				# Calculate the bounds for the new child
				var child_bounds = AABB(child_center, half_extents)
				var new_child = QuadtreeChunk.new(child_bounds, depth + 1, max_chunk_depth)
				children.append(new_child)
				# Recursively subdivide the closest child chunk
				new_child.subdivide(lod_center)
			else:
				# Center is not within the minimum detail distance, add child at this depth
				var child_bounds = AABB(child_center - Vector3(quarter_size, quarter_size, quarter_size), half_extents)
				var new_child = QuadtreeChunk.new(child_bounds, depth + 1, max_chunk_depth)
				children.append(new_child)

func visualize_quadtree(chunk: QuadtreeChunk):
	# Generate a MeshInstance for each chunk
	if not chunk.children:

		chunks_list_current[chunk.identifier] = true
		#if chunk.identifier already exists leave it
		if chunks_list.has(chunk.identifier):
			return

		var mesh_instance = MeshInstance3D.new()
		var mesh = PlaneMesh.new()
		mesh.size = Vector2(chunk.bounds.size.x, chunk.bounds.size.z)
		mesh_instance.mesh = mesh
		mesh_instance.position = Vector3(chunk.bounds.position.x,0,chunk.bounds.position.z) + Vector3(chunk.bounds.size.x * 0.5, 0, chunk.bounds.size.z * 0.5)
		mesh_instance.material_override = material
		add_child(mesh_instance)

		#add this chunk to chunk list
		chunks_list[chunk.identifier] = mesh_instance
		if get_tree().get_edited_scene_root():
			mesh_instance.owner = get_tree().get_edited_scene_root()
			mesh_instance.owner.set_editable_instance(mesh_instance, true)
	# Recursively visualize children chunks
	for child in chunk.children:
		visualize_quadtree(child)

func _ready():
	# Clear existing children
	for child in get_children():
		remove_child(child)
		child.queue_free()
	update_chunks()

func _process(delta):
	if focus_position != focus_position_last:
		
		if floor(focus_position) != focus_position_last:
			update_chunks()
			focus_position_last = floor(focus_position)

func update_chunks():
	# Initialize the quadtree by creating the root chunk
	var bounds = AABB(Vector3(quadtree_size * 0.5, 0, quadtree_size * 0.5), Vector3(quadtree_size, quadtree_size, quadtree_size))
	quadtree = QuadtreeChunk.new(bounds, 0, max_chunk_depth)
	# Start the subdivision process
	quadtree.subdivide(focus_position)

	chunks_list_current = {}

	# Create a visual representation
	visualize_quadtree(quadtree)

	#remove any old unused chunks
	var chunks_to_remove = []
	for chunk_id in chunks_list:
		if not chunks_list_current.has(chunk_id):
			chunks_to_remove.append(chunk_id)
	for chunk_id in chunks_to_remove:
		chunks_list[chunk_id].queue_free()
		chunks_list.erase(chunk_id)

