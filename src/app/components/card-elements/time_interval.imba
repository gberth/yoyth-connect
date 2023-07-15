import {color} from "./colors.imba"
import { scales, Chart, registerables } from 'chart.js';
import ChartDataLabels from 'chartjs-plugin-datalabels';
import {state} from "../../controls/index.imba"


import {clone_and_translate_array, translate_text} from '../../controls/helpers.imba'

import TextAndValue from './text_and_value.imba'
import ScrollSegmentIntervals from './scroll_segment_intervals.imba'

Chart.register(...registerables);

export default tag TimeInterval

	css .hoisontal_bar tween:all 200ms ease w:435px
		bgc:warm7  p:10px rd:lg
		d:grid ja:center
		shadow:0 5px 15px black/20

	css .right-icons d:flex jc:flex-end
	css .button-item-icon pos:relative cursor:pointer

	prop element
	prop instancedata

	chart_element
	canvasel
	gr_data = []
	sum_engagement
	hour_chart = false
	hour_set
	last_max

	def get_colors(imba_cols)
		let retcol = []
		for col in imba_cols
				retcol.push(color(col))
		return retcol

	def build
		backgroundColors = null
		borderColors = null

	def set_colors
		backgroundColors = get_colors(element.element_def.backgroundcolors or state.user.userdata.globals.time_backgroundcolors)
		borderColors = get_colors(element.element_def.bordercolors or state.user.userdata.globals.time_bordercolors)

	def get_data
		gr_data = []
		sum_engagement = 0
		for obs in element.metrics[0].engagement
			if Array.isArray(obs.observed)
				gr_data.push(obs.observed[hour_set] or 0)
				sum_engagement += (obs.observed[hour_set] or 0)			
				hour_chart = true 
			else
				gr_data.push(obs.observed or 0)
				sum_engagement += (obs.observed or 0)				
		if element.order == 'C'
			const ll = gr_data.length
			for ix1 in [0 ... ll - 1 ]
				for ix2 in [ix1 + 1 ... ll]
					gr_data[ix1] += gr_data[ix2]
		return gr_data

	def get_config_data
		const data = get_data()
		return
			labels: element.element_def.legends or state.user.userdata.globals.time_legends
			datasets: [
				axis: "y"
				backgroundColor: backgroundColors
				borderColor: borderColors
				borderWidth: 1
				data: data
			]

	def decr_hour()
		hour_set -= 1
		return

	def incr_hour()
		hour_set += 1
		return

	def config
		return
			plugins: [ChartDataLabels]		
			type: 'bar'
			data: get_config_data()
			fontColor: "white" 
			options:
				indexAxis: 'y'
				elements:
					point:
						hitRadius: 5
				scales:
					y:
						ticks:
							color: "white" 
							autoSkip: false
						grid:
							color: "rgba(100,100,100)" 
					x:
						ticks:
							color: "white" 
						grid:
							color: "rgba(0,0,0)" 
				plugins:
					legend:
						display: false
					datalabels:
						color: 'white'
						align: 'right'
						anchor: 'start'


	def render
		if not backgroundColors
			set_colors()
		let header 
		let prevarrow
		let postarrow
		let conf
		if typeof element.max_hour == "number"
			const id = "board" + element.ix
			if typeof hour_set != "number" or element.max_hour > last_max and last_max = hour_set
				hour_set = element.max_hour
			conf = config()
			last_max = element.max_hour

			if element.text.includes("\{hour\}")
				const els = element.text.split("\{hour\}")
				if hour_set > 0
					prevarrow = <a className='material-icons' title='Previous Hour'> "keyboard_arrow_left"
				if hour_set < element.max_hour
					postarrow = <a className='material-icons' title='Next Hour'> "keyboard_arrow_right"
				header = <span> 
					els[0] 
					hour_set 
					els[1]
					" / " + (element.instancedata.segment or "Alle") + " / : Total " + sum_engagement
			else 	
				header = <span> element.text + " / " + (element.instancedata.segment or "Alle") + " /  : Total " + sum_engagement

		<self[d:flex]>
			<div [w:450px][h:300px][bgc:warm8]>
				if typeof element.max_hour == "number"
					<span [c:white]>
						header
						<a.right-icons>
							if prevarrow
								<a.button-item-icon @click=decr_hour>
									prevarrow
							if postarrow
								<a.button-item-icon @click=incr_hour>
									postarrow
							<ScrollSegmentIntervals element=element>
					<p>

					if !chart_element
						canvasel = <canvas#{id}>
						ch = new Chart(canvasel.getContext('2d'), conf)
						chart_element = ch
						canvasel
					else
						chart_element.data.datasets[0].data = get_data()
						chart_element.update()
						canvasel
				else
					<a[c:white]> "waiting for data"
