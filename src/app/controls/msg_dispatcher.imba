import {state} from "./state.imba"
import {get_type, get_original_type, create_msg }  from "./helpers"
import {login_messages} from "./messages/login_messages.imba"
import {receive_messages} from "./messages/receive_messages.imba"
import {send_messages} from "./messages/send_messages.imba"
import {system_messages} from "./messages/system_messages.imba"

const msg_types = 
	"ACK.user_login": login_messages("ACK.user_login")
	"ACK.ping": login_messages("ACK.ping")
	"user_login": login_messages("user_login")
	"vipps_login": login_messages("vipps_login")
	"send_to_subscriber": receive_messages("receive_data")
	"get_user_settings": send_messages("get_user_settings")
	"ACK.subscribe": receive_messages("receive_data")
	"ACK.login.anonymous": receive_messages("receive_data")
	"ACK.get_bank_list": receive_messages("ACK.get_bank_list")
	"ACK.get_user_settings": receive_messages("ACK.get_user_settings")
	"get_bank_list": send_messages("get_bank_list")
	"get_bank_accounts_link": send_messages("get_bank_accounts_link")
	"ACK.get_bank_accounts_link": receive_messages("ACK.get_bank_accounts_link")
	"yoyth.lost_connection": system_messages("yoyth.lost_connection")


const dispatch = do|msg|
	console.log("wwwwwwwwwwww")
	console.dir(msg)
	let type = get_type(msg) or msg
	if type == "ACK"
		type = msg.message_data.type = "ACK." + get_original_type(msg)
	if type && msg_types[type]
		msg_types[type](msg)
	else
		console.error(`no message action for {type}: msg{msg}`)
		state.errors.push[`no message action for {type}: msg{msg}`]
		console.dir(msg)

def dispatch_on(type, {identity_data, payload, close_menu})
	const msg = create_msg(type, identity_data, payload)
	return do()
		console.log("wwwwwwwwwwww")
		console.dir(msg)
		dispatch(msg)
		if close_menu
			state.menuOpen? = false

export {dispatch, dispatch_on}