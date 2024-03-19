import {state} from "../state.imba"
import {get_payload} from "../helpers.imba"


const msg_types = 
	"get_list_of_banks": get_list_of_banks
	"ACK.get_list_of_banks": set_list_of_banks

def request_messages(type)
	if msg_types[type] 
		return msg_types[type]()
	else
		console.error(`no request message for {type}`)
		state.init_errors.push(`no request message for {type}`)
		return undefined

def get_list_of_banks()
	console.log("get_list_of_banks")
	def create_msg(msg)
		console.log("handle_receive_data")
		console.dir(msg)
	return create_msg

def set_list_of_banks()
	console.log("set_list_of_banks")
	def create_msg(msg)
		state.banklist = get_payload(msg)
		console.log("handle_receive_data")
		console.dir(msg)
	return create_msg
export {request_messages}	
