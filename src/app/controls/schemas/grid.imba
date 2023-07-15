export const gridSchema =
	title: 'icgrid',
	version: 0,
	description: 'describes a ac grid items',
	primaryKey: 'id',
	type: 'object',
	properties: 
		id:
			type: 'string'
		gridData:
			type: 'object'
	required: ['id']