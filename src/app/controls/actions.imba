import { v4 as uuidv4 } from 'uuid';
import {state, config} from "./state"
import {ic_dispatcher, socket} from "./effects"
import {source} from "./source"
import {dashboard} from "../components/dashboard"
import {user} from "./user"
import {board_menu_item} from "../components/board_menu_item"
import {get_date} from "./helpers"

# import test_user from "../../test/state.user.json"
# import test_metrics from "../../test/state.metrics.json"
# import test_sources from "../../test/state.sources.json"
# import test_abtest from "../../test/state.abtest.json"
# import test_content from "../../test/state.content.json"


import { unzip, inflateRaw, inflate, deflate, gunzip } from 'zlib';
import { Buffer } from 'buffer';
import pako from 'pako'

const GOOGLE_USER_TOKEN_KEY = 'googleUserToken'
let localhost = false

def signOutGoogle
	localStorage.removeItem(GOOGLE_USER_TOKEN_KEY);
	state.signedIn = false
	imba.commit()

def signInGoogle
	const config =
		client_id: state.google_client_id
		scope: "profile email"
		redirect_uri: state.redirect_uri

	resetSignIn()
	config.callback = do(resp)
		resp
		
	const client = window.google.accounts.oauth2.initTokenClient(config);

	const tokenResponse = await new Promise(do(resolve, reject)
		try
			client.callback = do(resp)
				if (resp.error !== undefined)
					reject(resp);
				resolve(resp);
			client.requestAccessToken({ prompt: "consent" });
		catch err
			console.error(err);
	)
	localStorage.setItem(GOOGLE_USER_TOKEN_KEY, tokenResponse.access_token);
	init_user()	
	return

def setAck msg
	console.log msg
	if msg.payload and msg.payload.data and msg.payload.data.photo
		const row_raw = Buffer.from(msg.payload.data.photo, "base64")
		const row_unzipped = pako.inflate(row_raw)
		const row_string = new TextDecoder().decode(row_unzipped)
		const card_obj = JSON.parse(row_string)

		const photo = Buffer.from(card_obj).toString("base64")
		console.log(row_raw.length)
		console.log(row_unzipped.length)
		console.log(row_string.length)
		localStorage.setItem("gbphoto", JSON.stringify(photo))
		localStorage.setItem("gbstatus", JSON.stringify(msg.payload.data.camera_status, null, "\t"))
		localStorage.setItem("gbid", msg.payload.data.id)
		state.photo = photo
		state.status = msg.payload.data.camera_status
		state.photo_id = msg.payload.data.id
		imba.commit()

export def set_value_in_state(statevars, newvalue)
	def copy_from(fromobj, toobj)
		for own varnm, varv of fromobj
			if typeof toobj[varnm]  == "undefined"
				toobj[varnm] = varv
			elif toobj[varnm].constructor == Object
				copy_from(varv, toobj[varnm])
			else
				toobj[varnm] = varv


	let svar = state
	const nval = newvalue.observed or newvalue	 

	for ix in [0 ... statevars.length]
		if typeof svar[statevars[ix]] == 'undefined'
			svar[statevars[ix]] = {}
		svar = svar[statevars[ix]]

	if nval.constructor == Object
		copy_from(nval, svar)
	else
		svar.observed = nval
	return svar
	
export def get_state_value_x(vars)
	let workvars = vars
	let svar = state

	while true
		let workvar = workvars[0]
		workvars = workvars.slice(1)
		if typeof svar[workvar] == 'undefined'
			svar[workvar] = {}
		svar = svar[workvar]
		if workvars.length === 0
			break 
	return svar

export def get_state_value(vars)

	def next_state_var(nxtvar, stateref)
		if typeof stateref[nxtvar] == 'undefined'
			stateref[nxtvar] = {}
		return stateref[nxtvar]

	def get_next_value(workvar, restvars, stateref)
		let state_result
		if Array.isArray(workvar)
			state_result = []
			for arrvar in workvar
				state_result.push(get_next_value(arrvar, restvars, stateref))
			return state_result
		else
			stateref = next_state_var(workvar, stateref)
			if restvars.length === 0
				return stateref
			workvar = restvars[0]
			restvars = restvars.slice(1)
			return get_next_value(workvar, restvars, stateref)

	const workvar = vars[0]
	const restvars = vars.slice(1)

	return get_next_value(workvar, restvars, state)

export def set_zip_response msg
	set_response(msg, true)

def set_response msg, zipped_cards

	def notify(source, group, segment, ts)
		let commit = false
		let subkey = source + "." + group + "." + segment
		if not state.cardsubscriptions[subkey]
			subkey = source + "." + group + ".*"

		if state.cardsubscriptions[subkey]
			for board in state.cardsubscriptions[subkey]
				board.notify(ts)
				commit = true
		return commit

	let payload = msg.payload
	if typeof payload === "string"
		if localhost
			console.log("payload_len", payload.length)
			if payload.length < 200
				console.log("payload", payload)

		payload = JSON.parse(payload);
	const msgid = msg.message_data.original.id
	const request_msg = state.requests[msg.message_data.original.id]
	if state.subscriptions_on_ws[request_msg.wsid] and state.subscriptions_on_ws[request_msg.wsid].msgs[msgid]
		state.subscriptions_on_ws[request_msg.wsid].msgs[msgid].lastts = Date.now()

	if get_date() > get_date(state.current_date)
		state.new_date? = true
		check_for_resubscribe()
		return

	let subkey
	if request_msg and request_msg.source and payload.group
		let commit = false	
		if payload.cards
			let ts
			let rt = false

			for own cardid, card of payload.cards
				if zipped_cards
					card = unzip_card(card)

				ts = card[2].replace(" ","T")
				if request_msg.request_type === "ab-test"
					const carddata = JSON.parse(card[6])
					if not state.abtests[card[4]]
						state.abtests[card[4]] = {}
					if not state.abtests[card[4]][card[5]]
						state.abtests[card[4]][card[5]] = {}
					state.abtests[card[4]][card[5]].card = carddata
					commit = notify(request_msg.source, payload.group, card[5], ts)					
				elif request_msg.request_type === "content-test"
					const carddata = JSON.parse(card[6])
					if not state.contents[card[3]]
						state.contents[card[3]] = {}
					state.contents[card[3]].card = carddata
					commit = notify(request_msg.source, payload.group, "", ts)					
				else
					let metrics = state.source[request_msg.source].metrics 
					if not metrics
						console.log("zzzz", payload.group, request_msg.source, state.user.userdata.sources, card)

					if metrics
						const carddata = JSON.parse(card[6])
						let segment
						if request_msg.source === "maximinus"
							segment = card[4] + card[5]
						else 
							segment = card[5]
						for metric in metrics
							if carddata[metric] 
								set_value_in_state(["metrics", request_msg.source, payload.group, metric, "dates", card[1], segment], carddata[metric])  
						const checkforsubs = set_value_in_state(["last_ts", request_msg.source, payload.group, segment, "last_ts"], ts)
						commit = notify(request_msg.source, payload.group, segment, ts)
			# console.log(state.metrics)
		if commit
			imba.commit()

def send_cards_to_subscribers(cards)
	let commit = false
	for own cardkey, boards of state.cardsubscriptions
		let carddata
		let ts
		let rt = false
		if cards[cardkey]
			for subscriber in boards
				if cards[cardkey].length === 7
					ts = cards[cardkey][2]
					carddata = JSON.parse(cards[cardkey][6])
					rt = true
				elif typeof cards[cardkey] === "object" and cards[cardkey].card and cards[cardkey].card.metrics
					ts = cards[cardkey].card.last_date
					carddata = cards[cardkey].card.metrics
					rt = false
				else
					carddata = cards[cardkey]
					rt = false
				commit = true
				subscriber.board.set_dashboard_data(subscriber.type, carddata, ts, rt)
	if commit
		imba.commit()

export def setHistoric msg
	console.log msg

export def get_metric_data(period)
	def get_data(msg)
		let source
		if msg.message_data.request_data and msg.message_data.request_data.request_id
			const request_msg = state.requests[msg.message_data.request_data.request_id]
			source = request_msg.source

		# console.log("returned", period, source, msg.payload)
		if period === "days"
			for row in msg.payload.result
				const keys = row.row_key.split("#")
				const segmentcard = JSON.parse(row.json)
				let segmentvalues
				if segmentcard.card
					segmentvalues = segmentcard.metrics
				else 
					segmentvalues = segmentcard
				set_value_in_state(["metrics", source, keys[0], keys[1], "days", keys[2]], segmentvalues)  

	return get_data

def onSocketStatusChange(wsid)
	return do(data)
		# console.log("socket change", wsid)
		# console.log(data)
		# console.log(data.socket)
		if data.socket_status === "close"
			if data.socket.reconnect
				create_socket({
					...data.socket
				})
		elif data.socket_status === "open"
			if data.socket.resend_msgs and data.socket.resend_msgs.length > 0
				for msg in data.socket.resend_msgs
					console.log("socket resubscribe ", msg)
					state.sockets[wsid].sendmsg(msg)

def getUserInfo(token)
	if not token
		return
	const response = await fetch(`https://www.googleapis.com/oauth2/v1/userinfo?access_token={token}`);
	const user = await response.json();
	if 'amedia.no' in user.email
		return user
	return

def init
	def createScript
		const script = document.createElement("script");
		script.src = "https://accounts.google.com/gsi/client";
		script.async = true;
		document.body.appendChild(script);
	
	init_user()
	if not state.test
		createScript()

def init_user
	if 'localhost' in window.location.href
		localhost = true
	const url = window.location.href.split("/")
	if url.length > 3 and url[url.length - 1] == "test_components"
		initiate_test_env()
		imba.commit()
		return

	const token = localStorage.getItem(GOOGLE_USER_TOKEN_KEY);
	if token
		state.access_token = token
		const user = await getUserInfo(token);

		if not user
			console.log("error sign out")
			signOutGoogle()			
		else
			state.google_user = user
			state.signedIn = true

	for command in config.commands
		if not state.sockets[command.wsid]
			create_socket({
				id: command.wsid
				host: config.connection[command.wsid].route
				onmessage: ic_dispatcher.onMessage
				onStatusChange: onSocketStatusChange(command.wsid)
			})
		command.identity_data.access_token = token
		sendCommand(command)

	for own event, action of config.events
		ic_dispatcher.route(event, action)

	setTimeout(&,60000) do
		check_for_resubscribe()
	setInterval(&,15000) do
		ping_all_sockets()
	imba.commit()

export def reciev_ping()
	console.log("ping received")

def ping_all_sockets()
	console.log("ping")
	for own socketid, socket of state.sockets
		console.log(socketid)
		sendCommand({
			type: 'ping',
			request_type: "ping"
			payload: "ping"
			wsid: socketid
		})

def check_for_resubscribe()
	if localhost
		console.log("state on resub check", state)
	const token = localStorage.getItem(GOOGLE_USER_TOKEN_KEY);
	const user = await getUserInfo(token);
	if not user
		signOutGoogle()
		return

	for own source, sourcesubs of state.subscriptions_on_ws
		for own msgid, msgdata of sourcesubs.msgs
			if Date.now() - msgdata.lastts > 300000 or state.new_date?
				console.log("resend sub", msgdata.cmd)
				msgdata.lastts = Date.now()
				state.sockets[state.requests[msgid].wsid].sendmsg(msgdata.cmd)
	if state.new_date?
		state.new_date? = false
		state.abtests = {}
		state.metrics = {}
		state.current_date = new Date()

	setTimeout(&,60000) do
		check_for_resubscribe()

def initiate_test_env
	state.test = true
	state.photo =JSON.parse(localStorage.getItem("gbphoto"))
	state.status = localStorage.getItem("gbstatus")
	state.photo_id = localStorage.getItem("gbid")

export def create_socket(parm)
	state.sockets[parm.id] = socket().initialize({
		...parm
		onmessage: ic_dispatcher.onMessage
		onStatusChange: onSocketStatusChange(parm.id)
	})

export def login({email, pw})
	sendCommand({
		type: "x.get_user_def"
		request_type: "login"
		payload: {user: email},
		identity_data: {server: "ic_metadata", access_token: state.access_token},
		wsid: "config"
	})

export def subscribe({source, group})
	const now = state.source[source].sources.now
	sendCommand({
		type: now.type
		request_type: now.request_type
		payload: {cardkey: group}
		wsid: state.sockets[source + "." + now.connection]
	})

export def addDashboard()
	console.log("addDashboard")

export def sendCommand(send)
	const msgid = uuidv4().toString();
	state.requests[msgid] = send;
	const senddata = 
		message_data: 
			id: msgid
			type: send.type
			request_data: send.request_data or {}
		identity_data: send.identity_data or {}
		payload: send.payload
	senddata.message_data.request_data.request_id = msgid	
	if not senddata.identity_data.access_token
		senddata.identity_data.access_token = state.access_token
	console.log(senddata)
	if send.type in ["x.subscribe", "subscribe"]
		if not state.subscriptions_on_ws[send.wsid]
			state.subscriptions_on_ws[send.wsid] = {msgs: {}}
		state.subscriptions_on_ws[send.wsid].msgs[msgid] = {lastts: Date.now(), cmd: senddata}

	state.sockets[send.wsid].sendmsg(senddata)

def set_sources(msg)
	for own sourceid, source_data of msg.payload
		state.source[sourceid] = new source(sourceid, source_data)

	if not state.sitekey_login
		const url = window.location.href.split("/")
		if url.length > 3 and url[url.length - 1].length == 6 or url[url.length - 1] == "all_sites" or url[url.length - 1].startsWith("amedia_")
			state.sitekey = url[url.length - 1]
			console.log("sitelogin", state.sitekey)
			if url[url.length - 1] == "all_sites"
				login({email: "all_sites", pw: ""})
			elif url[url.length - 1].startsWith("amedia_")
				login({email: "amedia", pw: ""})
			else
				login({email: "sitekey", pw: ""})
			state.sitekey_login = true

def set_user(userid, userdata)
	state.user = new user(userid, userdata)

export def unzip_card(card)

	const row_raw = Buffer.from(card, "latin1")
	const row_unzipped = pako.inflate(row_raw)
	const row_string = new TextDecoder().decode(row_unzipped);
	const card_obj = JSON.parse(row_string)
	return card_obj

export def unzip_old(card)
	const row_raw = Buffer.from(card, "latin1")
	const row_unzipped = pako.inflate(row_raw)
	const row_string = new TextDecoder().decode(row_unzipped);
	const card_obj = JSON.parse(row_string)
	return {card_obj}


export def get_zip_data(contenttype)
	return do(msg)
		def get_latest(row_key, row)
			if row[row_key+"##"] and row[row_key+"##"].card
				return row[row_key+"##"].card.last_date
			else
				return ""

		if msg and msg.payload and msg.payload.result
			msg.payload.result.map do(row)
				const row_key = row.row_key
				const {card_obj, row_raw} = unzip_card(row.cards)
				send_cards_to_subscribers(card_obj)

export def set_login(msg)
	state.signedIn = true
	state.signIn = false
	const userdata = msg.payload
	state.user = new user(userdata.email, userdata)
	imba.commit()

export def flip_state(statevar)
	state[statevar] = !state[statevar]


export def flipMenuOpen()
	console.log "flip"
	if Date.now() > state.menuFlipTs + 100
		state.menuOpen? = !state.menuOpen?
	state.menuFlipTs = Date.now()

export def resetSignIn()
	console.log "resatt"
	state.signIn = false

export def signIn()
	state.signIn = true
	signInGoogle()

export def signOut()
	state.signedIn = false
	signOutGoogle()
	imba.commit()

export def resetSubscribe()
	state.subscribe = false

export def resetABTest()
	state.ab_test = false

export def ab_test_subscribe({sitekey, testid, histdate})
	flip_state("ab_test")
	let dashboarddata =
		instance_parameters: [
			{
				source: "ab-test"
				group: sitekey
				instance_name: testid
				segment: testid
			}
		] 
		dashboard:
			text: "ab-test"
			type: "insight_board"
			dashboard_elements: [
				{
					text: "ab-test"
					type: "ab_test"
					state: 
						metrics: [
							{
								text: "AB"
								current: [
									"abtests"
									sitekey
									testid
								]
							}
						]
				}
			]

	create_dashboards(state.menu.menu_items["Dashboards"], dashboarddata, true)
	if not histdate
		sendCommand({
			type: "x.subscribe"
			request_type: "ab-test"
			source: "ab-test"
			payload: {cardkey: "ab-test#" + sitekey + "#" + testid},
			identity_data: {server: "ic_ab_test"},
			wsid: "ab-test.rt"
		})
	else
		sendCommand({
			type: "x.get_ab_test"
			request_type: "ab-test-hist"
			source: "ab-test"
			payload: {row_key: histdate + "#ab-test#" + sitekey + "#" + testid},
			identity_data: {server: "ic_ab_test_hist"},
			wsid: "ab-test.hist"
		})

export def content_test_subscribe({testid, histdate})
	let usedate = histdate or state.current_date
	flip_state("content_test")
	let dashboarddata =
		instance_parameters: [
			{
				source: "maximinus"
				instance_name: testid
				group: testid
			}
		] 
		dashboard:
			text: "content-test"
			type: "insight_board"
			dashboard_elements: [
				{
					text: "content-test"
					type: "content_test"
					state: 
						metrics: [
							{
								text: "Content"
								current: [
									"contents",
									testid
								]
							}
						]
				}
			]

	create_dashboards(state.menu.menu_items["Dashboards"], dashboarddata, true)
	if not histdate
		sendCommand({
			type: "subscribe"
			request_type: "content-test"
			source: "maximinus"
			payload: {cardkey: testid},
			identity_data: {},
			wsid: "maximinus.rt"
		})
	else
		sendCommand({
			type: "x.get_content_test"
			request_type: "content-test-hist"
			source: "maximinus"
			payload: {type: "historicContent", row_key: histdate + "#" + testid + "##"},
			identity_data: {server: "ic_ab_test_hist"},
			wsid: "ab-test.hist"
		})



export def create_dashboards(menu_item, dashboarddata, subscribe=false)
	if dashboarddata.instance_parameters
		for instancedata in dashboarddata.instance_parameters
			insert_menu_item(menu_item, instancedata.instance_name, {"collapsed": true, "type": new board_menu_item(instancedata)})
			const db = new dashboard(dashboarddata.dashboard.type, dashboarddata, instancedata)
			state.dashboards.push(db)
			if subscribe
				subscribe_to_cards(db, instancedata)

export def insert_menu_item(into_item, item_name, item)
	into_item.menu_items[item_name] = {...item}
	into_item.menu_items[item_name]["menu_items"] = {}
	return into_item.menu_items[item_name] 


export def get_source_data(source, period, payload_template)
	state.source[source].get_data(period, payload_template)

export def subscribe_to_cards(board, instancedata)
	let key
	if typeof instancedata.segment === "string"  
		key = instancedata.source + "." + instancedata.group + "." + instancedata.segment
	else
		key = instancedata.source + "." + instancedata.group + ".*"
	if not state.cardsubscriptions[key]
		state.cardsubscriptions[key] = []
	if board not in state.cardsubscriptions[key]
		state.cardsubscriptions[key].push(board)

def get_card_key(card)
	const d = new Date()
	let dayno = d.getDay()
	if dayno === 0
		dayno = 7
	const date = d.toISOString()
	let ret_date = card
	if ret_date.includes("\{date\}")
		ret_date = ret_date.replace("\{date\}", date.substring(0,10))
	elif ret_date.includes("\{dayno\}")	
		ret_date = ret_date.replace("\{dayno\}", dayno)
	return ret_date

export {init, setAck, set_response, set_sources, set_user}

