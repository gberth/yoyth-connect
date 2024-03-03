import * as actions from "../controls/actions.imba"
let state =
	current_date: new Date()
	vipps_configs:
		test:
			client_id: "a6341dae-0eba-49e8-90f9-504ac4fb05ec"
			secret: "UT-8Q~2FpZu9mkBWNmA4w8kHNNEYDq8OCQvtWcas"
			subscription_key: "e487ab7c1fca4e84b1f1a07d2eb9b997"
			url: "https://apitest.vipps.no/access-management-1.0/access/.well-known/openid-configuration"
			redirect_url: "https://yoyth-connect.vercel.app/v1/"
			response: {}
			endpoints: {}
		prod:
			url: "https://api.vipps.no/access-management-1.0/access/.well-known/openid-configuration"
			response: {}
			endpoints: {}

	vipps_config: {}
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
	google_user: {}
	types:
		get_vipps_access_token: 
			type: "vipps_access_token"
			connection: "yoyth"

let config = 
	connections:
		yoyth: 
			url: "YOYTHWSADDRESS"
			resend: true
			reconnect: true
			connect: true
			server: "yoythtest"
			create_keys: true
			type: "user_login"
			payload: 
				yoyth_login_identity: "yc-anonymous"
				yoyth_app_identity: "YOYTHCONNECTID"
				yoyth_secret: "YOYTHSECRET"


	commands:
		[
			{
				type: "establish_connection"
				wsid: "config"
				request_type: "anonymous_login"
				payload: {}
				request_data: {server: "yoythtest"}
				identity_data: {identity: "anonymous"}
			}
		] 
	events:
		"dates": actions.get_metric_data("dates")
		"days": actions.get_metric_data("days")
		"weeks": actions.get_metric_data("weeks")
		"months": actions.get_metric_data("months")
		"years": actions.get_metric_data("years")
		"send_to_subscriber": actions.setAck
		"login_anonymous": actions.set_login_anonymous
		"login": actions.set_login
		"ping": actions.receive_ping
		"anonymous_login": actions.setAck
		"vipps_access_token": actions.set_vipps_access_token
		"ACK": actions.setAck

def current_date 
	return state.current_date

export {state, config, current_date}