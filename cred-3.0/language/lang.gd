extends Control
@onready var web_view: WebView = $WebView

func _ready() -> void:
	web_view.ipc_message.connect(_on_ipc)
	
	
func _on_ipc(message: String):
	if message == "window_ready":
		send_language()

func send_language() -> void:
	var all_texts = {}
	
	if Global.language == "1":
		all_texts = {
			"login_btn": "登录",
			"username_placeholder": "用户名"
		}
	else:
		all_texts = {
			"login_btn": "Login",
			"username_placeholder": "Username"
		}
	
	web_view.post_message("lang_data:" + JSON.stringify(all_texts))
