extends MeshInstance3D

var material: StandardMaterial3D
@export var uv_scroll_speed := Vector3(1.0, 0.0, 0.0) # Example speed for upward scroll

func _ready() -> void:
	# Get the material from the mesh instance (index 0)
	material = get_active_material(0)
	# Ensure the material is unique to this instance if needed
	if material:
		material = material.duplicate()
		set_surface_override_material(0, material)

func _process(delta:float) -> void:
	if material:
		# Animate the UVs by constantly moving the offset
		# Use a small number multiplied by delta for frame-rate independence
		# The direction depends on your desired effect (e.g., negative Y for upward flow)
		
		material.uv1_offset += uv_scroll_speed * delta
		
		# Optional: wrap the offset so it stays within the 0-1 range to prevent
		# floating point precision issues over long periods (textures wrap by default)
		material.uv1_offset.x = fmod(material.uv1_offset.x, 1.0)
		material.uv1_offset.y = fmod(material.uv1_offset.y, 1.0)
