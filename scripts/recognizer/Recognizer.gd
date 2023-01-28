extends Node

const INPUT_LIMIT = 20
const NUM_SYMBOLS = 8

var events = {}
var line: Array[Vector2] = []
var angles: Array[float] = []
var NN: NeuralNetwork = NeuralNetwork.new()

var curr_symbol = 0
var inputs = [
	#H_LINE_R
	[
	],
	#H_LINE_L
	[
	],
	#V_LINE_R
	[
	],
	#V_LINE_L
	[
	],
	#CARET_UP_R
	[
	],
	#CARET_UP_L
	[
	],
	#CARET_DOWN_R
	[
	],
	#CARET_DOWN_L
	[
	],
]

enum SYMBOL {
	H_LINE_R, H_LINE_L, V_LINE_R, V_LINE_L, CARET_UP_R, CARET_UP_L, CARET_DOWN_R, CARET_DOWN_L
}

func _ready():
	NN.set_nn_data(INPUT_LIMIT, 20, NUM_SYMBOLS)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				for i in range(NUM_SYMBOLS):
					print(inputs[i])
				#train()
			return
		if event.pressed and events.size() == 0:
			events[event.button_index] = event
			line = []
		else:
			events.erase(event.button_index)
			angles = []
			for item in line:
				angles.push_back(item.angle())
			line = []
			#check()
			inputs[curr_symbol].push_back(angles)
			curr_symbol += 1
			if curr_symbol >= NUM_SYMBOLS:
				curr_symbol = 0
				print(inputs[0].size())

	if event is InputEventMouseMotion:
		if events.size() == 1 and event.relative.length_squared() > 100:
			if line.size() > 0 and abs(line[-1].angle() - event.relative.angle()) < PI / 16:
				line[-1] += event.relative
			else:
				line.push_back(event.relative)

func train():
	var set_length = inputs[0].size()
	for j in range(set_length):
		for _curr_symbol in range(NUM_SYMBOLS):
			var _input: Array[float] = []
			var _target: Array[float] = []
			for i in range(INPUT_LIMIT):
				_input.push_back(0.0)
			for i in inputs[_curr_symbol][j].size():
				_input[i] = inputs[_curr_symbol][j][i] * 1.0
			for i in range(NUM_SYMBOLS):
				_target.push_back(1.0 if i == _curr_symbol else 0.0)
			NN.train(_input, _target)
	print('done')

func check():
	var _input: Array[float] = []
	for i in range(INPUT_LIMIT):
		_input.push_back(0.0)
	for i in angles.size():
		_input[i] = angles[i]
	print(NN.predict(_input))
