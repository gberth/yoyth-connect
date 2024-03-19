import {state} from "./state.imba"
import {get_type, get_original_type, create_msg }  from "./helpers"
import {login_messages} from "./messages/login_messages.imba"
import {receive_messages} from "./messages/receive_messages.imba"
import {request_messages} from "./messages/request_messages.imba"

const msg_types = 
	"ACK.user_login": login_messages("ACK.user_login")
	"ACK.ping": login_messages("ACK.ping")
	"user_login": login_messages("user_login")
	"vipps_login": login_messages("vipps_login")
	"send_to_subscriber": receive_messages("receive_data")
	"ACK.subscribe": receive_messages("receive_data")
	"ACK.login.anonymous": receive_messages("receive_data")
	"get_list_of_banks": request_messages("get_list_of_banks")
	"ACK.get_list_of_banks": request_messages("ACK.get_list_of_banks")

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