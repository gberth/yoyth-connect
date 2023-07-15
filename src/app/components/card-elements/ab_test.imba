import {clone_and_translate_array, translate_text} from '../../controls/helpers.imba'
import {current_date} from '../../controls/state.imba' 
import {color} from "./colors.imba"
import "./ab-box"
import "./list-box"


import TextAndValue from './text_and_value.imba'

const colors = ["red", "blue", "emerald", "fuchsia", "sky", "warm"]
const colordown = {"warm": false}
const gender_header = ["IC", "Alle", "F", "M"]
const genders = ["", "F", "M"]
const ageheader = ["Alle", "30-", "30", "40", "50-", "50", "50+", "60", "70+"]
const ages = ["", "30-", "30", "40", "50-", "50", "50+", "60", "70+"]
const colhead = color("warm5")

def get_data(current, read_pr_click=true)
	def compare_vals(a, b)
		return b.val - a.val

	def compare_name(a, b)
		if a.name > b.name
			return 1
		else
			return -1 
		return b.val - a.val
	if not current.card
		return 
	let tests = []
	let noof_tests = 0
	for own test, testdata of current.card
		if typeof testdata == "object"
			noof_tests += 1
			tests.push({name: test, ix: noof_tests, data: testdata})

	tests = tests.sort(compare_name)

	let agearr = []
	for age in ages
		let genderarr = []
		for gender in genders
			let testresult = {click: 0, read: 0, value: 0, sum: 0, title:{}, name: ""}
			let sort_arr = []
			tests.map do(test, ix)
				testresult.title[test.name] = {...test.data[gender + age]}
				if test.data[gender + age]
					const testd = test.data[gender + age]
					let reads = testd.read or 0
					let clicks = testd.click or 0
					let views = testd.view or 0
					let ratio = 0
					let val = 0
					let new_winner = false
					let newcolix
					if clicks
						ratio = (reads / clicks)
					if read_pr_click
						val = ratio
					else 
						val = clicks

					if read_pr_click and ix > 0 and testresult.sum > 0
						testresult.sum = (((testresult.sum * ix) + val) / (ix + 1))
					else
						testresult.sum += val

					if val > testresult.value or ix == 0 
						new_winner = true
					elif val == testresult.value
						if reads > testresult.read
							new_winner = true
						elif reads == testresult.read and clicks > testresult.click
							new_winner = true
						elif reads == testresult.read and clicks == testresult.click and views < testresult.view 
							new_winner = true

					sort_arr.push({name: test.name, val: val})

					if ratio
						testresult.title[test.name].ratio = ratio

					if val and testresult.value
						const delta = Math.trunc(100 * (Math.abs(val - testresult.value)) / testresult.value)
						newcolix = Math.min(5, Math.trunc(delta / 10))
					else 
						newcolix = 5

					if new_winner 
						testresult.color = ix
						testresult.value = val
						testresult.read = testd.read or 0
						testresult.click = testd.click or 0
						testresult.view = testd.view or 0
						testresult.name = test.name
						testresult.colorix = newcolix
						# testresult.title[test.name].colix = ix

					if val and newcolix < testresult.colorix
						testresult.colorix = newcolix

					# testresult.title[test.name].colix = testresult.colorix 
			const sorted = sort_arr.sort(compare_vals)
			testresult.name = testresult.name + "-"
			for t in sorted
				testresult.name += t.name
			if read_pr_click
				testresult.sum = testresult.sum.toFixed(2)
				testresult.value = testresult.value.toFixed(2)

			genderarr.push(testresult)
		agearr.push(genderarr)
	return {tests: tests, result: agearr, content_id: current.card.content_id}

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
				<ab-box ab_box={title: "", color: colhead, text:ageheader[ix], value:""}>
			for cell in row
				<td>
					<ab-box ab_box={title: JSON.stringify(cell.title, null, "\t"), color: get_color(colors[cell.color], cell.colorix), text:cell.name or ".", value: cell.value or "0", sum: cell.sum or "0"}>
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
				<span[c:white d:flex position:relative]>
					<list-box color=get_color(colors[ix], 5) text=test.name>
					<span[mt:10px ml:10px]>
						test.data.title or "no title"
				ix += 1

	)

def toggle_ratio(view_props)
	view_props.ratio = !view_props.ratio
	return

tag ab-header
	<self>
		for ht in gender_header
			<th>
				<ab-box ab_box={title: "", color: colhead, text:ht}>

tag view_button
	prop view_props
	css .white c:white
	<self>
		<button[bgc:warm6] @click=toggle_ratio(view_props)>
			if view_props.ratio
				<a.white> "Show clics"		
			else
				<a.white> "Show reads/clic"

export default tag AbTest

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
			const data = get_data(element.metrics[0].current, view_props.ratio)
			if not data
				<div>
					"waiting"
			else
				<span[c:white]> "Last timestamp: " + element.timestamp
				<p>
				if view_props.ratio
					<span[c:white]> "Test " + element.instancedata.group + " / " + element.instancedata.instance_name + " --->   Read points pr clic"
				else
					<span[c:white]> "Test " + element.instancedata.group + " / " + element.instancedata.instance_name + " --->  Clicks"
				<p>
				<span[c:white]> "Content id: " + data.content_id
				<p>
				get_testlist(data.tests)
				<p>
				<view_button.view-button view_props=view_props>
				<p>
				<div>
					<table>
						<tr>
							<ab-header>
						get_result(data.result)



