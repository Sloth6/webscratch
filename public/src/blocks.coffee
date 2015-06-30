class window.Block
	constructor: (arguments) ->
		# ...
	
class window.Boolean extends Block
	constructor: () ->
		super

class window.GT extends Boolean
	constructor: () ->
		super(new VariableInput(), '>', new VariableInput())
	value: () -> inputs[0].value() > inputs[1].value()

class window.LT extends Boolean
	constructor: () ->
		super(new VariableInput(), '<', new VariableInput())
	value: () -> inputs[0].value() < inputs[1].value()

class window.EQ extends Boolean
	constructor: () ->
		super(new VariableInput(), '=', new VariableInput())
	value: () -> inputs[0].value() == inputs[1].value()

class window.AND extends Boolean
	constructor: () ->
		super(new BooleanInput(), 'and', new BooleanInput())
	value: () -> inputs[0].value() and inputs[1].value()

class window.OR extends Boolean
	constructor: () ->
		super(new BooleanInput(), 'or', new BooleanInput())
	value: () -> inputs[0].value() or inputs[1].value()

class window.NOT extends Boolean
	constructor: () ->
		super('not', new BooleanInput())
	value: () -> not input[0].value()
	
