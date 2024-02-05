class_name HUD extends Control


@export var filename_input : LineEdit
@export var save_button : Button
@export var load_button : Button
@export var notif_label : Label
@export var is_pulsating_button : CheckButton
@export var pulsating_speed_input : LineEdit
@export var pulsating_apply : Button
@export var x_value_input : LineEdit
@export var y_value_input : LineEdit
@export var color_picker : ColorPicker
@export var interaction_controller : InteractionController

var is_active : bool = true

var marker_pscn := preload("res://scenes/star_marker.tscn")


func _enter_tree():
	add_to_group("hud")


func _ready():
	save_button.pressed.connect(_on_save)
	load_button.pressed.connect(_on_load)
	pulsating_apply.pressed.connect(_on_pulsating_applied)


func _on_save():
	if filename_input.text == "": return
	
	var save_file := FileAccess.open("user://" + filename_input.text + ".smap", FileAccess.WRITE)
	var markers := interaction_controller.marker_container.get_children()

	for m in markers:
		var save_data : Dictionary = m.save()
		var save_data_str = JSON.stringify(save_data)
		save_file.store_line(save_data_str)
	
	notif_label.text = "File saved!"


func _on_load():
	if filename_input.text == "": return
	if not FileAccess.file_exists("user://" + filename_input.text + ".smap"):
		notif_label.text = "File does not exist!"
		return
	
	# Reset data
	var markers := interaction_controller.marker_container.get_children()
	for m in markers:
		m.queue_free()
	
	interaction_controller.command_record = []

	var save_file = FileAccess.open("user://" + filename_input.text + ".smap", FileAccess.READ)
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


func _on_pulsating_applied():
	var target_marker := interaction_controller.get_current_marker()
	if !target_marker: return

	var new_command = CommandChangePulsating.new()
	var cmd_res := new_command.set_data([target_marker])
	if !cmd_res.status:
		print("Error: set data failed")
		return
	
	cmd_res = new_command.action([
		is_pulsating_button.button_pressed,
		max(float(pulsating_speed_input.text), 0.),
		Vector2(
			clamp(float(x_value_input.text), 0., 1.),
			clamp(float(y_value_input.text), 0., 1.),
		)
	])
	if !cmd_res.status:
		print("Error: change pulsating data failed")
		return
	
	interaction_controller.add_command(new_command)


func get_is_active():
	return is_active


func _set_is_active(value : bool):
	visible = value
	is_active = value
	notif_label.text = ""


func _input(event):
	if event.is_action_pressed("toggle_hud"):
		_set_is_active(!visible)
