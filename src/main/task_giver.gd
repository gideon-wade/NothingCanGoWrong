class_name TaskGiver extends Node
var tasks : Array[Task] = []

func _ready():
	var task1 = Task.new("Mix Oceamid with Redamin to get Grass Juice", "Grass Juice", 1)
	var task2 = Task.new("Mix Grass Juice with Apple Juice to get Cadrulium", "Cadrulium", 2)
	var task3 = Task.new("Mix Cadrulium with Grass Juice to get Princiade", "Princiade", 3)
	var task4 = Task.new("Mix Princiade with Oceamid to get Dracula's Blood", "Dracula's Blood", 4)
	var task5 = Task.new("Mix Dracula's Blood with Apple Juice to get Laudle", "Laudle", 5)
	tasks.append(task1)
	tasks.append(task2)
	tasks.append(task3)
	tasks.append(task4)
	tasks.append(task5)
