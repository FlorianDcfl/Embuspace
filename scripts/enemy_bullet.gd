extends Area2D

var velocity = Vector2(500,0)

func _ready():
	pass
	
	
func _process(delta):
	position += velocity.rotated(rotation) * delta


func _on_Area2D_area_entered(area):
	if area.get_groups().has("Player") :
		queue_free()
		area.damage()
