extends CharacterBody2D
var stfr = 0
@onready var anima = $AnimatedSprite2Dfr

const SPEED = 50.0
var directionf = 1
var change_time = 0.0
var can_move = false

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

func _physics_process(_delta):
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	change_time += _delta
	if change_time >= 2.0:
		directionf *= -1
		change_time = 0.0
	velocity.y = directionf * SPEED
	velocity.x = 0

	move_and_slide()
	z_index = int(global_position.y)
	update_animationfr()

#Анимация друга
func update_animationfr():
	if velocity.x > 0:
		anima.play("walk_rightfriend")
	elif velocity.x < 0:
		anima.play("walk_leftfriend")
	if velocity.y > 0:
		anima.play("walk_downfriend")
	elif velocity.y < 0:
		anima.play("walk_upfriend")
	else:
		anima.play("idlefriend")
