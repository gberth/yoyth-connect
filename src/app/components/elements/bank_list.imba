import {texts} from "../../controls/texts"
import {state} from "../../controls/state"

export default tag BankList

	css .bank_list tween:all 200ms ease w:435px
		bgc:warm7  p:10px rd:lg
		d:grid ja:center
		shadow:0 5px 15px black/20
	css .one_metric_box ease w:400px
		d:grid bgc:pink4  p:10px rd:lg

	prop element
	prop instancedata

	<self>
		<div.bank_list>
			<a [c:white]> texts.bank_list[state.country]
