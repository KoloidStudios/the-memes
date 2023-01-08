extends Node
class_name Save_system

var _index: int = 0

func _create_dict() -> Dictionary:
	return {
		"stars"   : Global.stars,
		"last_did": Global.last_did,
		"last_cp" : Global.last_cp
	}

func save() -> void:
	var file: File = File.new()
	file.open("user://save" + String(_index), File.WRITE)

	var dict: Dictionary = _create_dict()

	file.store_var(dict)
	file.close()
	
func _load_to_global(dict: Dictionary):
	Global.stars    = dict["stars"]
	Global.last_did = dict["last_did"]
	Global.last_cp  = dict["last_cp"]

func load_save(index: int) -> bool:
	var file: File = File.new()

	if file.file_exists("user://save" + String(index)):
		file.open("user://save" + String(index), File.READ)
		_load_to_global(file.get_var())
		return true
	else:
		return false

func current_slot() -> int:
	return _index
