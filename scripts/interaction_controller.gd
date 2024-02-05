class_name InteractionController extends Node3D


@export var time_controller : TimeController
@export var camera : Camera3D
@export var marker_container : Node
var command_record := []
var current_marker : StarMarker


func _enter_tree():
	marker_container.add_to_group("marker_container")


func _physics_process(_delta):
	if Input.is_action_just_pressed("select"):
		var res := _query_raycast(2)
		if res.is_empty():
			_set_selected_marker(null)
			return
		
		_set_selected_marker(res.collider.get_parent())

	# Create marker
	if Input.is_action_just_pressed("place_marker"):
		var res := _query_raycast(1)
		if res.is_empty(): return
		
		var new_command := CommandCreate.new()
		var status := new_command.set_data([marker_container, res.position])
		if !status:
			print("Error: set data failed")
			return
		
		status = new_command.action()
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
		var status := new_command.set_data([marker_container, target_marker])
		if !status:
			print("Error: set data failed")
			return
		
		status = new_command.action()
		if !status:
			print("Error: delete marker failed")
			return 
		
		command_record.append(new_command)


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
		var status := command.undo()
		if !status:
			print("Error: undo failed")
			return
		
		command.destroy()
