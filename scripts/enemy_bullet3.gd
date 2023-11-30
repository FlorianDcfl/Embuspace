extends Area2D

var velocity = Vector2(250,0)


func _process(delta):
	position += velocity * delta
	

func _on_Area2D_area_entered(area):
	if area.get_groups().has("Player") :
		queue_free()
		area.damage()
