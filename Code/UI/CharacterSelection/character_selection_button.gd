class_name CharacterSelection extends Control


@onready var btn_character: TextureButton = %btn_character

var character_data:CharacterData


func _ready() -> void:
	btn_character.pressed.connect(_btn_character_pressed)


func setup_button(data:CharacterData, _unlocked_list:Array[StringName]) -> void:
	character_data = data
	if character_data == null:
		print("Error on ", name, " character button, no data was received.")
		return
	
	if character_data.small_icon_uid != "":
		var texture:CompressedTexture2D = load(character_data.small_icon_uid)
		btn_character.texture_normal = texture
	btn_character.disabled = true
	if character_data.unlocked_by_default:
		btn_character.disabled = false
	if character_data.id in _unlocked_list:
		btn_character.disabled = false


func _btn_character_pressed() -> void:
	Signals.CharacterSelectionBtnPressed.emit(character_data)
