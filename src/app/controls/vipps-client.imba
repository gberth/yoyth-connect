import fetch from 'cross-fetch'
import {state} from "../controls/index.imba"

export class vipps_client
	constructor config
		config = config

	def load url
		fetch(url).then(do(res)
			return res.json).catch(do(res)
				return error)

	def vipps_fetch({ uri, body, method = 'POST' })
		const { access_token } = await this.getAccessToken()

		const options =
			headers:
				'Content-Type': 'application/json'
				'Ocp-Apim-Subscription-Key': config.subscriptionId
				'Authorization': `Bearer ${access_token}`
			method: method
			body: JSON.stringify(body)

		load(`${this.config.baseUrl}${uri}`, options).then(do(response)
			return response
		).catch(do(error)
			return error
		)