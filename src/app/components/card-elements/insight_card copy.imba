import MultipleMetrics from './multiple_metrics'
import MetricCard from './metric_card'
import {clone_and_translate_array, translate_text} from '../../controls/helpers.imba'

const card_types =
	"metric_card": MetricCard
	"multiple_metrics": MultipleMetrics


export default tag InsightCard

	css .insight_card tween:all 200ms ease
		bgc:green2  p:10px rd:lg
		d:flex jc:left
		shadow:0 5px 15px black/20
	prop dashboard
	prop instancedata

	<self>
		<div.insight_card>
			<div>
				<h3> translate_text(dashboard.text, instancedata)
				<br>
				# for card in dashboard.cards
					# new card_types[card.type](card, instancedata)

