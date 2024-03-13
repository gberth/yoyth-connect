import {state} from "./state.imba"
import {get_type, get_original_type, create_msg }  from "./helpers"
import {login_messages} from "./messages/login_messages.imba"

const msg_types = 
	"ACK.user_login": login_messages("ACK.user_login")
	"user_login": login_messages("user_login")
	"vipps_login": login_messages("vipps_login")

export def dispatch()
	def dispatch_msg(msg)
		console.log("wwwwwwwwwwww")
		console.dir(msg)
		const type = get_type(msg)
		if type && msg_types[type]
			if type == "ACK"
				msg.message_data.type = "ACK." + get_original_type(msg)
			msg_types[get_type(msg)](msg)
		else
			console.error(`no message action for {type}: msg{msg}`)
			state.errors.push[`no message action for {type}: msg{msg}`]
			console.dir(msg)
	return dispatch_msg

export def dispatch_on(type)
	const msg = create_msg(type, {},{})
	def dispatch_on_type()
		console.log("wwwwwwwwwwww")
		console.dir(msg)
		dispatch()(msg)

	return dispatch_on_type

