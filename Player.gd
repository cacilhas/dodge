extends Area2D

signal hit

const NULL_VECTOR := Vector2(-1, -1)
const DEVIATION := 5

export var speed := 400
export var width := 0
export var height := 0

var screen_size: Vector2
var touch: Vector2


func _ready() -> void:
	screen_size = get_viewport_rect().size
	width = screen_size.x
	height = screen_size.y
	touch = NULL_VECTOR
	hide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		touch = get_viewport().get_mouse_position()
	elif event is InputEventScreenTouch:
		touch = event.position


func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

	var velocity := process_keys() if touch.x < 0 or touch.y < 0 else (touch - position)

	if velocity.length() > 0:
		var vel = velocity.normalized() * speed * delta
		animate(vel)
		move_character(vel)
	else:
		$AnimatedSprite.stop()

	reset_touch(velocity)


func move_character(velocity: Vector2) -> void:
	position += velocity
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func animate(velocity: Vector2) -> void:
	$AnimatedSprite.play()

	if velocity.length() > 0:
		var quad := int(velocity.angle() * 4 / PI)
		match quad:
			0, 7:
				$AnimatedSprite.animation = "walk"
				$AnimatedSprite.flip_h = false
			3, 4:
				$AnimatedSprite.animation = "walk"
				$AnimatedSprite.flip_h = true
			1, 2:
				$AnimatedSprite.animation = "down"
				$AnimatedSprite.flip_h = false
			_:
				$AnimatedSprite.animation = "up"
				$AnimatedSprite.flip_h = false


func process_keys() -> Vector2:
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	return velocity


func reset_touch(velocity := Vector2.ZERO) -> void:
	if velocity.length() < DEVIATION:
		touch = NULL_VECTOR


func start(pos: Vector2) -> void:
	position = pos
	reset_touch()
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body) -> void:
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
