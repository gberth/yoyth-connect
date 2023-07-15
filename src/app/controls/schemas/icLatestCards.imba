export const icLatestCardsSchema =
	title: 'icLatestCards',
	version: 0,
	description: 'keeps latest ic-cards in object format',
	primaryKey: 'card_key',
	type: 'object',
	properties: 
		card_key:
			type: 'string'
		group: 
			type: 'string'
		lastdate:
			type: 'string'
	attachments:
		encrypted: false