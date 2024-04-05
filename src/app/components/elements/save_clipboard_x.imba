import {texts} from "../../controls/texts"
import {state} from "../../controls/state"
import EasyMDE from "easymde"

import "../../components/menu-button"

let mde

const cancel_clipboard = do()
	mde.cleanup()	
	state.focus = state.focus_history.pop()

const save_clipboard = do()
	console.log("save")
	console.log(mde.value())
	mde.cleanup()
	state.focus = state.focus_history.pop()
	 
const cancel_button = 
	icon: "cancel"
	title: "cancel"
	click: cancel_clipboard
	open: true

const save_button = 
	icon: "save"
	title: "save to Yoyth"
	click: save_clipboard
	open: true

const newmde = do(val)
	if not mde
		mde = new EasyMDE({element: document.getElementById('md-text-area')})
	mde.value(val);

	return undefined

export default tag SaveClipboard

	css .clib_board tween:all 200ms ease w:435px
		bgc:warm7  p:10px rd:lg
		d:grid ja:center
		shadow:0 5px 15px black/20
	css .buttons ease w:400px
		d:grid bgc:pink4  p:10px rd:lg

	prop element
	prop instancedata
	def render
		const val = await window.navigator.clipboard.readText()

		<self>	
			<div>
				<a [c:white]> texts.save_clipboard[state.country]
				<textarea id="md-text-area">
				<div.buttons>
					<menu-button button=save_button>
				<div.buttons>
					<menu-button button=cancel_button>
				newmde(val);
