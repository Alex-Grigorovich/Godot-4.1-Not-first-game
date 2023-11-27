extends Area2D

var coin_taken = false

func _on_body_entered(body):
	if not coin_taken:
		if body.name == "Player":
			var tween = get_tree().create_tween()
			tween.parallel().tween_property(self, "position", position - Vector2(0, 25), 0.3)
			tween.parallel().tween_property(self, "modulate:a", 0, 0.3)
			tween.tween_callback(queue_free)
			body.gold += 1
			coin_taken = true
