import {get_state_value} from '../controls/actions.imba' 
import {current_date} from '../controls/state.imba' 
import {clone_and_translate_array, translate_text} from '../controls/helpers'

def state_values(defs, instancedata)
	let retobj = {}
	for own name, arr of defs
		if Array.isArray(arr)
			retobj[name] = get_state_value(clone_and_translate_array(arr, instancedata))
		elif typeof arr === "string"
			retobj[name] = translate_text(arr, instancedata)
		else
			retobj[name] = arr
	return retobj

export class dashboard_element
	constructor elementdef, idata, ix
		ix = ix
		element_def = elementdef
		instancedata = {...idata} 
		text = ""
		factor
		usefactor
		metrics = []
		type = element_def.type
		timestamp
		max_hour
		max_minute = 0
		rt_ts
		order

		if element_def.text
			text = translate_text(element_def.text, instancedata)

		if element_def.state
			if element_def.state.factor
				factor = state_values(element_def.state.factor, instancedata)
		update_state()

	def update_state()
		let metricdefs
		metrics = []
		if element_def.state.metric
			metricdefs = [element_def.state.metric]
		else
			metricdefs = element_def.state.metrics or []
		for metric in metricdefs
			metrics.push(state_values(metric, instancedata))

	def flip_order()
		if not order or order == 'N'
			order = 'C'
		else 
			order = 'N'

	def set_instance_data(iname, ival)
		instancedata[iname] = ival
		update_state()

	def notify(ts)
		if not timestamp or ts > timestamp
			timestamp = ts
		rt_ts = current_date
		const current_hour = Math.max(max_hour or 0, parseInt(timestamp.substring(11,13)))
		if typeof max_hour != "number" or current_hour > max_hour
			max_hour = current_hour
			max_minute = 0

		max_minute= Math.max(max_minute, parseInt(timestamp.substring(14,16)) + 1)
		if factor and timestamp and factor.hours and factor.total
			let computed_ref = 0
			if current_hour > 0		
				for hr, ix in [0 ... current_hour]
					if factor.hours.observed
						computed_ref += factor.hours.observed[ix].mean
			let ref_current_hour
			if factor.hours.observed and factor.hours.observed[current_hour]
				ref_current_hour = Math.trunc((factor.hours.observed[current_hour].mean or 0) * max_minute / 60)
			if factor.total.observed and factor.total.observed.mean
				usefactor = Math.trunc(computed_ref + ref_current_hour) / factor.total.observed.mean
