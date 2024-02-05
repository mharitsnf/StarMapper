class_name HUD extends Control


@export var textbox : TextEdit
@export var save_button : Button
@export var load_button : Button
@export var notif_label : Label
@export var color_picker : ColorPicker
@export var interaction_controller : InteractionController

var marker_pscn := preload("res://scenes/star_marker.tscn")


func _ready():
	save_button.pressed.connect(_on_save)
	load_button.pressed.connect(_on_load)


func _on_save():
	if textbox.text == "": return
	
	var save_file := FileAccess.open("user://" + textbox.text + ".smap", FileAccess.WRITE)
	var markers := interaction_controller.marker_container.get_children()

	for m in markers:
		var save_data : Dictionary = m.save()
		var save_data_str = JSON.stringify(save_data)
		save_file.store_line(save_data_str)
	
	notif_label.text = "File saved!"


func _on_load():
	if textbox.text == "": return
	if not FileAccess.file_exists("user://" + textbox.text + ".smap"):
		notif_label.text = "File does not exist!"
		return
	
	# Reset data
	var markers := interaction_controller.marker_container.get_children()
	for m in markers:
		m.queue_free()
	
	interaction_controller.command_record = []

	var save_file = FileAccess.open("user://" + textbox.text + ".smap", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()

		var parse_result = json.parse(json_string)

		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		var data = json.get_data()
		var target_pos := Vector3(data.tp_x, data.tp_y, data.tp_z)
		var marker : StarMarker = marker_pscn.instantiate()
		interaction_controller.marker_container.add_child(marker)
		marker.global_position = target_pos
	
	notif_label.text = "File loaded!"


func _input(event):
	if event.is_action_pressed("toggle_hud"):
		visible = !visible
		notif_label.text = ""
