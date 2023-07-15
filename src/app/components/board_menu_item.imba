
import {state} from "../controls/index"

export class board_menu_item
	constructor instancedata
		instancedata = instancedata

	def flip_hidden()
		def flip_and_close
			instancedata.hidden = !instancedata.hidden
			state.menuOpen? = false
		return flip_and_close
	def get_menu_item
		if instancedata.hidden
			return {text: "Vis", click: flip_hidden(), icon: "unfold_more"}
		else
			return {text: "Skjul", click: flip_hidden(), icon: "unfold_less"}