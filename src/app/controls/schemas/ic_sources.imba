export const icSourcesSchema =
	title: 'icsources',
	version: 0,
	description: 'keeps sources config data',
	primaryKey: 'source',
	type: 'object',
	properties: 
		source: 
			type: 'string'
		config: 
			type: 'string'

