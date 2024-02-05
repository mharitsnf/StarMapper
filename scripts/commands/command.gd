class_name Command extends Node


func set_data(_args : Array = []) -> bool:
    return true

func action(_args : Array = []) -> bool:
    return true

func undo(_args : Array = []) -> bool:
    return true

func destroy() -> bool:
    return true