extends Node


func _on_bt_start_pressed():
	get_tree().change_scene("scenes/main.tscn")


func _on_bt_commands_mouse_entered():
	$Control/commands.visible = true


func _on_bt_commands_mouse_exited():
	$Control/commands.visible = false


func _on_bt_quit_pressed():
	get_tree().quit()


func _on_bt_scoreboard_pressed():
	get_tree().change_scene("scenes/scoreboard.tscn")
