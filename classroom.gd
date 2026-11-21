extends Control

#Ах, мне лень дальше подписывать каждую команду

var player_in_desk_zone = false
var player_in_board_zone = false
var player_in_window_zone = false
var player_in_flower_zone = false
var player_in_sink_zone = false
var player_in_phon1_zone = false
var player_in_phon2_zone = false
var player_ref = null
var interact_icon = false
var story = 0
var boardloh = false
var windowbreakes = false
var flowerbreakes = false
var sinkbreakes = false
var phoneus1 = false
var phoneus2 = false
var respect = 0
var suspicion = 0
var cutscene_active = true
var player_caught = false
var friend_caught = false
var rng = RandomNumberGenerator.new()
var dialogue_step = 0
var can_interact = true


func _ready():
	await get_tree().process_frame
	$AnimationPlayer.play("fade_in")
	set_static_object_layers()
	rng.randomize()
	start_intro_cutscene()
	update_stats_ui()
	$Music.play()
	
	#$Player.can_move = false

#Пауза/Выход(в самом начале разработки, и я не буду убирать эту надпись!)
func _on_pause_pressed() -> void:
	$AnimationPlayer.play("fade_out")
	await get_tree().create_timer(1.1).timeout
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://menu.tscn")
	#Я у мамы программист!

#Управление стрелки:
#ВВЕРХ
func _on_upbtn_button_up() -> void:
	Input.action_release("ui_up")
func _on_upbtn_button_down() -> void:
	Input.action_press("ui_up")
#ВНИЗ
func _on_downbtn_button_up() -> void:
	Input.action_release("ui_down")
func _on_downbtn_button_down() -> void:
	Input.action_press("ui_down")
#ВЛЕВО
func _on_leftbtn_button_up() -> void:
	Input.action_release("ui_left")
func _on_leftbtn_button_down() -> void:
	Input.action_press("ui_left")
#ВПРАВО
func _on_rightbtn_button_up() -> void:
	Input.action_release("ui_right")
func _on_rightbtn_button_down() -> void:
	Input.action_press("ui_right")
	

#КАТСЦЕНА В НАЧАЛЕ
func start_intro_cutscene():
	cutscene_active = true
	#Игрок сидит
	$Player.sit_at_desk($PlayerDeskContact/SeatPoint.global_position, $PlayerDeskContact)
	$Player.z_index = int($Player.global_position.y + 9)
	#Друг сидит
	$friend.global_position = Vector2(110,100)
	$friend.velocity = Vector2.ZERO
	$friend.set("can_move", false)
	$friend.get_node("AnimatedSprite2Dfr").play("friendback1")
	$friend.z_index = int($friend.global_position.y + 9)
	show_dialogue("ДРУГ(Коля):", "Давай кто громче крикнет ****!")
	
func  show_dialogue(char_name: String, text: String):
	$DialogueUI.visible = true
	$UI.visible = false
	$DialogueUI/Panel/NameLabel.text = char_name
	$DialogueUI/Panel/TextLabel.text = text
	$DialogueUI/Panel/Choice1.visible = false
	$DialogueUI/Panel/Choice2.visible = false
	
func show_choice(text1: String, text2: String):
	$DialogueUI/Panel/Choice1.visible = true
	$DialogueUI/Panel/Choice2.visible = true
	$DialogueUI/Panel/Choice1.text = text1
	$DialogueUI/Panel/Choice2.text = text2
	
func next_dialogue():
	dialogue_step += 1
	if dialogue_step == 1:
		show_dialogue("ВЫ(Даня):", "Ну окей")
	elif dialogue_step == 2:
		show_dialogue("ДРУГ:", "*Кричит не громко")
	elif dialogue_step == 3:
		show_dialogue("ДРУГ:", "Теперь ты")
	elif dialogue_step == 4:
		show_dialogue("ВЫБОР:", "Как крикнуть?")
		show_choice(
			"Громко (+25 уважения, 70% проиграть)",
			"Тихо (+5 уважения, 10% проиграть)"
		)
	
	
#Кнопка Взаимодействия
func _on_interactbtn_pressed() -> void:
	Input.action_press("interact")
	Input.action_release("interact")

#Взаимодействие с предметами
func _process(_delta):
	#С Партой
	if player_in_desk_zone and Input.is_action_just_pressed("interact"):
		if player_ref != null:
			if player_ref.is_sitting:
				player_ref.leave_desk($PlayerDeskContact/ExitPoint.global_position)
			elif player_in_desk_zone:
				player_ref.sit_at_desk($PlayerDeskContact/SeatPoint.global_position, $PlayerDeskContact)
			update_interact_icon()
	#С доской
	if can_interact and player_in_board_zone and Input.is_action_just_pressed("interact"):
		if player_ref != null:
			if boardloh == false:
				$PlayerBoardContact/board.texture = preload("res://boardloh.png")
				boardloh = true
				call_teacher_to.bind($BoardTeacherPoint.global_position, true).call_deferred()
				start_interact_cooldown()
	#С Окном
	if can_interact and player_in_window_zone and Input.is_action_just_pressed("interact"):
		if player_ref != null:
			if windowbreakes == false:
				$PlayerWindowContact/windowpl.texture = preload("res://windowbasebreak.png")
				windowbreakes = true
				call_teacher_to.bind($WindowTeacherPoint.global_position, true).call_deferred()
				start_interact_cooldown()
	#С Цветком
	if can_interact and player_in_flower_zone and Input.is_action_just_pressed("interact"):
		if player_ref != null:
			if flowerbreakes == false:
				$PlayerFlowerContact/flowerpl.texture = preload("res://flowerbroke.png")
				$PlayerFlowerContact/flowerpl.position = Vector2(9, -9)
				flowerbreakes = true
				call_teacher_to.bind($FlowerTeacherPoint.global_position, true).call_deferred()
				start_interact_cooldown()
	#С Раковиной
	if can_interact and player_in_sink_zone and Input.is_action_just_pressed("interact"):
		if player_ref != null:
			if sinkbreakes == false:
				$PlayerSinkContact/sinkpl.texture = preload("res://sinka4.png")
				sinkbreakes = true
				call_teacher_to.bind($SinkTeacherPoint.global_position, true).call_deferred()
				start_interact_cooldown()
	#С Телефоном 1
	if can_interact and player_in_phon1_zone and Input.is_action_just_pressed("interact"):
		if player_ref != null:
			if phoneus1 == false:
				phoneus1 = true
				$PlayerPhone1Contact/phone1pl.texture = preload("res://Phone1n.png")
				suspicion += 5
				update_stats_ui()
				call_teacher_to.bind($Phone1_2.global_position).call_deferred()
				start_interact_cooldown()
	#С Телефоном 2
	if can_interact and player_in_phon2_zone and Input.is_action_just_pressed("interact"):
		if player_ref != null:
			if phoneus2 == false:
				phoneus2 = true
				$PlayerPhone2Contact/phone2pl.texture = preload("res://Phone2n.png")
				suspicion += 5
				update_stats_ui()
				call_teacher_to.bind($Phone2_1.global_position).call_deferred()
				start_interact_cooldown()
	# Отвлечение училки
	if can_interact and Input.is_action_just_pressed("interact"):
		if !player_in_desk_zone \
		and !player_in_board_zone \
		and !player_in_window_zone \
		and !player_in_flower_zone \
		and !player_in_sink_zone:
			call_teacher_to($Player.global_position)
			suspicion += 5
			start_interact_cooldown()
	update_stats_ui()

func set_static_object_layers():
	var objects_with_offset = [
		[$DeskTeacher, 20],
		[$PlayerDesk, 20],
		[$PlayerChair, 40],
		[$PlayerBoardContact, 10],
		[$PlayerWindowContact, 10],
		[$PlayerFlowerContact, 8],
		[$PlayerSinkContact, 12],
		[$Mateback1, 18],
		[$Mateback3, 18],
		[$Mateback4, 18],
		[$TextureRect3, 20],
		[$TextureRect10, 17],
		[$TextureRect11, 17]
	]
	for item in objects_with_offset:
		var node = item[0]
		var offset = item[1]
		node.z_index = int(node.global_position.y + offset)
			
#Обновление иконок
func update_interact_icon():
	#Стул с партой
	if player_in_desk_zone and player_ref != null and not player_ref.is_sitting:
		$PlayerChair.texture = preload("res://chairmiddleschoolinteract.png")
	elif not player_in_desk_zone or player_ref.is_sitting:
		$PlayerChair.texture = preload("res://chairmiddleschool.png")
	#Доска для мела которая
	if player_in_board_zone and player_ref != null and boardloh == false:
		$PlayerBoardContact/board.texture = preload("res://boardcontact.png")
	elif not player_in_board_zone and boardloh == false:
		$PlayerBoardContact/board.texture = preload("res://board.png")
	#Окно для разбивания
	if player_in_window_zone and player_ref != null and windowbreakes == false:
		$PlayerWindowContact/windowpl.texture = preload("res://windowbaseinteract.png")
	elif not player_in_window_zone and windowbreakes == false:
		$PlayerWindowContact/windowpl.texture = preload("res://windowbase.png")
	#Цветок для разбивания
	if player_in_flower_zone and player_ref != null and flowerbreakes == false:
		$PlayerFlowerContact/flowerpl.texture = preload("res://flowerinteract.png")
	elif not player_in_flower_zone and flowerbreakes == false:
		$PlayerFlowerContact/flowerpl.texture = preload("res://flower.png")
	#Раковина для затопления
	if player_in_sink_zone and player_ref != null and sinkbreakes == false:
		$PlayerSinkContact/sinkpl.texture = preload("res://sinkinteract.png")
	elif not player_in_sink_zone and sinkbreakes == false:
		$PlayerSinkContact/sinkpl.texture = preload("res://sink.png")
	#C Телефоном 1
	if player_in_phon1_zone and player_ref != null and phoneus1 == false:
		$PlayerPhone1Contact/phone1pl.texture = preload("res://Phone1interact.png")
	elif not player_in_phon1_zone and phoneus1 == false:
		$PlayerPhone1Contact/phone1pl.texture = preload("res://Phone1n.png")
	#C Телефоном 2
	if player_in_phon2_zone and player_ref != null and phoneus2 == false:
		$PlayerPhone2Contact/phone2pl.texture = preload("res://Phone2interact.png")
	elif not player_in_phon2_zone and phoneus2 == false:
		$PlayerPhone2Contact/phone2pl.texture = preload("res://Phone2n.png")
		
#Выше/Ниже
#Стол Тичера


#Рядом с Партой взаимодействие
func _on_interact_zone_desk_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_desk_zone = true
		player_ref = body
		update_interact_icon()
func _on_interact_zone_desk_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_desk_zone = false
		player_ref = null
		$PlayerChair.texture = preload("res://chairmiddleschool.png")
		
#Рядом с Доской взаимодействие
func _on_interact_board_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_board_zone = true
		player_ref = body
		update_interact_icon()
func _on_interact_board_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_board_zone = false
		player_ref = null
		if boardloh == false:
			$PlayerBoardContact/board.texture = preload("res://board.png")
		
#Рядом с Окном взаимодействие
func _on_interact_window_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_window_zone = true
		player_ref = body
		update_interact_icon()
func _on_interact_window_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_window_zone = false
		player_ref = null
		if windowbreakes == false:
			$PlayerWindowContact/windowpl.texture = preload("res://windowbase.png")
		
#Рядом с Цветком взаимодействие
func _on_interact_flower_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_flower_zone = true
		player_ref = body
		update_interact_icon()
func _on_interact_flower_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_flower_zone = false
		player_ref = null
		if flowerbreakes == false:
			$PlayerFlowerContact/flowerpl.texture = preload("res://flower.png")
		
#Рядом с Раковиной взаимодействие
func _on_interact_sink_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_sink_zone = true
		player_ref = body
		update_interact_icon()
func _on_interact_sink_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_sink_zone = false
		player_ref = null
		if sinkbreakes == false:
			$PlayerSinkContact/sinkpl.texture = preload("res://sink.png")

#Рядом с Телефоном1 взаимодействие
func _on_interact_phone_1_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_phon1_zone = true
		player_ref = body
		update_interact_icon()
func _on_interact_phone_1_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_phon1_zone = false
		player_ref = null
		if phoneus1 == false:
			$PlayerPhone1Contact/phone1pl.texture = preload("res://Phone1n.png")
			
#Рядом с Телефоном2 взаимодействие
func _on_interact_phone_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_phon2_zone = true
		player_ref = body
		update_interact_icon()
func _on_interact_phone_2_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_phon2_zone = false
		player_ref = null
		if phoneus2 == false:
			$PlayerPhone2Contact/phone2pl.texture = preload("res://Phone2n.png")



func _on_choice_1_pressed() -> void:
	if dialogue_step == 4:
		respect += 25
		check_if_player_caught(70)
	elif dialogue_step == 100:
		try_blame_friend()


func _on_choice_2_pressed() -> void:
	if dialogue_step == 4:
		respect += 5
		check_if_player_caught(10)
	elif dialogue_step == 100:
		apologize()
		
func check_if_player_caught(chance_percent: int):
	$DialogueUI/Panel/Choice1.visible = false
	$DialogueUI/Panel/Choice2.visible = false
	var roll = rng.randi_range(1, 100)
	if roll <= chance_percent:
		player_caught = true
		show_dialogue("УЧИЛКА:", "Кто это?!")
		dialogue_step = 99
		continue_after_teacher_caught_player()
	else:
		show_dialogue("ДРУГ:", "Теперь я")
		await get_tree().create_timer(2.0).timeout
		friend_shouts()
		
func friend_shouts():
	show_dialogue("ДРУГ:", "****!")
	await  get_tree().create_timer(2.0).timeout
	var roll = rng.randi_range(1,100)
	if roll <= 40:
		friend_caught = true
		show_dialogue("УЧИЛКА", "Итак, КТО КРИЧИТ!?")
		await get_tree().create_timer(2.0).timeout
		var lie_roll = rng.randi_range(1, 100)
		if lie_roll <= 40:
			show_dialogue("ДРУГ:", "Это Даня")
			await get_tree().create_timer(2.0).timeout
			show_dialogue("УЧИЛКА:", "Чтобы больше такого небыло!")
			suspicion += 15
			end_intro_cutscene()
			
		else:
			show_dialogue("ВЫ:", "Это Коля!")
			await get_tree().create_timer(2.0).timeout
			show_dialogue("УЧИЛКА", "Не обманывай! Это ты!")
			end_intro_cutscene()
	else:
		show_dialogue("СИС:", "Училка не спалила вас")
		end_intro_cutscene()
		
func continue_after_teacher_caught_player():
	show_dialogue("ВЫБОР:", "Вас спалили! Что делать?")
	show_choice(
		"Солгать(50% на удачу)",
		"Извиниться(+20 подозрения)"
	)
	dialogue_step = 100
	
func try_blame_friend():
	var roll = rng.randi_range(1, 100)
	if roll <= 50:
		show_dialogue("ВЫ:", "Это не я")
		await get_tree().create_timer(2.0).timeout
		show_dialogue("УЧИЛКА:", "Ладно")
		suspicion += 5
	else:
		show_dialogue("ВЫ:", "Это Коля!")
		await get_tree().create_timer(2.0).timeout
		show_dialogue("УЧИЛКА:", "Не ври мне!")
		suspicion += 20
	end_intro_cutscene()
		
func apologize():
	show_dialogue("ВЫ:", "Извините...")
	await get_tree().create_timer(2.0).timeout
	show_dialogue("УЧИЛКА:", "После уроков поговорим!")
	suspicion += 20
	end_intro_cutscene()
		
func end_intro_cutscene():
	await get_tree().create_timer(2.0).timeout
	show_dialogue("ЗВОНОК:", "ТЗЗЗЗ")
	await get_tree().create_timer(2.0).timeout
	$DialogueUI.visible = false
	cutscene_active = false
	$Player.leave_desk($PlayerDeskContact/ExitPoint.global_position)
	$Player.can_move = true
	$UI.visible = true
	$teacher.start_break()


func _on_next_button_pressed() -> void:
	if $DialogueUI/Panel/Choice1.visible or $DialogueUI/Panel/Choice2.visible:
		return
	next_dialogue()
	
func update_stats_ui():
	$UI/StatusUI/RespectLabel.text = '🔥: ' + str(respect)
	$UI/StatusUI/SuspicionLabel.text ='👁: ' + str(suspicion)
	check_endgame()
	
func start_interact_cooldown():
	can_interact = false
	await get_tree().create_timer(3.0).timeout
	can_interact = true
	
func prank_result():
	respect += 10
	var roll = rng.randi_range(1, 100)
	if roll <= 30:
		suspicion += 10
	else: 
		respect += 10
	update_stats_ui()
	
func call_teacher_to(target_pos: Vector2, is_crime := false):
	var action_id = $teacher.check_place(target_pos)

	while $teacher.global_position.distance_to(target_pos) > 10:
		if action_id != $teacher.current_action_id:
			return
		await get_tree().process_frame
	if is_crime:
		if $Player.is_sitting:
			respect += 25
			show_event_text("🔥")
		else:
			suspicion += 25
			show_event_text("👁")
		update_stats_ui()
	await get_tree().create_timer(5.5).timeout
	if action_id != $teacher.current_action_id:
		return
	$teacher.go_back()

func show_event_text(text):
	$UI/EventLabel.visible = true
	$UI/EventLabel.text = text
	await get_tree().create_timer(2.0).timeout
	$UI/EventLabel.visible = false
	
func check_endgame():
	if respect >= 100:
		show_end_screen(
			"ПОБЕДА!"
		)
	elif suspicion >= 100:
		show_end_screen(
			"ПОРАЖЕНИЕ!"
		)

func show_end_screen(text):
	$UI/EndScreen.visible = true
	$UI/EndScreen.color.a = 0
	$UI/EndScreen/EndLabel.text = text
	var tween = create_tween()
	tween.tween_property($UI/EndScreen, "color:a", 0.85, 1.5)
	$Player.can_move = false
	can_interact = false
