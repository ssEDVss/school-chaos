extends CharacterBody2D

#Разные переменные и характеристики
const SPEED = 50.0
@onready var anim = $AnimatedSprite2D
var can_move = true
var is_sitting = false
var current_desk = null

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

#Физика игрока
func _physics_process(_delta):
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	#Стрелочки на клавиатуре
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	direction = direction.normalized()
	velocity = direction * SPEED
	update_animation(direction)
	
	move_and_slide()
	global_position = global_position.round()
	z_index = int(global_position.y)

#Анимация персонажа
func update_animation(direcrion):
	if abs(direcrion.x) > abs(direcrion.y):
		if direcrion.x > 0:
			anim.play("walk_right")
		else:
			anim.play("walk_left")
	if abs(direcrion.x) < abs(direcrion.y):
		if direcrion.y > 0:
			anim.play("walk_down")
		else:
			anim.play("walk_up")
	else:
		if direcrion == Vector2.ZERO:
			anim.play("idle")
#Сидение за партой и покидание парты
func sit_at_desk(seat_position: Vector2, desk):
	global_position = seat_position.round()
	velocity = Vector2.ZERO
	can_move = false
	is_sitting = true
	current_desk = desk
	$AnimatedSprite2D.play("seat")
func leave_desk(exit_position: Vector2):
	global_position = exit_position.round()
	can_move = true
	is_sitting = false
	current_desk = null
	anim.play("walk_down")
