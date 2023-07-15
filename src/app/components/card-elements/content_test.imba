import {clone_and_translate_array, translate_text} from '../../controls/helpers.imba'
import {current_date} from '../../controls/state.imba' 
import {color} from "./colors.imba"
import "./content-box"
import "./list-box"


import TextAndValue from './text_and_value.imba'

const colors = ["emerald", "red", "blue", "fuchsia", "sky", "warm", "red"]
const colordown = {"warm": false}
const gender_header = ["IC", "Alle", "F", "M"]
const genders = ["", "F", "M"]
const ageheader = ["Alle", "30-", "30", "40", "50-", "50", "50+", "60", "70+"]
const ages = ["", "30-", "30", "40", "50-", "50", "50+", "60", "70+"]
const colhead = color("warm5")

def get_data(current)
	def compare_vals(a, b)
		return b.val - a.val

	def compare_name(a, b)
		if a > b
			return 1
		else
			return -1 

	if not current.card
		return
	if not Array.isArray(current.card.group_list)
		current.card.group_list = Object.keys(current.card.groups)
	const grouplist = current.card.group_list.sort(compare_name)
	const segments = current.card.segments
	
	let groups = []
	let noof_groups = 0
	for group in grouplist		
		noof_groups += 1
		groups.push({name: group, ix: noof_groups, data: current.card.groups[group]})
	let ref_n = 0
	let ref_t = 0
	let ref_factor = 0
	let n = 0
	let t = 0
	let factor = 0
	let agearr = []
	let newcolix
	for age in ages
		let genderarr = []
		let genderix = -1
		for gender in genders
			genderix += 1
			const key = gender + age
			ref_n = 0
			ref_t = 0
			ref_factor = 0
			const card = current.card.segments[key] or current.card.groups["all_sites"]
			const ref_card = current.card.segments[gender] or current.card.groups["all_sites"]

			if ref_card
				ref_n = ref_card.n
				ref_t = ref_card.t
			if ref_n > 0
				ref_factor = ref_t / ref_n

			if card
				n = card.n
				t = card.t
			if n > 0
				factor = t / n
			
			if factor and ref_factor
				const delta = Math.trunc(100 * (factor - ref_factor) / ref_factor)
				if delta < -15
					newcolix = 3
				elif delta < -10
					newcolix = 4
				elif delta < -5
					newcolix = 5
				elif delta < 5
					newcolix = 6
				elif delta < 10
					newcolix = 7
				elif delta < 15
					newcolix = 8
				else 
					newcolix = 9
			else
				newcolix = 6

			let testresult = {title:card, colorix: newcolix, color: genderix, value: {n:n, t:t, factor:factor.toFixed(0)} }
			genderarr.push(testresult)
		agearr.push(genderarr)
	return {groups: groups, result: agearr}

def get_color(incolor, ix)
	const col = incolor or "warm"
	return color(col + ix.toString())
	
def get_row(row, ix)
	return (
		<tr>
			<td>
				<content-box content_box={title: "", color: colhead, text:ageheader[ix], value:{}}>
			for cell in row
				<td>
					<content-box content_box={title: JSON.stringify(cell.title, null, "\t"), color: get_color(colors[cell.color], cell.colorix), value:cell.value}>
	)


def get_result(result_data)
	let ix = 0
	return (
		<tr>
			for row in result_data
				<span>
					get_row(row, ix)
					ix += 1
	)

def get_grouplist(groups)

	return (
		<div>
			for group in groups
				const titlex = JSON.stringify(group.data, null, "\t")

				<div[d:grid border:5x bgc:warm7 cursor:hand position:relative pointer-events:auto] title=titlex>
					<TextAndValue text_and_value={text:group.name, value:group.data.n}>

	)

def toggle_ratio(view_props)
	view_props.ratio = !view_props.ratio
	return

tag content-header
	<self>
		for ht in gender_header
			<th>
				<content-box content_box={title: "", color: colhead, text:ht}>

export default tag ContentTest

	css .white c:white
	css .check mr:4 cursor:pointer
	css button.checked bxs:inset bg:gray2 o:0.6
	css .toggle cursor:pointer
	css .view-button pos:relative cursor:pointer
		

	prop element = {}
	prop instancedata

	values
	reftxt

	colhead = color("warm5")

	view_props = {
		ratio: false
	}
	def render

		<self>
			const data = get_data(element.metrics[0].current)
			if not data
				<div>
					"waiting"
			else
				<span[c:white]> "Last timestamp: " + element.timestamp
				<p>
				<span[c:white]> "Content id: " + element.instancedata.instance_name + " - " + element.metrics[0].current.card.url or "" 
				<p>
				get_grouplist(data.groups)
				<p>
				<div>
					<table>
						<tr>
							<content-header>
						get_result(data.result)



