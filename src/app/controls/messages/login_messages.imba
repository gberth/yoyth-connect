import {state} from "../state.imba"
import {create_msg} from "../helpers.imba"
import { v4 as uuidv4 } from 'uuid';

const msg_types = 
	"ACK.user_login": ack_login
	"user_login": login
	"vipps_login": vipps_login

def login_messages(type)
	if msg_types[type] 
		return msg_types[type]()
	else
		console.error(`no login message for {type}`)
		state.init_errors.push(`no login message for {type}`)
		return undefined

def ack_login()
	console.log("set handle_ack_login")
	def handle_ack_login(msg)
		console.log("handle_ack_login")
	return handle_ack_login

def login()
	console.log("set login")
	const handle_login = do(msg)
		console.log("handle_login")
		state.sockets[state.main_connection].sendmsg(msg)
	return handle_login

def vipps_login()
	console.log("set vipps_login")
	def handle_login(msg)
		console.log("handle_vipps_login")
		const loginkey = uuidv4().toString() 
		const url = `https://{state.VIPPSAPI}/access-management-1.0/access/oauth2/auth?client_id={state.VIPPSCLIENT}&response_type=code&scope=openid%20name%20email%20phoneNumber%20address%20birthDate&state={loginkey}&redirect_uri={state.VIPPSREDIRECT}`
		console.log(url)
		console.log(loginkey)
		const login_msg =
			message_data:
				type: "user_login"
			payload:
				vipps_key: loginkey
		state.dispatch(create_msg("user_login", {vipps_key: loginkey}, {}))

		window.open(url, "yoythLogin", 'resizable,height=4000,width=800')
		return

	return handle_login

export {login_messages}	
