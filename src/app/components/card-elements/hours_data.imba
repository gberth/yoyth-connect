import {color} from "./colors.imba"

def color_id(gt, lt, sum, ref)
	let ix = 0
	let color
	if sum >= ref
		color = gt
		#	console.log(">", color, sum, ref, Math.trunc(((sum / ref - 1) * 100 / 2))) 
		ix = Math.trunc(((sum / ref - 1) * 100 / 2))
	else
		color = lt
		#	console.log("<", color, sum, ref, Math.trunc(((1 - sum / ref ) * 100 / 2))) 
		ix = Math.trunc(((1 - sum / ref ) * 100 / 2))

	ix = Math.min(ix, 9)
	return color + ix

export class hours_data
	constructor data, text_element
		board_def = data
		data_updated = false
		data_complete = false
		ref_hours
		ref_total
		ts = ""
		total
		hours
		error_mode = false
		metrics
		chart_element
		canvas_element
		max_hour
		max_minute
		ref_now
		chart = "chart_card"
		card = "hours_card"  
		current_hour = 0
		current_min = 0
		computed_ref = 0
		sum_current_hour = 0
		ref_current_hour = 0
		computed_ref = 0

		# TODO midnight

		if board_def.metrics
			metrics = board_def.metrics
			console.log(metrics)
			if not metrics.hours
				error_mode = true
				console.error("boarddef missing hours metric dougnut_hour", board_def)
			if not metrics.total
				error_mode = true
				console.error("boarddef missing total metric dougnut_hour", board_def)
		else
			error_mode = true
			console.error("boarddef missing metrics", board_def)

	def get_chart
		return chart

	def get_card
		return card

	def set_chart_element(canvas, chel)
		canvas_element = canvas
		chart_element = chel

	def get_text_elements
		if not data_complete
			return {
				header: board_def.board_name + "(waiting)"
				lines: []
			}
		return {
			header:  board_def.board_name
			footer: ts
			lines: [
				["Sum i dag", total]
				["Beregnet referanse så langt", ref_now]
				["Referanse verdi i dag", Math.trunc(ref_total.mean)]
				["max", ref_total.max + " - " + ref_total.maxdate]
				["min", ref_total.min + " - " + ref_total.mindate]
			]
		}

	def get_chart_element()
		return {canvas_element, chart_element}


	def set_dashboard_data(type, card, its, rt)
		# if type not ref, assumes value
		if error_mode
			console.error("error mode on for dougnut_hour", board_def.board_name)
			return
		its = its.replace("T", " ")
		console.log('we got data type', type, rt)
		console.log('we got data ts', its, ts)
		console.log('we got data card', card)
		console.log(board_def)
		if type === "ref" and not rt
			if card[metrics.total]				
				ref_total = card[metrics.total]
			if card[metrics.hours]
				ref_hours = card[metrics.hours]
			data_updated = true
			console.log("ref", rt, ref_total, ref_hours)
		elif type === "rt" and rt
			# midnight
			if its.substring(0,10) > ts.substring(0:10)
				max_hour = 0
				max_minute = 0

			if its > ts
				ts = its
			if card[metrics.total]
				total = card[metrics.total]
			if card[metrics.hours]
				hours = card[metrics.hours]
			console.log("rt", rt, total, hours)
			data_updated = true
		if ref_total and total and ref_hours and hours
			data_complete = true
			console.log("data")
			console.log("total", total, hours, ref_total, ref_hours)
			current_hour = Math.max(max_hour, parseInt(ts.substring(11,13)))
			if current_hour > max_hour
				max_minute = 0

			current_min = Math.max(max_minute, parseInt(ts.substring(14,16)) + 1)
			computed_ref = 0
			console.log(current_hour, current_min, ts)
			if current_hour > 0		
				for hr, ix in [0...current_hour]
					computed_ref += ref_hours[ix].mean

			sum_current_hour = hours[current_hour]
			ref_current_hour = Math.trunc(ref_hours[current_hour].mean * current_min / 60)

			computed_ref = Math.trunc(computed_ref + ref_current_hour)
			ref_now = computed_ref

	def create_chartjs_config()

		let bgc = []
		let bgc_ref = []
		let data = [] 
		let data_ref = []
		let labels = []

		const ref_color = color(color_id("green", "red", total, computed_ref))
		console.log(current_hour, current_min)

		for hr, ix in hours 
			if ix < current_hour
				bgc_ref.push(ref_color)
				bgc.push(color(color_id("green", "red", hours[ix], ref_hours[ix].mean)))
				data.push(hours[ix])
				data_ref.push(ref_hours[ix].mean)
				labels.push("h"+ix + " " + hours[ix] + "/" + Math.trunc(ref_hours[ix].mean))
			elif ix > current_hour
				bgc_ref.push(color("warm2"))
				bgc.push(color("warm2"))
				data.push(ref_hours[ix].mean)
				data_ref.push(ref_hours[ix].mean)
				labels.push("h"+ix + " " + hours[ix] + "/" + Math.trunc(ref_hours[ix].mean))
			else
				bgc_ref.push(ref_color)
				bgc.push(color(color_id("cyan", "fuchsia", sum_current_hour, ref_current_hour)))
				data.push(sum_current_hour)
				data_ref.push(ref_hours[ix].mean)
				labels.push("h"+ix + " " + sum_current_hour + "/" + ref_current_hour + "/" + Math.trunc(ref_hours[current_hour].mean))

		const doughnut_data =
			labels: labels
			datasets: [
				{
					circumference: 320
					rotation: 200
					label: 'Current data'
					data: data
					backgroundColor: bgc
					hoverOffset: 4
					animation:
						animateRotate: false
				},
				{
					circumference: 320
					rotation: 200
					label: 'Reference data'
					data: data_ref
					backgroundColor: bgc_ref
					hoverOffset: 4
					animation:
						animateRotate: false
				}
			]

		const config =
			type: 'doughnut'
			data: doughnut_data
			options:
				plugins:	
					legend:
						position: "right"
		console.log(config)
		data_updated = false
		return config
