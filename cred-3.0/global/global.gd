extends Node

var username: String = ""
var language: String = "1"

# === 存档数据 ===
var save_data: Dictionary = {
	"username": "",
	"scene": "",          # 当前所在的 HTML 场景路径
	"language": "1",
	"checkpoint": "",     # 精确到场景内部的阶段标识
	"playtime": 0.0,
	"clearance_level": 0
}

# 存档文件路径
const SAVE_PATH: String = "user://save_game.json"

func save_game() -> void:
	save_data["playtime"] = Time.get_ticks_msec() / 1000.0
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		print("Game saved: ", save_data)

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return false
	
	var json_string = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		save_data = json.data
		username = save_data.get("username", "")
		language = save_data.get("language", "1")
		print("Game loaded: ", save_data)
		return true
	return false

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
