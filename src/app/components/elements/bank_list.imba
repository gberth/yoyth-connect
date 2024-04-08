import {texts} from "../../controls/texts"
import {state, dispatch_on} from "../../controls/state"

def click_item(bank)
	console.log('jada')
	def on_click
		console.log("click")
		console.log(bank)
		dispatch_on("get_bank_accounts_link", {identity_data: {}, payload: {bank_id: bank.id}, close_menu: true})()
	return on_click

export default tag BankList

	css .bank_list tween:all 200ms ease w:435px
		bgc:warm7  p:10px rd:lg
		d:grid ja:center
		shadow:0 5px 15px black/20
	css .one_bank_box tween:all 200ms ease w:435px
		bgc:blue4  p:10px rd:lg
		d:flex jc:center
		shadow:0 5px 15px black/20
	css .txt cursor:pointer

	prop element
	prop instancedata

	<self>
		<span.bank_list>
			<a [c:white]> texts.bank_list[state.country]
			if state.banklist.length === 0
				<a [c:white]> texts.waiting_for_bank_list[state.country]
			else
				for bank in state.banklist
					const click = click_item(bank)
					<span.one_bank_box>
						<span.txt @click=click> bank.name
					<p>

