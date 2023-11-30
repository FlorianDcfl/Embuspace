extends Node2D


func _process(delta):
	if Input.is_action_just_pressed("mitrailleuse"):
		$Particles2D.position = get_global_mouse_position()
		$Particles2D.emitting = true
		$Particles2D/Particles2D.emitting = true
		$Particles2D/Particles2D2.emitting = true