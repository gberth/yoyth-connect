import {set_focus, dispatch_on} from "./state"
import {texts} from "./texts"
console.log('??????????????????????')
console.dir(set_focus)
export var menu =
	menu_items:
		daily_focus:
			collapsed: true
			text: texts.daily_focus
			logged_in: false
			action: set_focus("daily_focus", true)
		profile:
			collapsed: true
			text: texts.profile
			logged_in: true
			action: set_focus("profile", true)
		settings:
			collapsed: true
			text: texts.settings
			logged_in: false
			action: set_focus("settings", true)
		bank_accounts:
			collapsed: true
			text: texts.bank_accounts
			logged_in: true
			menu_items:
				new_account:
					collapsed: true
					action: [set_focus("bank_list"), dispatch_on("get_list_of_banks", {identity_data: {}, payload: {}, close_menu: true})]
					text: texts.new_account
				account_status:
					collapsed: true
					type: ""
					text: texts.account_status
					action: set_focus("account_status", true)
