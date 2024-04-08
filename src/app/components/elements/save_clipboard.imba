import {texts} from "../../controls/texts"
import {state} from "../../controls/state"
import MdEditor from "./md_editor"
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
		const value = await window.navigator.clipboard.readText()
		console.log("kkkkkkkkkkkkkkkkkkkkk")
		const save = do(mde)
			return do()
				console.log(mde.mde_object.value())
				state.focus = state.focus_history.pop()
				imba.commit()

		<self>
			<MdEditor value=value save=save>
