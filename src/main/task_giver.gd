class_name TaskGiver extends Node
var tasks : Array[Task] = []

func _ready():
	var task1 = Task.new("Mix red with yellow to get an orange substance", "FF5E00", 1)
	task1.steps.append(["Red", "Blue"])
	var task2 = Task.new("Mix black with white to get a grey substance", "808080", 2)
	var task3 = Task.new("Mix red with white to get a pink substance", "FFAEC9", 3)
	tasks.append(task1)
	tasks.append(task2)
	tasks.append(task3)
