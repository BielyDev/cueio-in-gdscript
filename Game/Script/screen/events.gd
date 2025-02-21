extends Control

func add_text(text: String) -> void:
	var label = RichTextLabel.new()
	
	label.text = text
	label.fit_content = true
	label.scroll_active = false
	label.bbcode_enabled = true
	
	label.set("theme_override_font_sizes/normal_font_size",24)
	
	add_child(label)
	await get_tree().create_timer(5).timeout
	await create_tween().tween_property(label,"modulate:a",0,1).finished
	label.queue_free()
