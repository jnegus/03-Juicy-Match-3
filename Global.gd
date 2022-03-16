extends Node

var change_level = false
var current_level = 0
var levels = [
	{
		"unlocked": true,
		"high score": 0,
		"stars unlocked": 0,
		"moves":20,
		"goal": [{ "piece":"orange", "max":5, "count":0 }],
		"level": "level 1",
		"instructions": "match 5 orange cats"
	}
	,{
		"unlocked": true,
		"high score": 0,
		"stars unlocked": 0,
		"moves":20,
		"goal": [{ "piece":"gray", "max":5, "count":0 },{ "piece":"black", "max":5, "count":0 }],
		"level": "level 2",
		"instructions": "match 5 gray cats and 5 black cats"
	}
	,{
		"unlocked": true,
		"high score": 0,
		"stars unlocked": 0,
		"moves":20,
		"goal": [{ "piece":"calico", "max":10, "count":0 },{ "piece":"brown", "max":5, "count":0 },{ "piece":"orange", "max":8, "count":0 }],
		"level": "level 3",
		"instructions": "match 10 calico cats, 5 brown \n cats, and 8 orange cats"
	}
	,{
		"unlocked": true,
		"high score": 0,
		"stars unlocked": 0,
		"moves":20,
		"goal": [{ "piece":"gray", "max":12, "count":0 },{ "piece":"orange", "max":8, "count":0 },{ "piece":"black", "max":12, "count":0 }],
		"level": "level 4",
		"instructions": "match 12 gray cats, 8 orange \n cats, and 12 black cats"
	}
	,{
		"unlocked": true,
		"high score": 0,
		"stars unlocked": 0,
		"moves":20,
		"goal": [{ "piece":"brown", "max":20, "count":0 },{ "piece":"calico", "max":15, "count":0 },{ "piece":"gray", "max":15, "count":0 }],
		"level": "level 5",
		"instructions": "match 20 brown cats, 15 calico \n cats, and 15 gray cats"
	}
]


var score = 0
var moves = 20
var goal = []
signal changed
var scores = {
	0:0,
	1:0,
	2:0,
	3:10,
	4:20,
	5:50,
	6:100,
	7:200,
	8:300,
	9:1000
}

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func reset():
	score = 0
	moves = 20
	goal = []
	current_level = 0

func _process(_delta):
	if change_level:
		var Grid = get_node_or_null("/root/Game/Grid")
		if Grid != null and not Grid.move_checked:
			change_level = false
			update_level(current_level+1)

func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()

func change_score(s):
	score += s
	emit_signal("changed")

func change_moves(m):
	moves += m
	if moves <= 0:
		var _scene = get_tree().change_scene("res://UI/Lose.tscn") 
	emit_signal("changed")

func update_level(l):
	if l < 0 or l >= levels.size():
		var _scene = get_tree().change_scene("res://UI/Win.tscn") 
	else:
		var Level = get_node_or_null("/root/Game/UI/Level")
		if Level != null:
			Level.show_level(levels[l].level, levels[l].instructions)
		moves = levels[l].moves
		goal = levels[l].goal.duplicate(true)
		current_level = l
		update_goals("")

func update_goals(piece):
	var sound_1 = null
	if sound_1 == null:
		sound_1 = get_node_or_null("/root/Game/1")
	if sound_1 != null:
		sound_1.play()
	for g in goal:
		if piece == g["piece"] and g["count"] < g["max"]:
			g["count"] += 1
	var Goals = get_node_or_null("/root/Game/UI/Goals")
	if Goals != null:
		Goals.show_goals()
	var check_level = true
	for g in goal:
		if g["count"] < g["max"]:
			check_level = false
	if check_level:
		change_level = true
		
