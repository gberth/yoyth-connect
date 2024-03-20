import {state, dispatch} from "../state.imba"
import {create_msg} from "../helpers.imba"
import { v4 as uuidv4 } from 'uuid';

const msg_types = 
	"yoyth.lost_connection": system_message

def system_messages(type)
	if msg_types[type] 
		return msg_types[type]()
	else
		console.error(`no send message for {type}`)
		state.init_errors.push(`no send message for {type}`)
		return undefined

def system_message()
	const logmsg = do(msg)
		console.log("log system msg")
		console.dir(msg)
	return logmsg

export {system_messages}	
