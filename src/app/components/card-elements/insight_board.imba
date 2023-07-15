import MultipleMetrics from './multiple_metrics'
import OneMetric from './one_metric'
import PrSecondMultiple from './pr_second_multiple'
import TimeInterval from './time_interval.imba'
import AgeSegmentIntervals from './age_segment_intervals'
import AbTest from './ab_test'
import ContentTest from './content_test'
import GenderSegmentArray from './gender_segment_array'

import {clone_and_translate_array, translate_text} from '../../controls/helpers.imba'

const element_types =
	"one_metric": OneMetric
	"multiple_metrics": MultipleMetrics
	"pr_second_multiple": PrSecondMultiple
	"time_interval": TimeInterval
	"age_segment_intervals": AgeSegmentIntervals
	"ab_test": AbTest
	"gender_segment_array": GenderSegmentArray
	"content_test": ContentTest


export default tag InsightBoard
	css .insight_board tween:all 200ms ease w:480px
		bgc:warm9  p:10px rd:lg
		d:flex ja:center
		shadow:0 5px 15px black/20
	prop dashboard\object
	maxts = ""

	<self>
		if dashboard.hidden
			return
		<div.insight_board>
			<div [jc:center w:450px]>
				maxts = ""
				for element, eix in dashboard.elements
					if element.timestamp > maxts
						maxts = element.timestamp

				<a [c:white]> translate_text(dashboard.text, dashboard.instancedata) 
				<div.span [w:450px]>
					<a [c:white]> maxts
				<br>
				<p>
				for element, eix in dashboard.elements
					<div [d:grid]>
						if element.type and element_types[element.type]
							<{element_types[element.type]} element=element instancedata=dashboard.instancedata>
							<p>
