import {set_focus, dispatch_on} from "./state"
import {menu_texts} from "./texts"
console.log('??????????????????????')
console.dir(set_focus)
export var menu =
	menu_items:
		daily_focus:
			collapsed: true
			text: menu_texts.daily_focus
			logged_in: false
			action: set_focus("daily_focus")
		profile:
			collapsed: true
			text: menu_texts.profile
			logged_in: true
			action: set_focus("profile")
		settings:
			collapsed: true
			text: menu_texts.settings
			logged_in: false
			action: set_focus("settings")
		bank_accounts:
			collapsed: true
			text: menu_texts.bank_accounts
			logged_in: true
			menu_items:
				new_account:
					collapsed: true
					action: dispatch_on("get_bank_list")
					text: menu_texts.new_account
				account_status:
					collapsed: true
					type: ""
					text: menu_texts.account_status
					action: set_focus("account_status")
