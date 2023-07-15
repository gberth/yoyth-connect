export const icUserSchema =
	title: 'icuser',
	version: 0,
	description: 'keeps user data',
	primaryKey: 'user',
	type: 'object',
	properties: 
		user: 
			type: 'string'
		userdata: 
			type: 'object'