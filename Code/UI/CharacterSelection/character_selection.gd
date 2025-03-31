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
@onready var diff_buttons:Array[TextureButton] = [%btn_difficulty_0, %btn_difficulty_1, %btn_difficulty_2, %btn_difficulty_3]
@onready var debug: PanelContainer = %debug
@onready var debug_level: OptionButton = %debug_level
@onready var debug_option: OptionButton = %debug_option
@onready var spacer: Control = %spacer


var manager:MangerManager:
	get:
		if manager == null: manager = get_tree().get_first_node_in_group(&"Manager")
		if manager == null: print("Manager is null.")
		return manager

var selected_character:CharacterData
var select_buttons:Array[CharacterSelection] = []
var selected_difficulty:int = 1
var debug_level_selected:StringName = &""
var debug_obj_selected:StringName = &""


func _ready() -> void:
	Signals.CharacterSelectionBtnPressed.connect(_select_character)
	btn_start.pressed.connect(_btn_start_pressed)
	_build_selection_buttons()
	_select_first_available_button()
	_setup_buttons()
	_setup_difficulty()
	if manager.debug:
		spacer.hide()
		debug.show()
		debug_level.item_selected.connect(_debug_level_changed)
		debug_option.item_selected.connect(_debug_objective_changed)
	else: 
		debug.hide()
		spacer.show()
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
	Signals.ResetRun.emit()
	Signals.SetCharacter.emit(selected_character)
	Signals.SetDifficulty.emit(selected_difficulty)
	if not manager.debug:
		Signals.LoadScene.emit(manager.scene_manager.levels.get_random_level(), display_loading_on_start)
	else:
		print("debug_obj_selected ", debug_obj_selected)
		print("debug_level_selected ", debug_level_selected)
		if debug_obj_selected != &"": Signals.DebugObjectiveSelect.emit(debug_obj_selected)
		if debug_level_selected == &"":
			Signals.LoadScene.emit(manager.scene_manager.levels.get_random_level(), display_loading_on_start)
		else:
			Signals.LoadScene.emit(debug_level_selected, display_loading_on_start)
		

func _select_first_available_button() -> void:
	for button in select_buttons:
		if not button.btn_character.disabled:
			_select_character(button.character_data)
			button.btn_character.grab_focus()


func _setup_buttons() -> void:
	for btn in diff_buttons:
		btn.pressed.connect(_difficulty_btn_pressed.bind(btn.get_meta(&"difficulty")))


func _setup_difficulty() -> void:
	selected_difficulty = manager.save_load.current_save.current_difficulty
	diff_buttons[selected_difficulty].set_pressed_no_signal(true)


func _difficulty_btn_pressed(difficulty:int) -> void:
	for btn in diff_buttons:
		if btn.has_meta(&"difficulty") and btn.get_meta(&"difficulty") != difficulty:
			btn.set_pressed_no_signal(false)
		elif btn.has_meta(&"difficulty") and btn.get_meta(&"difficulty") == difficulty:
			selected_difficulty = btn.get_meta(&"difficulty")
			print("Difficulty selected: ", selected_difficulty)
			

func _debug_level_changed(value:int) -> void:
	if value == 0: debug_level_selected = &""
	else: debug_level_selected = debug_level.get_item_text(value)
	

func _debug_objective_changed(value:int) -> void:
	if value == 0: debug_obj_selected = &""
	else: debug_obj_selected = debug_option.get_item_text(value)
