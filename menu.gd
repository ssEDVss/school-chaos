extends Control

#Большинство коментариев здесь написано дабы самому научится понимать что значит команда, ибо я только учусь



var next_scene_path := ""                          #Это значит что штука пустая изначально

#При входе(такую же штуку можно встретить почти любой .gd)
func _ready():                                     #Когда сцена загрузилась
	await get_tree().process_frame                 #Обожди кадр и выполяй
	$AnimationPlayer.play("fade_in")               #Играй анимацию (Осветление)
	$Music.play()

#Анимация перехода, хз почему, но работает у меня она только тут...
func _on_playbtn_pressed() -> void:                #Кнопка играть нажата
	next_scene_path = "res://classroom.tscn"       #Присвоить той штуке сверху значение сцены класса
	$AnimationPlayer.play("fade_out")              #Играть анимацию затемнения
func _on_animation_player_animation_finished(anim_name: StringName) -> void:  #Функция когда анимация закончилась
	if anim_name == "fade_out" and next_scene_path != "":     #Если Сейчас идёт анимация Затемнения и значение штуки не пустое
		get_tree().change_scene_to_file(next_scene_path)      #Выполнить переход на следующую сцену

#Кнопка Выхода
func _on_exitbtn_pressed() -> void:   #Кнопка выхода нажата
	get_tree().quit()                 #Выполнить Выход

#Только когда мышкой наводишься
func _on_playbtn_mouse_entered() -> void:                           #Мышка в зоне кнопки играть
	$Playbtn/Sprite2D.texture = preload("res://btnplayon.png")      #Подгрузить картинку подсветки
func _on_playbtn_mouse_exited() -> void:                            #Мышка вышла с зоны Играть
	$Playbtn/Sprite2D.texture = preload("res://btnplayoff.png")     #Подгрузить картинку обычную
func _on_exitbtn_mouse_entered() -> void:                           #Мышка в зоне Выход
	$Exitbtn/Sprite2Dexit.texture = preload("res://btnexiton.png")  #Подгрузить картинку Подсветки
func _on_exitbtn_mouse_exited() -> void:                            #Мышка вне зоны Выйти
	$Exitbtn/Sprite2Dexit.texture = preload("res://btnexitoff.png") #Подгрузить картинку Обычную

#При нажатии (мышкой, пальцем)
func _on_playbtn_button_down() -> void:                                #Кнопка Играть нажата
	$Playbtn/Sprite2D.texture = preload("res://btnplayon.png")         #Подгрузить картинку подсветки
func _on_playbtn_button_up() -> void:                                  #Кнопка Играть отпущена
	$Playbtn/Sprite2D.texture = preload("res://btnplayoff.png")        #Подгрузить картинку обычную
func _on_exitbtn_button_down() -> void:                                #Кнопка Выход нажата
	$Exitbtn/Sprite2Dexit.texture = preload("res://btnexiton.png")     #Подгрузить картинку подсветки
func _on_exitbtn_button_up() -> void:                                  #Кнопка Выход отпущена
	$Exitbtn/Sprite2Dexit.texture = preload("res://btnexitoff.png")    #Подгрузить картинку обычную
