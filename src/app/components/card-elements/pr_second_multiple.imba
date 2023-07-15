import {clone_and_translate_array, translate_text} from '../../controls/helpers.imba'
import {current_date} from '../../controls/state.imba' 


import TextAndValue from './text_and_value.imba'

export default tag PrSecondMultiple

	css .prsec_metrics tween:all 200ms ease w:435px
		bgc:warm7  p:10px rd:lg
		d:grid ja:center
		shadow:0 5px 15px black/20
	css .one_metric_box ease w:400px d:grid 
		bgc:pink4 p:10px rd:lg

	prop element
	prop instancedata
	divx
	values
	reftxt
	<self>
		<div.prsec_metrics>
			<a [c:white]> element.text
			<p>

			for metric in element.metrics
				<div>
					const now = new Date()
					const today = metric.total.observed
					if metric.last_rt_ts
						const seconds = (now.getTime() - metric.last_rt_ts.getTime()) / 1000
						if seconds > 0 and today > metric.last_value
							metric.prsec = Math.trunc((today - metric.last_value) / seconds)
						elif seconds > 40
							metric.prsec = 0

					if today - metric.last_value > 0
						metric.last_rt_ts = now
					if element.max_hour and metric.hours.observed and metric.hours.observed[element.max_hour]
						metric.thishour = metric.hours.observed[element.max_hour]
					metric.last_value = today
					values = (today or 0) + " / " + (metric.thishour or 0) + " / " + (metric.prsec or 0)
					const reftxt = ""
					<div.one_metric_box [bgc:blue5]>
						<TextAndValue text_and_value={text:metric.text, value:values, title:reftxt}>
