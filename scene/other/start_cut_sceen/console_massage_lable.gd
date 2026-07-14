extends Label


func animate_text(text_message: String) -> void:
	self.text = text_message
	self.visible_characters = 0
	
	# Скорость: 0.03 секунды на один символ
	var duration = text_message.length() * 0.03
	var tween = create_tween()
	
	tween.tween_property(self, "visible_characters", text_message.length(), duration)
	
	# Ждем, пока твин закончит анимацию
	await tween.finished


func kill() -> void:
	
	var tween:Tween = create_tween()
	
	tween.tween_property(self,'modulate.a',0.0,0.5)
	
