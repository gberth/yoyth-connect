export const icDaysSchema =
	title: 'icDaysMetrics',
	version: 0,
	description: 'keeps day records in object format',
	primaryKey: 'card_key',
	type: 'object',
	properties: 
		card_key:
			type: 'string'
		source:
			type: 'string'
		group:
			type: 'string'
		metric:
			type: 'string'
		key:
			type: 'string'
	attachments:
		encrypted: false # if true, the attachment-data will be encrypted with the db-password
