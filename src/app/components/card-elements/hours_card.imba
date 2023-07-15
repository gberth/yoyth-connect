import TextAndValue from './text_and_value.imba'

export default tag HoursCard

	css .hours_text tween:all 200ms ease
		bgc:cooler2  p:10px rd:lg
		d:flex jc:left
		shadow:0 5px 15px black/20
	prop dashboard
	prop ix

	<self>
		carddata = dashboard.board.get_text_elements()
		<div.hours_text>
			<div>
				<h3> carddata.header
				if carddata.info
					carddata.info
				<br>
				for line in carddata.lines
					<TextAndValue text=line[0] val=line[1]>
				<p>
				if carddata.footer
					<div [font:small]>
						carddata.footer
