import {subscribe_to_cards} from '../controls/actions.imba' 
import {dashboard_element} from "./dashoard_element"
import {translate_text} from '../controls/helpers'

export class dashboard
	constructor btype, bdefs, idata
		dashboard_type = btype
		boarddef = bdefs 
		instancedata = idata
		elements = []
		text = translate_text(boarddef.dashboard.text, instancedata)
		type = boarddef.dashboard.type


		for element, ix in boarddef.dashboard.dashboard_elements
			elements.push(new dashboard_element(element, instancedata, ix))

		subscribe_to_cards(this, instancedata)

	def notify(timestamp)
		for element in elements
			element.notify(timestamp)
