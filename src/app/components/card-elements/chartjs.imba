import { Chart, registerables } from 'chart.js';
import {color} from './colors.imba'
Chart.register(...registerables);

export default tag Chartjs
	prop dashboard
	prop ix
	<self[d:flex]>
		const id = "board" + ix
		board = dashboard.board
		<div [size:150]>
			if board.data_complete
				{canvas_element, chart_element} = board.get_chart_element() 
				if chart_element
					chart_element.destroy()
				let canvasel = <canvas#{id}>
				ch = new Chart(canvasel.getContext('2d'), board.create_chartjs_config())
				const xx = board.set_chart_element(canvasel, ch)
				canvasel
