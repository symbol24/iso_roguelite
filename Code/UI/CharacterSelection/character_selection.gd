class_name CharacterSelectionMenu extends Control


const BUTTON:PackedScene = preload("uid://cyhs3gxheenpt")


@export var character_list:CharacterList
@export var start_destination:StringName = ""
@export var display_loading_on_start:bool = true

@onready var character_buttons_hbox: HBoxContainer = %character_buttons_hbox
@onready var large_character_image: TextureRect = %large_character_image
@onready var character_name_label: Label = %character_name_label
@onready var character_detail_rtl: RichTextLabel = %character_detail_rtl
@onready var btn_start: Button = %btn_start

var manager:MangerManager:
	get:
		if manager == null: manager = get_tree().get_first_node_in_group(&"Manager")
		if manager == null: print("Manager is null.")
		return manager

var selected_character:CharacterData
var select_buttons:Array[CharacterSelection] = []


func _ready() -> void:
	Signals.CharacterSelectionBtnPressed.connect(_select_character)
	btn_start.pressed.connect(_btn_start_pressed)
	_build_selection_buttons()
	_select_first_available_button()
	Signals.ToggleLoadingScreen.emit(false)


func _select_character(character_data:CharacterData) -> void:
	selected_character = character_data
	if selected_character != null:
		if selected_character.large_icon_uid != "":
			large_character_image.texture = load(selected_character.large_icon_uid) as CompressedTexture2D
		character_name_label.text = tr(selected_character.loc_display_name) if selected_character.loc_display_name != "" else selected_character.debug_display_name
		character_detail_rtl.text = tr(selected_character.loc_description) if selected_character.loc_description != "" else selected_character.debug_description


func _build_selection_buttons() -> void:
	if manager != null and character_list != null:
		for character:CharacterData in character_list.characters:
			var button:CharacterSelection = BUTTON.instantiate()
			character_buttons_hbox.add_child(button)
			if not button.is_node_ready(): await button.ready
			button.name = "btn_character_" + character.id
			button.setup_button(character, manager.save_load.current_save.unlocked_characters)
			select_buttons.append(button)


func _btn_start_pressed() -> void:
	Signals.SetCharacter.emit(selected_character.id)
	Signals.LoadScene.emit(start_destination, display_loading_on_start)


func _select_first_available_button() -> void:
	for button in select_buttons:
		if not button.btn_character.disabled:
			_select_character(button.character_data)
			button.btn_character.grab_focus()
