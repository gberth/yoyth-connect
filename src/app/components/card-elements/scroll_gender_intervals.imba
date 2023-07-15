import {clone_and_translate_array, translate_text} from '../../controls/helpers.imba'

import TextAndValue from './text_and_value.imba'
import {state} from "../../controls/index.imba"

const llt = "\u25E3"
const lrt = "\u25E2"
const ult = "\u25E4"
const urt = "\u25E5"
const accum = "\u25E9"
const normal = "\u25E7"
const square = "\u25FC"

# button up, right, down, left
const up = 
	symbols: [urt, square, ult]
	positions: [[true, false, false, true, false, false],[true, false, false, false, true, false],[true, false, false, false, false, true]]

const right = 
	symbols: [lrt, square, urt]
	positions: [[true, false, false, false, false, true],[false, true, false, false, false, true],[false, false, true, false, false, true]]

const down = 
	symbols: [lrt, square, llt]
	positions: [[false, false, true, true, false, false],[false, false, true, false, true, false],[false, false, true, false, false, true]]

const left = 
	symbols: [llt, square, ult]
	positions: [[false, false, true, true, false, false],[false, false, true, false, true, false],[false, false, true, false, false, true]]

const buttons = [up, right, down, left]

export default tag ScrollGenderIntervals

	css .ic-scroll-button tween:all 200ms ease		
		c:cool5 fw:500 pos:relative
		fs:xs rd:md p:0px 
		size:55px
		bgc:cooler6
		c:white ml:0px

	css .symbol pos:absolute size:17px bgc:cooler1
		&.t0 t:2px
		&.t1 t:19px
		&.t2 t:36px
		&.l0 l:2px
		&.l1 l:19px
		&.l2 l:36px
		&.hc bgc:red4 cursor:default
		&.hcs bgc:red6 cursor:pointer
		&.vc bgc:blue4 cursor:default
		&.vcs bgc:blue6 cursor:pointer
		&.oc fs:20px bgc:white6 cursor:pointer c:gray5

	css .trapez pos:absolute t:25px l:8px bdl:10px solid transparent bdr:10px solid transparent w:27px
		&.right rotate:270deg t:23px l:24px bdb:10px solid cooler5
		&.top rotate:180deg t:2px l:5px bdb:10px solid warmer5
		&.bot t:44px l:5px bdb:10px solid warmer5
		&.left rotate:90deg t:23px l:-15px bdb:10px solid cooler5
		&.hcs bdb:10px solid warmer3 cursor:pointer
		&.vcs bdb:10px solid cooler3 cursor:pointer

	prop element
	segment_keys
	current_index
	titles = []
	clicks = []

	def new_instance_data(current, delta)
		def seg_array(gender)
			return segment_keys[1].map do |age|
				return gender + age

		def set_instance_data()
			current_index += delta
			element.current_segment = segment_keys[0][current_index] 
			element.set_instance_data("segment", seg_array(segment_keys[0][current_index]))

		return set_instance_data

	def render
		if not segment_keys
			segment_keys = element.element_def.segment_keys
			current_index = 0
			element.current_segment = segment_keys[0][0]

		clicks = [null, null, null, null]
		titles = [null, null, null, null]
		colors = [false, false, false, false]
		if current_index > 0
			clicks[0] = new_instance_data(current_index, -1) 
			titles[0] = segment_keys[0][current_index - 1] or "All"
			colors[0] = true
		if current_index < segment_keys[0].length - 1
			clicks[2] = new_instance_data(current_index, 1) 
			titles[2] = segment_keys[0][current_index + 1] or "All"
			colors[2] = true

		let order
		const ok = true
		const notok = false
		if not element.order or element.order == 'N'
			order = 'C'
		else 
			order = 'N'
		<self>
			<div.ic-scroll-button>
				<div>
					<div.trapez .top=ok .hcs=colors[0] @click=clicks[0] title=titles[0] >
					<div.trapez .right=ok .vcs=colors[1] @click=clicks[1] title=titles[1]>
					<div.trapez .bot=ok .hcs=colors[2] @click=clicks[2] title=titles[2]>
					<div.trapez .left=ok .vcs=colors[3] @click=clicks[3] title=titles[3]>

				<span.symbol .t1=ok .l1=ok .oc=ok @click=element.flip_order title=title="order">
					if order == 'C'
						<a> accum
					else	
						<a> normal