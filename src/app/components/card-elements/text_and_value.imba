
export default tag TextAndValue
	prop text_and_value
	css .txt d:flex jc:space-between jc:flex-start w:395px
	css .jleft d:flex jc:space-between jc:flex-start w:200px
	css .jright d:flex jc:flex-end
	<self>
		<span.txt>
			<span.jleft>
				<span [c:white]> text_and_value.text
			<span.jright>
				<span [c:white]> text_and_value.value

