import {state} from "./state"
def request(url)
	fetch(url).then((response)
		response.json());

def dispatcher
	let MsgtypeRouting = {};
	{
		route: do(type, action)
			console.log("roouuuuuuuuuuuuuuuu", type)
			MsgtypeRouting[type] = action;
		onMessage: do(msg)
			if msg.message_data and msg.message_data.type
				console.log(msg.message_data.type)
				if MsgtypeRouting[msg.message_data.type] 
					MsgtypeRouting[msg.message_data.type](msg);
				else
					let request_msg
					if msg.message_data.request_data and msg.message_data.request_data.request_id
						request_msg = state.requests[msg.message_data.request_data.request_id]
					if request_msg and MsgtypeRouting[request_msg.request_type]
						MsgtypeRouting[request_msg.request_type](msg)
					else
						console.log("not defined " + msg.message_data.type);
						console.log(state.requests)
						console.log(MsgtypeRouting)
						console.log(msg)
						console.log(request_msg)

			else
				console.log("not a message " + msg)
	}

def socket
	let _options = {}
	let _ws = WebSocket
	return {
		initialize: do(options)
			console.log(options)
			_options = options
			_options.sent = 0
			_options.errors = 0
			_options.waits = 0
			_options.connects = 0
			_options.restarted = false
			if not _options.resend_msgs 
				_options.resend_msgs = []
			else
				_options.restarted = true
			_ws = new WebSocket(options.host)
			_ws.onclose = do 
				options.onStatusChange({ socket: _options, socket_status: 'close' })
			_ws.onopen = do
				options.onStatusChange({ socket: _options, socket_status: 'open' })
			_ws.onerror = do(error)
				console.log("ws error", error)
				console.dir(error)
				options.onStatusChange({ socket: _options, socket_status: 'error', error: error })
			_ws.onmessage = do(msgin)
				options.onmessage(JSON.parse(msgin.data));
			return this
		reinit: do
			this.initialize(_options)
		sendmsg: do(data, toberesent = true)
			def send
				if _options.resend and not _options.restarted 
					if data not in _options.resend_msgs  
						_options.resend_msgs.push(data)
				if _ws.readyState === 1
					try
						console.log("sending")
						_ws.send(JSON.stringify(data))
						_options.sent += 1
						return true
					catch error
						_options.errors += 1
						console.dir(error);
						return false
				elif _ws.readyState === 0
					_options.waits += 1
					if _options.waits < 100
						console.log(`waiting ${_options.host} {_options.waits}`)
						setTimeout(&,500) do
							send()
					else
						console.log(`waited to long ${_options.host} `)
						return false
				else
					_ws.onerror do
						_options.onStatusChange({ id: _options.id, socketStatus: 'error', readystate: _ws.readyState })
					return false
			if not send()
				_options.onStatusChange({ id: _options.id, socketStatus: 'error', readystate: _ws.readyState })
		}

let ic_dispatcher = dispatcher()
export {request, ic_dispatcher, socket}