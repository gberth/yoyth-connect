import {state} from "../state.imba"
import { Buffer } from 'buffer';
import pako from 'pako'


const msg_types = 
	"receive_data": receive_data

def receive_messages(type)
	if msg_types[type] 
		return msg_types[type]()
	else
		console.error(`no receive message for {type}`)
		state.init_errors.push(`no receive message for {type}`)
		return undefined

def receive_data()
	console.log("receeive data")
	def handle_receive_data(msg)
		console.log("handle_receive_data")
		console.dir(msg)
		if msg.payload and msg.payload.data and msg.payload.data.photo
			const row_raw = Buffer.from(msg.payload.data.photo, "base64")
			const row_unzipped = pako.inflate(row_raw)
			const row_string = new TextDecoder().decode(row_unzipped)
			const card_obj = JSON.parse(row_string)

			const photo = Buffer.from(card_obj).toString("base64")
			console.log(row_raw.length)
			console.log(row_unzipped.length)
			console.log(row_string.length)
			state.photo = photo
			state.status = msg.payload.data.camera_status
			state.photo_id = msg.payload.data.id
			imba.commit()		
	return handle_receive_data

export {receive_messages}	
