class_name ScrollingCam
extends CameraControllerBase


@export var top_left: Vector2
@export var bottom_right: Vector2
@export_range(0, 20.0) var scroll_speed: float = 5.0
@export_range(1.0, 5.0) var push_force_multiplier: float = 2.0 
var _scroll_box: ScrollBox

class ScrollBox:
	var position: Vector3
	var bounds: Rect2
	var constant_speed: Vector3
	
	func _init(pos: Vector3, tl: Vector2, br: Vector2, speed: float) -> void:
		position = pos
		bounds = Rect2(tl, br - tl)
		constant_speed = Vector3(speed, 0, 0)
	
	func update_position(delta: float) -> void:
		position += constant_speed * delta
	
	func get_relative_position(target_pos: Vector3) -> Vector2:
		return Vector2(
			target_pos.x - position.x,
			target_pos.z - position.z
		)

func _ready() -> void:
	super()
	_initialize_camera()

func _process(delta: float) -> void:
	if !_can_process():
		return
	
	_update_scroll_box(delta)
	_update_camera_position()
	_check_left_boundary()
	
	if draw_camera_logic:
		_draw_debug_visualization()

func _initialize_camera() -> void:
	if target:
		_scroll_box = ScrollBox.new(target.global_position, top_left, bottom_right, scroll_speed)
		global_position = _scroll_box.position
		global_position.y += dist_above_target
	rotation.x = deg_to_rad(-90)

func _can_process() -> bool:
	return target != null and current

func _update_scroll_box(delta: float) -> void:
	_scroll_box.update_position(delta)

func _update_camera_position() -> void:
	global_position = _scroll_box.position
	global_position.y = target.global_position.y + dist_above_target

func _check_left_boundary() -> void:
	var relative_pos = _scroll_box.get_relative_position(target.global_position)
	if relative_pos.x < top_left.x:
		target.global_position.x = _scroll_box.position.x + top_left.x
		var push_velocity = _scroll_box.constant_speed.x * push_force_multiplier
		target.velocity.x = max(target.velocity.x, push_velocity)

func _draw_debug_visualization() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	_setup_debug_mesh(mesh_instance, immediate_mesh, material)
	_draw_debug_lines(immediate_mesh)
	
	add_child(mesh_instance)
	await get_tree().process_frame
	mesh_instance.queue_free()

func _setup_debug_mesh(mesh_instance: MeshInstance3D, immediate_mesh: ImmediateMesh, material: ORMMaterial3D) -> void:
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

func _draw_debug_lines(immediate_mesh: ImmediateMesh) -> void:
	
	var tl = _scroll_box.position + Vector3(top_left.x, 0, top_left.y)
	var tr = _scroll_box.position + Vector3(bottom_right.x, 0, top_left.y)
	var bl = _scroll_box.position + Vector3(top_left.x, 0, bottom_right.y)
	var br = _scroll_box.position + Vector3(bottom_right.x, 0, bottom_right.y)
	
	var vertices = [
		[bl, br],
		[br, tr],
		[tr, tl],
		[tl, bl]
	]
	
	for line in vertices:
		immediate_mesh.surface_add_vertex(line[0])
		immediate_mesh.surface_add_vertex(line[1])
	
	immediate_mesh.surface_end()
