extends Control

@onready var web_view: WebView = $WebView

var pending_card: String = ""   # 暂存待显示的卡片

func _ready() -> void:
	web_view.ipc_message.connect(_on_ipc)

func _on_ipc(message: String):
	if message.begins_with("login:"):
		Global.username = message.substr(6)
		print("用户登录: ", Global.username)
		web_view.load_url("res://html/start.html")
		return
	
	match message:
		"start":
			web_view.load_url("res://html/test.html")
		
		"go_to_next_scene":
			web_view.load_url("res://html/window.html")
		
		"tr_hb":
			web_view.load_url("res://html/hb.html")
		
		"hb3":
			web_view.load_url("res://html/hb3.html")
		
		"true":
			web_view.load_url("res://html/true_chose.html")
		
		"c2":
			web_view.load_url("res://html/C2.html")
			print("tr")
