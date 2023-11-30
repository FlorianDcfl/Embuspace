extends Node

var scorePlayer = 0

var savegame = File.new() #file
var save_path = "user://savegame.save" #place of the file
var save_data = [] #variable to store data

#
func _ready():
	if not savegame.file_exists(save_path):
		create_save()


func create_save():
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()


func save(high_score):
	save_data.append(high_score) #data to save
	savegame.open(save_path, File.WRITE) #open file to write
	savegame.store_var(save_data) #store the data
	savegame.close() # close the file
	

func read_savegame():
	savegame.open(save_path, File.READ) #save the file
#	save_data.sort_custom(self, "customComparison")
	save_data = savegame.get_var() #get the value
	savegame.close() #close the file
	return save_data #return the value
	

func customComparison(a, b):
	if a["score"] > b["score"]:
		return true
	return false
	
	
