
import {state} from "../controls/index"

export class modal_menu_item
	constructor menutext, statevar
		statevar = statevar
		menutext = menutext 

	def flip_state_var
		state[statevar] = !state[statevar]

	def get_menu_item
		if state[statevar]
			return {text: menutext, click: flip_state_var, icon: "content"}
		else
			state[statevar] = !state[statevar]
