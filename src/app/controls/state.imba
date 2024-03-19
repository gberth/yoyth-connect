import {dispatch, dispatch_on} from "../controls/msg_dispatcher"
let state =
	current_date: new Date()
	country: "no"
	main_connection: "yoyth"
	init_errors: []
	errors: []
	new_date?: false
	test: false
	menuOpen?: false
	menuFlipTs: 0
	menu: {menu_items: {}}
	banklist: {}
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
	session_identity: ""
	identity: ""
	identity_data: {}
	last_ts: {}
	photo: ""
	status: ""
	photo_id: ""
	subscriptions_on_ws: {}
	cardsubscriptions: {}
	sitekey: ""
	sitekey_login: false
	server_private_keys: {}
	focus: "daily_focus"
	focus_history: []

const set_focus = do(new_focus, hide_menu = true)
	return do() 
		if new_focus !== "daily_focus"
			state.focus_history = [state.focus].concat(state.focus_history)
		else
			state.focus_history = []		
		state.focus = new_focus
		if hide_menu
			state.menuOpen? = false

let config = 
	connections:
		yoyth: 
			url: "YOYTHWSADDRESS"
			resend: true
			reconnect: true
			connect: true

def current_date 
	return state.current_date

export {state, config, current_date, set_focus, dispatch, dispatch_on}