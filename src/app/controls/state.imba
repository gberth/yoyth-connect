import * as actions from "../controls/actions.imba"
import {dispatch, dispatch_on} from "../controls/msg_dispatcher"
let state =
	current_date: new Date()
	dispatch: dispatch()
	dispatch_on: dispatch_on
	main_connection: "yoyth"
	init_errors: []
	errors: []
	new_date?: false
	test: false
	menuOpen?: false
	menuFlipTs: 0
	menu: {menu_items: {}}
	signIn: false
	signedIn: false
	subscribe: false
	sockets: {}
	popUpData: {}
	source: {}
	requests: {}
	metrics: {}
	abtests: {}
	contents: {}
	dashboards: []
	user: {}
	last_ts: {}
	photo: ""
	status: ""
	photo_id: ""
	subscriptions_on_ws: {}
	cardsubscriptions: {}
	sitekey: ""
	sitekey_login: false
	redirect_uri: 'https://yoythrest'
	vipps_access_token: ""
	vipps_client_id: "..."
	server_private_keys: {}

let config = 
	connections:
		yoyth: 
			url: "YOYTHWSADDRESS"
			resend: true
			reconnect: true
			connect: true

def current_date 
	return state.current_date

export {state, config, current_date}