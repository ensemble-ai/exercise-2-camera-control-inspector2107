class_name PrimaryCam
extends CameraControllerBase

@export var follow_velocity: float = 15.0
@export var return_delay: float = 0.5
@export var return_velocity: float = 5.0
@export var max_distance: float = 10.0

var hud_layer: CanvasLayer
var crosshair_horizontal: ColorRect
var crosshair_vertical: ColorRect
var idle_timer: float = 0.0

func _ready() -> void:
	if !target:
		return
		
	_setup_crosshair()
	rotation.x = -PI/2

func _setup_crosshair() -> void:
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
	hud_layer.add_child(crosshair_horizontal)
	crosshair_vertical = _create_crosshair_element(
		Vector2(4, 100),
		Vector2(screen_center.x - 2, screen_center.y - 50)
	)
	hud_layer.add_child(crosshair_vertical)

func _create_crosshair_element(size: Vector2, pos: Vector2) -> ColorRect:
	var element = ColorRect.new()
	element.color = Color.WHITE
	element.size = size
	element.position = pos
	return element

func _process(delta: float) -> void:
	if !target:
		return
		
	_update_crosshair_visibility()
	_handle_camera_movement(delta)

func _update_crosshair_visibility() -> void:
	crosshair_horizontal.visible = current
	crosshair_vertical.visible = current

func _handle_camera_movement(delta: float) -> void:
	var movement = _get_input_movement()
	
	if movement.length() > 0:
		_handle_active_movement(movement, delta)
	else:
		_handle_return_movement(delta)
	global_position.y = target.global_position.y + dist_above_target

func _get_input_movement() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

func _handle_active_movement(movement: Vector2, delta: float) -> void:
	idle_timer = 0
	var offset = Vector3(movement.x, 0, movement.y) * max_distance
	var target_pos = target.global_position
	var direction = target_pos - global_position
	direction.y = 0
	
	if direction.length() > max_distance:
		direction = direction.normalized() * max_distance
	
	global_position += direction * (follow_velocity * delta)

func _handle_return_movement(delta: float) -> void:
	idle_timer += delta
	if idle_timer >= return_delay:
		var direction = target.global_position - global_position
		direction.y = 0
		global_position += direction * (return_velocity * delta)

func draw_logic() -> void:
	pass
