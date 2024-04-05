import {state} from "../state.imba"
import { Buffer } from 'buffer';
import pako from 'pako'
import {get_payload} from "../helpers.imba"



const msg_types = 
	"receive_data": receive_data
	"ACK.get_bank_list": set_list_of_banks
	"ACK.get_bank_accounts_link": ack_get_accounts_link
	"ACK.get_user_settings": ack_get_user_settings

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

def set_list_of_banks()
	console.log("set_list_of_banks")
	def create_msg(msg)
		state.banklist = get_payload(msg)
		console.log("aaaaaack banklist")
		console.dir(msg)
		imba.commit()
	return create_msg

def ack_get_accounts_link()
	console.log("set_get_accounts_link")
	def go_to_url(msg)
		console.log(get_payload(msg))
		if get_payload(msg).link
			window.open(get_payload(msg).link, "Bank approval", 'resizable,height=4000,width=800')
		imba.commit()
	return go_to_url

def ack_get_user_settings()
	console.log("set_get_accounts_link")
	def settings(msg)
		const pl = get_payload(msg)
		if Array.isArray(pl) and pl.length > 0
			pl.forEach do(setting)
				state[setting.yItem.yMetaData.yId] = setting

		imba.commit()
	return settings

export {receive_messages}	
