import {create_socket, sendCommand} from "./actions.imba"
import {state} from "./state"

export class source
	constructor source, data
		source_id = source
		source_data = data
		connections = {}
		metrics = []
		if data.connections
			for own connection, connection_data of data.connections 
				connections[connection] = connection_data
				connections[connection].id = source_id + "." + connection
				if connection_data.method === "wss"
					create_socket({
						id: connections[connection].id
						host: connection_data.url
						resend: connection_data.resend
						reconnect: connection_data.reconnect
					})
		
		if data.metric_groups
			for own metric_group, metric_elements of data.metric_groups
				metrics = metrics.concat(metric_elements.metrics) 
		console.log(source_id, metrics, source_data)
	def debug
		console.log('debug source')
		console.log('source', source_id)
		console.log('data', source_data)

	def get_data(period, payload_template)
		let new_payload = {}
		let sourcedata = source_data.sources[period]
		if (!sourcedata or !sourcedata.connection)
			return
		let connection_data = connections[sourcedata.connection]
		if (!connection_data)
			return
		for own key, value of connection_data.payload
			if key === 'table' and sourcedata.table
				new_payload["table"] = sourcedata.table
			elif payload_template[key]
				new_payload[key] = payload_template[key]
		const identity_data = connection_data.identity_data || {} 
		if not identity_data.access_token
			identity_data.access_token = state.access_token

		console.log({
			type: sourcedata.type
			request_type: sourcedata.request_type or period
			source: source_id
			payload: new_payload
			identity_data: identity_data
			wsid: connection_data.wsid
		})
		sendCommand({
			type: sourcedata.type
			request_type: sourcedata.request_type or period
			source: source_id
			payload: new_payload
			identity_data: identity_data
			wsid: connection_data.id
		})
