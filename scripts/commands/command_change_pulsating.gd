class_name CommandChangePulsating extends Command


var target_marker : StarMarker
var prev_is_pulsating : bool = false
var prev_pulsating_speed : float = -1.
var prev_alpha_range : Vector2 = Vector2.ZERO


func set_data(args := []) -> Dictionary:
	if args.size() != 1: return {"status": false}
	target_marker = args[0]
	prev_is_pulsating = target_marker.get_is_pulsating()
	prev_pulsating_speed = target_marker.get_pulsating_speed()
	prev_alpha_range = target_marker.get_alpha_range()
	return {"status": true}


func action(args := []) -> Dictionary:
	if !target_marker: return {"status": false}
	if args.size() != 3: return {"status": false}
	var new_is_pulsating : bool = args[0]
	var new_pulsating_speed : float = args[1]
	var new_alpha_range : Vector2 = args[2]

	target_marker.set_is_pulsating(new_is_pulsating)
	target_marker.set_pulsating_speed(new_pulsating_speed)
	target_marker.set_alpha_range(new_alpha_range)

	return {"status": true}


func undo(_args := []) -> Dictionary:
	if !target_marker: return {"status": false}
	if !prev_is_pulsating: return {"status": false}
	if !prev_pulsating_speed: return {"status": false}
	if !prev_alpha_range: return {"status": false}
	
	target_marker.set_is_pulsating(prev_is_pulsating)
	target_marker.set_pulsating_speed(prev_pulsating_speed)
	target_marker.set_alpha_range(prev_alpha_range)
	
	return {"status": true}