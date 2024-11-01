class_name LinearCam
extends CameraControllerBase

@export var tracking_rate: float = 5.0
@export var recovery_rate: float = 10.0
@export var max_distance: float = 10.0

var hud_layer: CanvasLayer
var crosshair_horizontal: ColorRect
var crosshair_vertical: ColorRect

func _ready() -> void:
	super()
	_initialize_hud()
	_setup_initial_camera()

func _initialize_hud() -> void:
	hud_layer = CanvasLayer.new()
	add_child(hud_layer)
	
	var viewport_rect = get_viewport().get_visible_rect()
	var screen_center = Vector2(
		viewport_rect.size.x / 2,
		viewport_rect.size.y / 2
	)
	
	crosshair_horizontal = _create_crosshair_element(
		Vector2(100, 4),
		Vector2(screen_center.x - 50, screen_center.y - 2)
	)
	
	crosshair_vertical = _create_crosshair_element(
		Vector2(4, 100),
		Vector2(screen_center.x - 2, screen_center.y - 50)
	)
	
	_set_crosshair_visibility(false)

func _create_crosshair_element(size: Vector2, pos: Vector2) -> ColorRect:
	var element = ColorRect.new()
	element.color = Color.WHITE
	element.size = size
	element.position = pos
	hud_layer.add_child(element)
	return element

func _setup_initial_camera() -> void:
	rotation.x = -PI/2

func _process(delta: float) -> void:
	if not _is_tracking_valid():
		return
		
	_update_crosshair_visibility()
	_update_camera_position(delta)

func _is_tracking_valid() -> bool:
	return target != null and current != null

func _update_crosshair_visibility() -> void:
	_set_crosshair_visibility(draw_camera_logic)

func _set_crosshair_visibility(is_visible: bool) -> void:
	if crosshair_horizontal and crosshair_vertical:
		crosshair_horizontal.visible = is_visible
		crosshair_vertical.visible = is_visible

func _update_camera_position(delta: float) -> void:
	var movement_speed = _calculate_movement_speed()
	var target_offset = _calculate_target_offset()
	
	_apply_movement(target_offset, movement_speed, delta)
	_update_height()

func _calculate_movement_speed() -> float:
	return tracking_rate if target.velocity.length() > 0 else recovery_rate

func _calculate_target_offset() -> Vector3:
	var offset = target.position - position
	offset.y = 0
	return offset

func _apply_movement(offset: Vector3, speed: float, delta: float) -> void:
	if offset.length() > max_distance:
		position += offset.normalized() * (offset.length() - max_distance)
	else:
		position += offset * (speed * delta)

func _update_height() -> void:
	position.y = target.position.y + dist_above_target

func draw_logic() -> void:
	_update_crosshair_visibility()
