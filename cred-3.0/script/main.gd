extends Control

@onready var web_view: WebView = $WebView

var pending_card: String = ""

func _ready() -> void:
	web_view.ipc_message.connect(_on_ipc)

func _on_ipc(message: String):
	if message.begins_with("login:"):
		Global.username = message.substr(6)
		Global.save_data["username"] = Global.username
		Global.save_data["scene"] = "res://html/start.html"
		Global.save_data["checkpoint"] = "login_complete"
		Global.save_game()  # 📌 登录后存档
		print("用户登录: ", Global.username)
		web_view.load_url("res://html/start.html")
		return
	
	if message.begins_with("settings:"):
		var action = message.substr(9)
		match action:
			"continue":
				if Global.load_game():
					_restore_from_save()
					return
				# 无存档时，继续当前页面（不做任何跳转）
			"new_game":
				Global.save_data = {
					"username": "",
					"scene": "res://html/test.html",
					"language": Global.language,
					"checkpoint": "",
					"playtime": 0.0,
					"clearance_level": 0
				}
				Global.save_game()
				web_view.load_url("res://html/test.html")
			"save_quit":
				Global.save_game()
				get_tree().quit()
			"quit":
				get_tree().quit()
		return
	
	match message:
		"start":
			Global.save_data["scene"] = "res://html/start.html"
			Global.save_data["checkpoint"] = "tutorial_screen"
			Global.save_game()
			web_view.load_url("res://html/start.html")
		
		"go_to_next_scene":
			Global.save_data["scene"] = "res://html/window.html"
			Global.save_data["checkpoint"] = "window_initial"
			Global.save_game()
			web_view.load_url("res://html/window.html")
		
		"tr_hb":
			Global.save_data["scene"] = "res://html/hb.html"
			Global.save_data["checkpoint"] = "hb_manifesto"
			Global.save_game()
			web_view.load_url("res://html/hb.html")
		
		"hb3":
			Global.save_data["scene"] = "res://html/hb3.html"
			Global.save_data["checkpoint"] = "hb3_coma"
			Global.save_game()
			web_view.load_url("res://html/hb3.html")
		
		"true":
			Global.save_data["scene"] = "res://html/true_chose.html"
			Global.save_data["checkpoint"] = "true_chose_reveal"
			Global.save_game()
			web_view.load_url("res://html/true_chose.html")
		
		"c2":
			Global.save_data["scene"] = "res://html/C2.html"
			Global.save_data["checkpoint"] = "c2_desktop"
			Global.save_game()
			web_view.load_url("res://html/C2.html")
		
		# 处理 test.html 的选项选择（A/B/C）
		"A", "B", "C":
			Global.save_data["checkpoint"] = "training_choice_" + message
			Global.save_game()

func _restore_from_save():
	"""根据存档恢复场景"""
	var scene = Global.save_data.get("scene", "res://html/test.html")
	web_view.load_url(scene)
	await get_tree().create_timer(1.0).timeout
	_push_checkpoint_to_html()

func _push_checkpoint_to_html():
	"""将存档的 checkpoint 推入当前页面的 JS 全局变量"""
	var checkpoint = Global.save_data.get("checkpoint", "")
	if checkpoint == "":
		return
	web_view.execute_script(
		"if(typeof window.restoreCheckpoint === 'function') window.restoreCheckpoint('" + checkpoint + "');"
	)
