import * as actions from "../controls/actions.imba"
let state =
	current_date: new Date()
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
	subscriptions_on_ws: {}
	cardsubscriptions: {}
	sitekey: ""
	sitekey_login: false
	vipps_client_id: "..." 
	redirect_uri: 'https://yoythrest'
	access_token: ""
	google_user: {} 

let config = 
	connection:
		config: 
			route: 'wss://y0y7h.herokuapp.com'
	commands:
		[
			{
				type: "login.anonymous"
				wsid: "config"
				request_type: "anonymous_login"
				payload: {}
				request_data: {server: "yoythcapture"}
				identity_data: {identity: "anonymous"}
			}
		] 
	events:
		{
			"get_sources": actions.set_sources,
			"dates": actions.get_metric_data("dates"),
			"days": actions.get_metric_data("days"),
			"weeks": actions.get_metric_data("weeks"),
			"months": actions.get_metric_data("months"),
			"years": actions.get_metric_data("years"),
			"send_to_subscriber": actions.set_zip_response,
			"login_anonymous": actions.set_login_anonymous,
			"login": actions.set_login,
		}
def current_date 
	return state.current_date

export {state, config, current_date}