extends Node

onready var score = get_node("/root/score")

var i = 0


func _ready():
	$Control/scoreFinal.text = "Your score : " + str(score.scorePlayer)
	
	displayScoreboard()

	
func _process(delta):
	pass


func _input(event):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
			
func _on_txtNom_text_entered():
	self.addNewScore()

func _on_BtSubmit_button_down():
	self.addNewScore()
	self.displayScoreboard()
	$Control/txtNom.editable = false
	$Control/BtSubmit.disabled = true


func _on_BtRestart_button_down():
	score.scorePlayer = 0
	get_tree().change_scene("scenes/main.tscn")
	

func addNewScore():
	score.save({"name": $Control/txtNom.text, "score": score.scorePlayer})


func displayScoreboard():
	score.read_savegame()
	$Control/positions.text = ""
	$Control/noms.text = ""
	$Control/scores.text = ""
	score.save_data.sort_custom(self, "customComparison")
	for x in score.save_data:
		i = score.save_data.find(x)
		if i < 8 :
			$Control/positions.text += str(i+1,"\n")
			$Control/noms.text += str(score.save_data[i].get("name"),"\n")
			$Control/scores.text += str(score.save_data[i].get("score"),"\n")


func customComparison(a, b):
	if a["score"] > b["score"]:
		return true
	return false

func _on_txtNom_text_changed(new_text):
	if $Control/txtNom.text != "":
		$Control/BtSubmit.disabled = false
	else:
		$Control/BtSubmit.disabled = true


func _on_BtQuit_button_down():
	get_tree().change_scene("scenes/menu.tscn")


func _on_BtCommands_mouse_entered():
	$commands.visible = true


func _on_BtCommands_mouse_exited():
	$commands.visible = false
