class_name CommandSelect extends Command


var previous_marker : StarMarker
var selected_marker : StarMarker


func set_data(args := []) -> Dictionary:
	if args.size() != 2: return {"status": false}
	previous_marker = args[0]
	selected_marker = args[1]
	return {"status": true}


func action(args := []) -> Dictionary:
	if args.size() != 4: return {"status": false}
	var check_button : CheckButton = args[0]
	var input : LineEdit = args[1]
	var x_input : LineEdit = args[2]
	var y_input : LineEdit = args[3]

	if previous_marker:
		previous_marker.set_selected_material(false)
	
	if selected_marker:
		selected_marker.set_selected_material(true)
		check_button.button_pressed = selected_marker.get_is_pulsating()
		input.text = str(selected_marker.get_pulsating_speed())
		x_input.text = str(selected_marker.get_alpha_range().x)
		y_input.text = str(selected_marker.get_alpha_range().y)
	else:
		check_button.button_pressed = false
		input.text = str("")
		x_input.text = str("")
		y_input.text = str("")

	return {"status": true, "selected_marker": selected_marker}


func undo(args := []) -> Dictionary:
	if args.size() != 4: return {"status": false}
	var check_button : CheckButton = args[0]
	var input : LineEdit = args[1]
	var x_input : LineEdit = args[2]
	var y_input : LineEdit = args[3]
	
	if previous_marker:
		previous_marker.set_selected_material(true)
		check_button.button_pressed = previous_marker.get_is_pulsating()
		input.text = str(previous_marker.get_pulsating_speed())
		x_input.text = str(previous_marker.get_alpha_range().x)
		y_input.text = str(previous_marker.get_alpha_range().y)
	else:
		check_button.button_pressed = false
		input.text = str("")
		x_input.text = str("")
		y_input.text = str("")
	
	if selected_marker:
		selected_marker.set_selected_material(false)

	return {"status": true, "selected_marker": previous_marker}
