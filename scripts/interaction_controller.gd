class_name InteractionController extends Node3D


@export_category("References")
@export_group("UI")
@export var pulsating_button : CheckButton
@export var pulsating_speed_input : LineEdit
@export var x_value_input : LineEdit
@export var y_value_input : LineEdit
@export_group("3D Nodes")
@export var time_controller : TimeController
@export var camera : Camera3D
@export var marker_container : Node

var hud : HUD
var command_record := []
var current_marker : StarMarker


func _enter_tree():
	marker_container.add_to_group("marker_container")


func _ready():
	hud = get_tree().get_first_node_in_group("hud")


func _physics_process(_delta):
	if hud.get_is_active(): return
	if Input.is_action_just_pressed("select"):
		var res := _query_raycast(2)

		var new_selected : StarMarker = null if res.is_empty() else res.collider.get_parent()

		if current_marker == null and new_selected == null: return
		
		var new_command := CommandSelect.new()
		var cmd_res = new_command.set_data([current_marker, new_selected])
		if !cmd_res.status:
			print("Error: set data failed")
			return
		
		cmd_res = new_command.action([pulsating_button, pulsating_speed_input, x_value_input, y_value_input])
		if !cmd_res.status:
			print("Error: set selection failed")
			return
		
		current_marker = cmd_res.selected_marker
		command_record.append(new_command)

	# Create marker
	if Input.is_action_just_pressed("place_marker"):
		var res := _query_raycast(1)
		if res.is_empty(): return
		
		var new_command := CommandCreate.new()
		var status : bool = new_command.set_data([marker_container, res.position]).status
		if !status:
			print("Error: set data failed")
			return
		
		status = new_command.action().status
		if !status:
			print("Error: create marker failed")
			return 
		
		command_record.append(new_command)

	# Delete marker
	if Input.is_action_just_pressed("delete_marker"):
		var res := _query_raycast(2)
		if res.is_empty(): return
		
		var new_command = CommandDelete.new()
		var target_marker : StarMarker = res.collider.get_parent()
		var status : bool = new_command.set_data([marker_container, target_marker]).status
		if !status:
			print("Error: set data failed")
			return
		
		status = new_command.action().status
		if !status:
			print("Error: delete marker failed")
			return 
		
		command_record.append(new_command)


func get_current_marker() -> StarMarker:
	return current_marker


func _set_selected_marker(new_marker : StarMarker):
	if current_marker:
		current_marker = null
	
	if new_marker:
		current_marker = new_marker
	
	print(current_marker)


func _query_raycast(col_mask : int) -> Dictionary:
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var from := camera.project_ray_origin(mousepos)
	var to := from + camera.project_ray_normal(mousepos) * 1000.
	var query := PhysicsRayQueryParameters3D.create(from, to, col_mask)

	return space_state.intersect_ray(query)


func _unhandled_input(event):
	if event.is_action_pressed("ui_undo") and command_record.size() > 0:
		var command : Command = command_record.pop_back()

		var cmd_res : Dictionary
		if command is CommandSelect: cmd_res = command.undo([pulsating_button, pulsating_speed_input, x_value_input, y_value_input])
		else: cmd_res = command.undo()
		
		if !cmd_res.status:
			print("Error: undo failed")
			return
		
		if command is CommandSelect:
			current_marker = cmd_res.selected_marker
		
		command.destroy()
