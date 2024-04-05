import {texts} from "../../controls/texts"
import {state} from "../../controls/state"

export default tag SettingsElement

	css .settings_element tween:all 200ms ease w:435px
		bgc:warm7  p:10px rd:lg
		d:grid ja:center
		shadow:0 5px 15px black/20
	css .one_metric_box ease w:400px
		d:grid bgc:pink4  p:10px rd:lg

	prop element
	prop instancedata

	<self>
		<div.settings_element>
			<a [c:white]> texts.settings[state.country]
