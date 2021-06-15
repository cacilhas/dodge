class_name Mob
extends RigidBody2D

var min_speed := 150
var max_speed := 250
var type: String


func _ready() -> void:
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	type = mob_types[randi() % mob_types.size()]
	$AnimatedSprite.animation = type


func start(location: PathFollow2D) -> void:
	var direction: float = location.rotation + PI / 2
	position = location.position
	direction += rand_range(-PI / 4, PI / 4)
	rotation = direction if type == "swim" else flip(int(direction * 2 / PI) in [-1, 0, 3])
	linear_velocity = Vector2(rand_range(min_speed, max_speed), 0)
	linear_velocity = linear_velocity.rotated(direction)


func flip(yes: bool) -> float:
	$AnimatedSprite.flip_h = true
	$AnimatedSprite.flip_v = yes == (type == "walk")
	return PI / 2


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
