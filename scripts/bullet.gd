extends Area2D

var velocity = Vector2(1000,0)

func _process(delta):
	position += velocity.rotated(rotation) * delta


func _on_bullet_area_entered(area):
	if area.get_groups().has("Ennemis"):
		call_deferred("queue_free")
		if area.get_groups().has("Invinsible"):
			pass
		elif area.get_groups().has("Ennemi3"):
			area.damage()
		elif area.get_groups().has("Missile"):
			area.explode()
			area.stop_timer_destruction()
		else:
			area.explode()


