class_name PauseMenu extends Control


@onready var btn_pause_menu_close: Button = %btn_pause_menu_close

var focused:bool = false


func _ready() -> void:
	btn_pause_menu_close.pressed.connect(_btn_pause_menu_close_pressed)


func toggle_pause_menu(value:bool = false) -> void:
	if value: 
		show()
		focused = true
	else:
		focused = false
		hide()


func _btn_pause_menu_close_pressed() -> void:
	get_tree().paused = false
	toggle_pause_menu()
	
