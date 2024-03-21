import {state, dispatch} from "../state.imba"
import {create_msg} from "../helpers.imba"
import { v4 as uuidv4 } from 'uuid';

const msg_types = 
	"send_message": send_message
	"get_bank_list": get_bank_list

def send_messages(type)
	if msg_types[type] 
		return msg_types[type]()
	else
		console.error(`no send message for {type}`)
		state.init_errors.push(`no send message for {type}`)
		return undefined

def send_message()
	console.log("send message")
	const send = do(msg)
		console.log("handle_login")
		state.sockets[state.main_connection].sendmsg(msg)
	return send

def get_bank_list()
	console.log("get_list of banks meth")
	const send= do(msg)
		// legg på to_identity
		msg.identity_data.identity = state.identity
		msg.identity_data.to_identity = state.YOYTHBANKIDENTITY
		msg.identity_data.from_identity = state.session_identity
		console.log("get list of banks")
		state.sockets[state.main_connection].sendmsg(msg)
	return send

export {send_messages}	
