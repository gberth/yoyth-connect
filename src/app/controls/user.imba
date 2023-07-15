import {create_dashboards, get_source_data, insert_menu_item } from "./actions.imba"
import {state} from "./index.imba"
import {translate_text} from "./helpers"

export class user
	constructor id, data
		userid = id
		userdata = data
		console.log("datadata", data)
		let new_group
		let old_group
		for own source, sourcedata of userdata.sources
			console.log("sourcedata", sourcedata)
			new_group = undefined
			old_group = undefined
			for own group, groupdata of sourcedata.groups
				console.log('ggggggggg', group, groupdata)
				if state.sitekey and group.includes("\{sitekey\}")
					new_group = group.replace("\{sitekey\}", state.sitekey)
					old_group = group

				if groupdata.now
					if source === "maximinus"
						get_source_data(source, "now", {"cardkey": (new_group or group)})
					else
						get_source_data(source, "now", {"cardkey": source + "#" + (new_group or group)})
				
				if source === "maximinus" and !state.test
					for metric in state.source[source].metrics
						get_source_data(source, "days", {"start_key": (new_group or group) + "#" + metric + "#", "end_key": (new_group or group) + "#" + metric + "#x"})
			if new_group
				sourcedata.groups[new_group] = sourcedata.groups[old_group]
				delete sourcedata.groups[old_group]
		# insert Dashboards in menu
		const menu_items = insert_menu_item(state.menu, "Dashboards", {"collapsed": true})
		insert_menu_item(state.menu, "content", {"flip": "content_test"})
		insert_menu_item(state.menu, "ab-test", {"flip": "ab_test"})

		for prof in userdata.dashboard_profiles
			let db_menu_items = insert_menu_item(menu_items, prof.profile_name, {"collapsed": true})
			for dashboard in prof.dashboards
				if state.sitekey
					for ip in dashboard.instance_parameters
						for own ikey, ival of ip
							if typeof ival === "string"
								ip[ikey] = ip[ikey].replace("\{sitekey\}", state.sitekey)

				create_dashboards(db_menu_items, dashboard)
		console.log(state.menu)
	def new_metrics 