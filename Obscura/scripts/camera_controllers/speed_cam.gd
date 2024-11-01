class_name SpeedCam
extends CameraControllerBase

@export_group("Camera Settings")
@export var camera_height: float = 40.0
@export var speedup_multiplier: float = 1.5


@export_group("Zone Boundaries")
@export var push_zone: Rect2:
	get:
		return Rect2(push_zone_top_left, push_zone_bottom_right - push_zone_top_left)
	set(value):
		push_zone_top_left = value.position
		push_zone_bottom_right = value.position + value.size

@export var speedup_zone: Rect2:
	get:
		return Rect2(speedup_zone_top_left, speedup_zone_bottom_right - speedup_zone_top_left)
	set(value):
		speedup_zone_top_left = value.position
		speedup_zone_bottom_right = value.position + value.size


var push_zone_top_left: Vector2
var push_zone_bottom_right: Vector2
var speedup_zone_top_left: Vector2
var speedup_zone_bottom_right: Vector2
var _last_x_position: float = 0.0
var _ui: CameraUI

class CameraUI:
	var canvas: CanvasLayer
	var crosshair_horizontal: ColorRect
	var crosshair_vertical: ColorRect
	
	func _init(parent: Node) -> void:
		canvas = CanvasLayer.new()
		parent.add_child(canvas)
		
		var viewport_size = parent.get_viewport().get_visible_rect().size
		var center = viewport_size / 2
		
		crosshair_horizontal = _create_crosshair_line(
			Vector2(100, 4),
			center + Vector2(-50, -2)
		)
		
		crosshair_vertical = _create_crosshair_line(
			Vector2(4, 100),
			center + Vector2(-2, -50)
		)
	
	func _create_crosshair_line(size: Vector2, position: Vector2) -> ColorRect:
		var line = ColorRect.new()
		line.color = Color.WHITE
		line.size = size
		line.position = position
		canvas.add_child(line)
		return line
	
	func set_visibility(visible: bool) -> void:
		crosshair_horizontal.visible = visible
		crosshair_vertical.visible = visible

func _ready() -> void:
	super()
	if target:
		_ui = CameraUI.new(self)
		_initialize_camera()
		_last_x_position = target.global_position.x

func _initialize_camera() -> void:
	rotation.x = deg_to_rad(-90)
	position = _calculate_camera_position(target.position)

func _physics_process(delta: float) -> void:
	if !target or !current:
		return
	
	if _ui:
		_ui.set_visibility(draw_camera_logic)
	
	_update_camera_position(delta)

func _update_camera_position(delta: float) -> void:
	var target_pos_2d = Vector2(target.global_position.x, target.global_position.z)
	
	if target.velocity.length() == 0 or _is_in_zone(target_pos_2d, speedup_zone):
		position = _calculate_camera_position(target.global_position)
		_last_x_position = target.global_position.x
		return
	
	var is_moving_backward = target.transform.basis.z.dot(target.velocity) > 0
	var is_moving_left = target.global_position.x < _last_x_position
	
	if is_moving_left:
		_handle_left_movement(delta)
	elif is_moving_backward:
		_handle_backward_movement(target_pos_2d, delta)
	else:
		_handle_forward_movement(delta)
	
	_last_x_position = target.global_position.x

func _handle_left_movement(delta: float) -> void:
	var new_position = position
	new_position.y = target.global_position.y + camera_height
	if target.velocity.z != 0:
		new_position.z += target.velocity.z * delta
	
	position = new_position
	rotation.x = deg_to_rad(-90)

func _handle_backward_movement(target_pos_2d: Vector2, delta: float) -> void:
	var edges = _get_touching_edges(target_pos_2d)
	
	if edges.size() == 2:
		position.x += target.velocity.x * delta
		position.z += target.velocity.z * delta
	elif edges.size() == 1:
		if "left" in edges or "right" in edges:
			position.x += target.velocity.x * delta
			position.z += target.velocity.z * speedup_multiplier * delta
		else:
			position.x += target.velocity.x * speedup_multiplier * delta
			position.z += target.velocity.z * delta
	else:
		position.x += target.velocity.x * speedup_multiplier * delta
		position.z += target.velocity.z * speedup_multiplier * delta
	
	position.y = target.global_position.y + camera_height
	rotation.x = deg_to_rad(-90)

func _handle_forward_movement(delta: float) -> void:
	var target_pos = target.global_position
	var lerp_speed = 10.0
	
	position = position.lerp(
		target_pos + Vector3(0, camera_height, 0),
		lerp_speed * delta
	)
	rotation.x = deg_to_rad(-90)

func _get_touching_edges(pos: Vector2) -> Array:
	var edges = []
	if pos.x <= push_zone.position.x:
		edges.append("left")
	if pos.x >= push_zone.end.x:
		edges.append("right")
	if pos.y <= push_zone.position.y:
		edges.append("top")
	if pos.y >= push_zone.end.y:
		edges.append("bottom")
	return edges

func _is_in_zone(pos: Vector2, zone: Rect2) -> bool:
	return zone.has_point(pos)

func _calculate_camera_position(target_pos: Vector3) -> Vector3:
	return target_pos + Vector3(0, camera_height, 0)

func draw_logic() -> void:
	var mesh = _create_debug_mesh()
	add_child(mesh)
	await get_tree().process_frame
	mesh.queue_free()

func _create_debug_mesh() -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	var immediate_mesh = ImmediateMesh.new()
	var material = ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	_draw_zone_outline(immediate_mesh, push_zone)

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	_draw_zone_outline(immediate_mesh, speedup_zone)
	
	immediate_mesh.surface_end()
	
	return mesh_instance

func _draw_zone_outline(immediate_mesh: ImmediateMesh, zone: Rect2) -> void:
	var vertices = [
		Vector3(zone.position.x, 0, zone.end.y),         
		Vector3(zone.end.x, 0, zone.end.y),              
		Vector3(zone.end.x, 0, zone.position.y),         
		Vector3(zone.position.x, 0, zone.position.y)    
	]
	
	for i in range(vertices.size()):
		immediate_mesh.surface_add_vertex(vertices[i])
		immediate_mesh.surface_add_vertex(vertices[(i + 1) % vertices.size()])
