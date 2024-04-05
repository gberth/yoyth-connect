import {texts} from "../../controls/texts"
import {state} from "../../controls/state"
import EasyMDE from "easymde"

import "../../components/menu-button"

let mde =
	{mde_object: undefined }
let ct = 0

const waitforel = do(val)
	const el = document.getElementById('md-text-area')
	if el
		if not mde.mde_object
			mde.mde_object = new EasyMDE({element: el})
		mde.mde_object.value(val);
		return null

	if ct > 10
		return null

	setTimeout(&,100) do
		ct += 1
		console.log(ct)
		waitforel(val)

export default tag MdEditor

	prop value
	prop save

	def render
		console.log('gggggggggggggggggggggggggggg')
		const cancel_mde = do()
			mde.mde_object.cleanup()	
			state.focus = state.focus_history.pop()
			imba.commit()

		const cancel_button = 
			icon: "cancel"
			title: "cancel"
			click: cancel_mde
			open: true

		const save_button = 
			icon: "save"
			title: "save to Yoyth"
			click: save(mde)
			open: true

		<self>	
			<div>
				<a [c:white]> texts.save_clipboard[state.country]
				<textarea id="md-text-area">
				<div.buttons>
					<menu-button button=save_button>
				<div.buttons>
					<menu-button button=cancel_button>
				waitforel(value);
