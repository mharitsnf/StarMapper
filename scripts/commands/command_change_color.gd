class_name CommandChangeColor extends Command


var target_marker : StarMarker
var prev_color : Color


func set_data(args := []) -> Dictionary:
	if args.size() != 1: return {"status": false}
	target_marker = args[0]
	prev_color = target_marker.get_color()
	return {"status": true}


func action(args := []) -> Dictionary:
	if !target_marker: return {"status": false}
	if args.size() != 1: return {"status": false}
	var new_color : Color = args[0]

	target_marker.set_color(new_color)

	return {"status": true}


func undo(_args := []) -> Dictionary:
	if !target_marker: return {"status": false}
	if !prev_color: return {"status": false}
	target_marker.set_color(prev_color)
	return {"status": true}