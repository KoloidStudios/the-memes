extends Node2D
class_name Dialog_player

signal finished
# Definitely not my code

onready var _body_text:      Label           = get_node("dialog_box/body_rect/label_container/label")
onready var _body_animation: AnimationPlayer = get_node("dialog_box/body_rect/label_container/label/animation")
onready var _player_label:   Label           = get_node("dialog_box/body_rect/player_rect/label")
onready var _player_texture: TextureRect     = get_node("dialog_box/body_rect/player_rect/texture")
onready var _npc_label:      Label           = get_node("dialog_box/body_rect/npc_rect/label")
onready var _npc_texture:    TextureRect     = get_node("dialog_box/body_rect/npc_rect/texture")
onready var _confirm_label:  Label           = get_node("dialog_box/body_rect/confirm_container/label")
onready var _confirm_box:    MarginContainer = get_node("dialog_box/body_rect/confirm_container")
onready var _option_list:    VBoxContainer   = get_node("dialog_box/body_rect/option_list")
onready var _dialog_box:     Control         = get_node("dialog_box")
onready var _registry:       Node2D          = get_node("registry")

onready var Option:       Resource = load("res://src/dialog/option.tscn")
onready var Story_reader: Resource = load("res://addons/EXP-System-Dialog/Reference_StoryReader/EXP_StoryReader.gd")

var _did:       int = 1
var _nid:       int = 0
var _final_nid: int = 0

var _is_player:       String     = ""
var _option_mode:     bool       = false
var _story_reader:    Reference  = null
var _texture_library: Dictionary = {}

var _option_callbacks: Dictionary = {}
# Virtual Methods

func _ready():
	_story_reader = Story_reader.new()

	var story = load("res://src/dialog/stories/the_memes_baked.tres")
	_story_reader.read(story)
	
	_load_textures({
		"1" : "res://src/dialog/characters/marisad.png"
	})
	
	_confirm_box.visible = false
	_option_list.visible = false
	_dialog_box.visible = false

	_player_texture.visible = false
	_npc_texture.visible = false
	
	_clear_options()

func _process(_delta):
	if (Input.is_action_just_pressed("c")):
		_on_dialog_pressed_spacebar()

# Callback Methods

func _on_body_animation_animation_finished(anim_name: String) -> void:
	if _option_list.get_child_count() == 0:
		_confirm_label.text = "Press C to continue"
	else:
		_option_mode = true
		_confirm_label.text = "Select options"
		_option_list.visible = true
		_option_list.get_child(0).focus()
		for c in _option_list.get_children():
			c.connect("clicked", self, "_on_option_clicked")
	_confirm_box.visible = true


func _on_dialog_pressed_spacebar():
	if _is_waiting() and !_option_mode:
		_confirm_box.visible = false
		_player_texture.visible = false
		_npc_texture.visible = false
		_get_next_node()
		if _is_playing():
			_play_node()


func _on_option_clicked(slot : int):
	_confirm_box.visible = false
	_option_list.visible = false
	_player_texture.visible = false
	_npc_texture.visible = false
	_option_mode = false
	if (_option_callbacks[String(slot)] != ""):
		Global.call_deferred(_option_callbacks[String(slot)], self)
	_get_next_node(slot)
	_clear_options()
	if _is_playing():
		_play_node()

# Public Methods

func play_dialog(did: int) -> void:
	_did = did
	_nid = _story_reader.get_nid_via_exact_text(_did, "<start>")
	_final_nid = _story_reader.get_nid_via_exact_text(_did, "<end>")
	_get_next_node()
	_play_node()
	_dialog_box.visible = true

# Private Methods

func _clear_options():
	var children = _option_list.get_children()
	for child in children:
		_option_list.remove_child(child)
		child.queue_free()
	_option_list.rect_size.y = 48
	_option_list.rect_position.y = -60

func _display_image(key : String):
	if _is_player == "":
		_npc_texture.texture = _texture_library[key]
		_npc_texture.visible = true
	else:
		_player_texture.texture = _texture_library[key]
		_player_texture.visible = true

func _get_next_node(slot : int = 0):
	_nid = _story_reader.get_nid_from_slot(_did, _nid, slot)
	
	if _nid == _final_nid:
		_dialog_box.visible = false
		emit_signal("finished")

func _get_tagged_text(tag : String, text : String):
	var start_tag = "<" + tag + ">"
	var end_tag = "</" + tag + ">"
	var start_index = text.find(start_tag) + start_tag.length()
	var end_index = text.find(end_tag)
	var substr_length = end_index - start_index
	return text.substr(start_index, substr_length)

func _get_functions(text: String) -> Dictionary:
	var options = _get_tagged_text("functions", text)
	if (options != ""):
		print_debug(options)
		return parse_json(options)
	else:
		return {}

func _inject_variables(text : String) -> String:
	var variable_count = text.count("<variable>")
	
	for i in range(variable_count):
		var variable_name = _get_tagged_text("variable", text)
		var variable_value = _registry.lookup(variable_name)
		var start_index = text.find("<variable>")
		var end_index = text.find("</variable>") + "</variable>".length()
		var substr_length = end_index - start_index
		text.erase(start_index, substr_length)
		text = text.insert(start_index, str(variable_value))
	
	return text


func _is_playing():
	return _dialog_box.visible


func _is_waiting():
	return _confirm_box.visible


func _load_textures(raw_texture_library: Dictionary):
	for key in raw_texture_library:
		var texture_path = raw_texture_library[key]
		var loaded_texture = load(texture_path)
		_texture_library[key] = loaded_texture

func _play_node():
	var text = _story_reader.get_text(_did, _nid)
	text = _inject_variables(text)
	_option_callbacks = _get_functions(text)
	_is_player = _get_tagged_text("player", text)
	var speaker = _get_tagged_text("speaker", text)
	var dialog = _get_tagged_text("dialog", text)
	if "<choiceJSON>" in text:
		var options = _get_tagged_text("choiceJSON", text)
		_populate_choices(options)
	if "<image>" in text:
		var library_key = _get_tagged_text("image", text)
		_display_image(library_key)
	
	$dialog_box/body_rect/player_rect.visible = false
	$dialog_box/body_rect/npc_rect.visible = false
	if (_is_player != ""):
		$dialog_box/body_rect/player_rect.visible = true
		_player_label.text = speaker
	else:
		$dialog_box/body_rect/npc_rect.visible = true
		_npc_label.text = speaker
	_body_text.text = dialog
	_body_animation.play("TextDisplay")


func _populate_choices(JSONtext : String):
	var choices : Dictionary = parse_json(JSONtext)
	
	for text in choices:
		var slot: String = choices[text]
		var new_option_button: Option = Option.instance()
		_option_list.add_child(new_option_button)
		new_option_button.name = text
		new_option_button.slot = slot
		new_option_button.set_text(text)
