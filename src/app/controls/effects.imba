import {state} from "./state"
import {get_type} from "./helpers"

def request(url)
	fetch(url).then((response)
		response.json());

def socket
	let _options = {}
	let _ws = WebSocket
	return {
		initialize: do(options)
			console.dir(options)
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
				_options.sent += 1
				options.onStatusChange({ socket: _options, socket_status: 'error', error: error, errors: _options.errors })
			_ws.onmessage = do |msgin|
				const msg = JSON.parse(msgin.data)
				if msg.connection_id
					console.log(msg)
					_options.connection_id = msg.connection_id
				else
					console.log("her?")
					console.dir(options.onmessage)
					options.onmessage(JSON.parse(msgin.data));
					console.log("etter her?")
			return this
		reinit: do
			this.initialize(_options)
		sendmsg: do(data, toberesent = true)
			def send
				if _options.resend and not _options.restarted 
					if data not in _options.resend_msgs and toberesent
						_options.resend_msgs.push(data)
				if _ws.readyState === 1
					try
						console.log("sending")
						console.log(data)
						_ws.send(JSON.stringify(data))
						_options.sent += 1
						_options.errors = 0
						return true
					catch error
						_options.errors += 1
						console.dir(error);
						return false
				elif _ws.readyState === 0
					_options.waits += 1
					if _options.waits < 100
						console.log(`waiting {_options.host} {_options.waits}`)
						setTimeout(&,500) do
							send()
					else
						console.log(`waited to long {_options.host} `)
						return false
				else
					_ws.onerror do
						_options.onStatusChange({ id: _options.id, socketStatus: 'error', readystate: _ws.readyState, errors: _options.errors})
					return false
			if not send()
				_options.onStatusChange({ id: _options.id, socketStatus: 'error', readystate: _ws.readyState, errors: _options.errors })
		}

export {request, socket}