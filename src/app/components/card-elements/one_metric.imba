import {clone_and_translate_array, translate_text} from '../../controls/helpers.imba'

import TextAndValue from './text_and_value.imba'

export default tag OneMetric

	css .one_metric_box tween:all 200ms ease w:435px
		bgc:blue4  p:10px rd:lg
		d:flex jc:center
		shadow:0 5px 15px black/20
	css .txt cursor:pointer

	prop element
	prop instancedata
	refmean
	reftxt
	refnow
	last

	<self>
		last = element.metrics[0].last.observed
		if element.metrics[0].ref and element.metrics[0].ref.observed and element.metrics[0].ref.observed.mean
			refobj = element.metrics[0]
			refmean = Math.trunc(refobj.ref.observed.mean)
			reftxt = JSON.stringify(element.metrics[0].ref.observed)
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
		<{divx}>
			<div.txt title=reftxt>
				<a [c:white]> element.text
				<br>	
				<a [c:white]> (last or 0) + " / " + (refnow or 0) + " / " + (refmean or 0)
