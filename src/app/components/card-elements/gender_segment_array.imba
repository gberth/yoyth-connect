import {clone_and_translate_array, translate_text} from '../../controls/helpers.imba'
import {current_date} from '../../controls/state.imba' 
import {color} from "./colors.imba"
import "./gender-age-box"
import "./list-box"


import TextAndValue from './text_and_value.imba'

const colors = ["blue", "red", "emerald", "warm"]
const colordown = {"warm": false}
const gender_header = ["IC", "Alle", "F", "M"]
const genders = ["", "F", "M"]
const ageheader = ["Alle", "30-", "30", "40", "50-", "50", "50+", "60", "70+"]
const ages = ["", "30-", "30", "40", "50-", "50", "50+", "60", "70+"]
const colhead = color("warm5")

def get_data(metrics)
	def compare_vals(a, b)
		return b.val - a.val

	def compare_name(a, b)
		if a.name > b.name
			return 1
		else
			return -1 
		return b.val - a.val

	if not Array.isArray(metrics) or metrics.length < 2
		return 

	let agearr = []
	for age in ages
		let genderarr = []
		for gender in genders
			const key = gender + age
			let testresult = {values: [], title:{}}
			for metric in metrics
				if metric.last[key] and metric.last[key].observed
					testresult.title[metric.text] = metric.last[key].observed
					testresult.values.push(metric.last[key].observed)
				else
					testresult.title[metric.text] = 0
					testresult.values.push(0)
			if testresult.values[0] > testresult.values[1]
				testresult.color = 0
			elif testresult.values[1] > testresult.values[0]
				testresult.color = 1
			elif testresult.values[1] == 0 and testresult.values[0] == 0
				testresult.color = 3
			else
				testresult.color = 2
			let newcolix
			if testresult.values[0] and testresult.values[1] 
				const delta = Math.trunc(100 * (Math.abs(testresult.values[0] - testresult.values[1])) / testresult.values[1])
				newcolix = Math.min(5, Math.trunc(delta / 10))
			elif testresult.values[1] == 0 and testresult.values[0] == 0
				newcolix = 1
			else
				newcolix = 5
			testresult.colorix = newcolix

			genderarr.push(testresult)
		agearr.push(genderarr)

	return {result: agearr}

def get_color(incolor, ix)
	const col = incolor or "warm"
	let iix = ix or 0
	let up = true
	if typeof(colordown[col]) != "undefined"
		up = false

	if up
		iix = iix + 4
	else
		iix = 5 - iix
	return color(col + iix.toString())
	
def get_row(row, ix)
	return (
		<tr>
			<td>
				<gender-age-box gender_age_box={title: "", color: colhead, text:ageheader[ix], value:""}>
			for cell in row
				<td>
					<gender-age-box gender_age_box={title: JSON.stringify(cell.title, null, "\t"), color: get_color(colors[cell.color], cell.colorix), text:cell.name or "", values: cell.values}>
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

def get_testlist(tests)
	let ix = 0
	return (
		<div>
			for test in tests
				<span[c:white d:flex]>
					<list-box color=get_color(colors[ix], 5) text=test.name>
					<span[mt:10px ml:10px]>
						test.data.title or "no title"
				ix += 1

	)

tag gender-segment-header
	<self>
		for ht in gender_header
			<th>
				<gender-age-box gender_age_box={title: "", color: colhead, text:ht}>

export default tag GenderSegmentArray

	css .white c:white
	css .check mr:4 cursor:pointer
	css button.checked bxs:inset bg:gray2 o:0.6
	css .toggle cursor:pointer

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
			const data = get_data(element.metrics)
			if not data
				<div>
					"waiting"
			else
				<span[c:white]> "Last timestamp: " + element.timestamp
				<p>
				<div>
					<table>
						<tr>
							<gender-segment-header>
						get_result(data.result)



