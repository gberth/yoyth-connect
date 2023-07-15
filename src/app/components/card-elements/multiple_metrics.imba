import {clone_and_translate_array, translate_text} from '../../controls/helpers.imba'
import TextAndValue from './text_and_value.imba'

export default tag MultipleMetrics

	css .multiple_metrics tween:all 200ms ease w:435px
		bgc:warm7  p:10px rd:lg
		d:grid ja:center
		shadow:0 5px 15px black/20
	css .one_metric_box ease w:400px
		d:grid bgc:pink4  p:10px rd:lg

	prop element
	prop instancedata
	refmean
	reftxt
	refnow
	last
	values
	text
	<self>
		<div.multiple_metrics>
			<a [c:white]> element.text
			<p>
			for metric in element.metrics
				<div>
					last = metric.last.observed
					if metric.ref and metric.ref.observed and metric.ref.observed.mean
						refobj = metric
						refmean = Math.trunc(refobj.ref.observed.mean)
						reftxt = JSON.stringify(metric.ref.observed)
					else
						refobj = {}
						refmean = ""
						reftxt = ""
					
					refnow = ""

					if last and refmean and element.usefactor
						refnow = Math.trunc(refmean * element.usefactor)
					if element.usefactor and last and refmean
						if (last > refnow and not refobj.reversed_factor) or (last < refnow and refobj.reversed_factor)  
							divx = <div.one_metric_box [bgc:blue5]>
						elif (last < refnow and not refobj.reversed_factor) or (last > refnow and refobj.reversed_factor)
							divx = <div.one_metric_box [bgc:indigo4]>
						else
							divx = <div.one_metric_box [bgc:indigo3]>
					else
						divx = <div.one_metric_box [bgc:warm6]>
					if refmean == "" and refnow == ""
						values = (last or 0) 
					else
						values = (last or 0) + " / " + (refnow or 0) + " / " + (refmean or 0)
					text = metric.text
					<{divx}>
						<TextAndValue text_and_value={text:metric.text, value:values, title:reftxt}>
