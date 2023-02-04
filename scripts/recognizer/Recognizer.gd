class_name Recognizer
extends Node

const INPUT_LIMIT = 20
const NUM_SYMBOLS = 8

const TRAINING = true
const LOG_TRAINING_SET = false
const RECOGNIZE = true
const UPDATE_TRAINING_SET = false

var events = {}
var event_acc: Vector2 = Vector2(0, 0)
var line: Array[Vector2] = []
var angles: Array[float] = []
var NN: NeuralNetwork = NeuralNetwork.new()

var curr_symbol = 0
var inputs = [
	#H_LINE_R
	[
		[-0.02469117380679], [-0.06776650249958], [0.15979486703873], [-0.56681793928146, -0.08625768125057], [-0.06453828513622], [0.0378512442112], [-0.04140454530716], [0.06578609347343], [-0.00611732900143], [0.11458688229322], [0.02332394942641], [0.00771343894303], [-0.05468251556158],
	],
	#H_LINE_L
	[
		[3.10416960716248], [3.13668966293335], [2.81524419784546], [2.82169556617737], [3.05813431739807], [3.05756402015686], [3.08263301849365], [3.13721537590027], [3.13348317146301], [3.07846713066101], [3.12478423118591], [3.13386917114258], [3.10995149612427],
	],
	#V_LINE_D
	[
		[1.51004660129547], [1.55892980098724], [1.45298755168915], [1.56316435337067], [1.49156630039215], [1.56217753887177], [1.50247514247894], [1.55764174461365], [1.53378343582153], [1.56410872936249], [1.54965555667877], [1.50583207607269], [1.5333571434021],
	],
	#V_LINE_U
	[
		[-1.5868775844574], [-1.59242331981659], [-1.61650717258453, -1.29542148113251], [-1.58043265342712], [-1.53848135471344], [-1.47315406799316], [-1.48360335826874], [-1.53337621688843], [-1.51712715625763], [-1.49602270126343], [-1.57079637050629], [-1.54100072383881], [-1.53206360340118],
	],
	#CARET_UP_R
	[
		[-1.28894412517548, -0.86639893054962, 1.28112506866455], [-1.08932828903198, -0.64359509944916, 0.84992206096649, 1.36609470844269], [-1.03377413749695, -0.71315771341324, -0.34883388876915, 0.55439513921738, 1.19997119903564], [-1.08726525306702, 0.43248227238655, 1.34776222705841], [-0.90578871965408, 1.00415575504303, 1.25662195682526], [-0.7938523888588, 0.20543447136879, 1.40480315685272], [-1.071129322052, -0.64359509944916, 0.89615094661713, 1.33642494678497], [-1.03194236755371, -0.52566874027252, 0.85206341743469, 1.50364601612091], [-1.05806291103363, -0.72673958539963, 1.11339902877808, 1.47003495693207], [-0.92026382684708, -0.57352977991104, 0.97246861457825, 1.46408140659332], [-1.0723797082901, -0.68061697483063, 1.37343847751617], [-1.03843283653259, -0.74847567081451, 0.03998650982976, 1.23559391498566], [-1.03293824195862, -0.57916396856308, 0.52815967798233, 1.39459538459778],
	],
	#CARET_UP_L
	[
		[-1.89248812198639, 1.95760357379913], [-1.97714376449585, -2.43286967277527, -2.84303855895996, 1.76604044437408], [-1.84565508365631, -2.51601457595825, 2.06577491760254], [-1.57079637050629, -1.95023822784424, 1.98753070831299], [-1.92199540138245, -2.37196826934814, 3.01186490058899, 2.2195508480072], [-2.04526305198669, -2.45335173606873, -2.8104362487793, 2.45105004310608, 1.88635420799255], [-1.90310823917389, -2.2620370388031, -2.9180736541748, 2.1587085723877], [-1.87032496929169, -2.35609650611877, -3.10588645935059, 2.29955387115479, 1.81847310066223], [-1.81693494319916, -2.1893482208252, 2.30997586250305, 2.02563333511353], [-2.05780935287476, -2.55349969863892, 2.0343656539917], [-1.87385976314545, 2.22901058197021], [-1.96657705307007, -2.49799752235413, -2.96484994888306, 2.57016611099243, 2.02414560317993], [-1.85484492778778, -2.25642991065979, -2.74673199653625, 2.47552824020386, 1.92132186889648],
	],
	#CARET_DOWN_R
	[
		[1.17607474327087, 0.08315744251013, -0.82197594642639, -1.15932750701904], [1.14667534828186, -0.78549605607986, -1.15547013282776], [1.5045348405838, -1.02752757072449], [1.22760570049286, -0.20468078553677, -1.12722194194794], [1.24771010875702, -0.94932079315186], [1.18807125091553, -0.57305538654327, -1.12692654132843], [1.2174197435379, -0.19743321835995, -1.02083742618561], [1.35906040668488, 0.78549605607986, -0.4637259542942, -1.00771594047546], [1.25662195682526, -1.0385594367981], [1.23789870738983, -0.48259380459785, -1.03046321868896], [1.24299550056458, -0.63512027263641, -1.19700527191162], [1.07851755619049, -0.61081796884537, -1.00710225105286], [1.31405198574066, -0.57067173719406, -0.98451662063599],
	],
	#CARET_DOWN_L
	[
		[2.03603768348694, -2.28985548019409], [1.79682195186615, -2.08343410491943], [1.80233001708984, -2.21054077148438], [1.99042546749115, -3.03849101066589, -2.68404030799866, -2.24924111366272], [2.16355061531067, -2.60779857635498, -2.24627637863159], [2.05963373184204, -2.46727752685547], [1.96370947360992, -2.09377932548523], [1.98197901248932, -2.72085642814636, -2.19618844985962], [1.93557608127594, -2.04665875434875], [1.9295027256012, -2.06671857833862], [1.86772537231445, -2.77754855155945, -2.16620540618896], [1.95968449115753, -2.24057507514954], [2.04394006729126, -2.49316644668579, -2.02208948135376],
	],
]

enum SYMBOL {
	H_LINE_R, H_LINE_L, V_LINE_D, V_LINE_U, CARET_UP_R, CARET_UP_L, CARET_DOWN_R, CARET_DOWN_L,
	NONE
}

signal symbol(symbol: SYMBOL)
signal click()

func _ready():
	NN.set_nn_data(INPUT_LIMIT, 20, NUM_SYMBOLS)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				if LOG_TRAINING_SET:
					for i in range(NUM_SYMBOLS):
						print(inputs[i])
				if TRAINING:
					train()
			return
		if event.pressed and events.size() == 0:
			events[event.button_index] = event
			line = []
		else:
			events.erase(event.button_index)
			angles = []
			for item in line:
				angles.push_back(item.angle())
			var top_half_count = 0
			var bottom_half_count = 0
			for angle in angles:
				if angle > 0 and angle < 3.05:
					top_half_count += 1
				if angle < 0 and angle > -3.05:
					bottom_half_count += 1
			if top_half_count < bottom_half_count:
				for i in range(angles.size()):
					if angles[i] > 3.025:
						angles[i] -= 2*PI
			elif top_half_count >= bottom_half_count:
				for i in range(angles.size()):
					if angles[i] < -3.025:
						angles[i] += 2*PI
			line = []
			if angles.size() == 0:
				click.emit()
			else:
				if RECOGNIZE: 
					check()
				if UPDATE_TRAINING_SET:
					inputs[curr_symbol].push_back(angles)
					curr_symbol += 1
					if curr_symbol >= NUM_SYMBOLS:
						curr_symbol = 0
						print(inputs[0].size())

	if event is InputEventMouseMotion:
		if events.size() == 1:
			event_acc += event.relative
			if line.size() > 0:
				var diff = abs(line[-1].angle() - event.relative.angle())
				diff = min(diff, abs(diff - 2*PI))
				if diff < PI / 12:
					line[-1] += event_acc
					event_acc = Vector2(0, 0)
			if event_acc.length_squared() > 1500:
				line.push_back(event_acc)
				event_acc = Vector2(0, 0)

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
	var output = NN.predict(_input)
	#print(output)
	var result = get_prediction(output)
	emit_prediction(result)

func get_prediction(output: Array) -> SYMBOL:
	var _max = -1
	var _max_pos = -1
	for i in range(output.size()):
		if output[i] > _max:
			_max = output[i]
			_max_pos = i
	if _max < 0.15:
		return SYMBOL.NONE
	return SYMBOL[SYMBOL.keys()[_max_pos]]

func emit_prediction(_symbol: SYMBOL) -> void:
	symbol.emit(_symbol)
