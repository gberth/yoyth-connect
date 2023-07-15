import {state} from "../controls/index.imba"
import InsightBoard from './card-elements/insight_board.imba'

const dashboard_types = 
	insight_board: InsightBoard

tag dashboards
	<self>
		for dashboard, bix in state.dashboards
			if not dashboard.instancedata.hidden
				<div [d:flex]>
					if dashboard.dashboard_type and dashboard_types[dashboard.dashboard_type]
						<div[d:grid gtc:1fr 1fr gap:4 pos:abs w:100% h:100% p:4]>
						<{dashboard_types[dashboard.dashboard_type]} dashboard=dashboard>

