import {texts} from "../../controls/texts"
import {state, dispatch_on, set_focus} from "../../controls/state"

def click_item(setting)
	console.log('jada')
	def on_click
		console.log("click")
		console.log(setting)
		set_focus("setting_element")
		state.settings_element = setting
		state.menuOpen? = false
	return on_click

export default tag Settings

	css .setting_list tween:all 200ms ease w:435px
		bgc:warm7  p:10px rd:lg
		d:grid ja:center
		shadow:0 5px 15px black/20
	css .one_setting_box tween:all 200ms ease w:435px
		bgc:blue4  p:10px rd:lg
		d:flex jc:center
		shadow:0 5px 15px black/20
	css .txt cursor:pointer

	prop element
	prop instancedata

	<self>
		<span.setting_list>
			<a [c:white]> texts.setting_list[state.country]
			for own setting, settingvalue of state.settings_list
				const click = click_item(setting)
				<span.one_setting_box>
					<span.txt @click=click> setting
				<p>

