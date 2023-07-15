import {color} from "./colors.imba"

def color_id(gt, lt, sum, ref)
	let ix = 0
	let color
	if sum > ref
		color = gt
		ix = Math.trunc(Math.max(0, (ref / sum - 0.8) * 100) / 2)
	else
		color = lt

		ix = Math.trunc(Math.max(0, sum / ref - 0.8) * 100 / 2)
	ix = 9 - Math.min(ix, 9)
	return color + ix

export def date_data(hour_and_ref)
	{ts, sum, hours, ref, refHours} = hour_and_ref

	const current_hour = parseInt(ts.substring(11,13))
	const current_min = parseInt(ts.substring(14,16)) + 1
	let bgc = []
	let bgc_ref = []
	let data = [] 
	let data_ref = []
	let computed_ref = 0
	let labels = []
	if current_hour > 0		
		for hr, ix in [0...(current_hour - 1)]
			computed_ref += hours[ix]

	const sum_current_hour = Math.trunc(hours[current_hour] * current_min / 60)
	const ref_current_hour = Math.trunc(refHours[current_hour] * current_min / 60)

	computed_ref = computed_ref + ref_current_hour

	const ref_color = color(color_id("blue", "red", sum, computed_ref))

	for hr, ix in hours 
		if ix < current_hour
			bgc_ref.push(ref_color)
			bgc.push(color(color_id("blue", "red", hours[ix], refHours[ix])))
			data.push(hours[ix])
			data_ref.push(refHours[ix])
			labels.push("h"+ix + " " + hours[ix] + "/" + refHours[ix])
		elif ix > current_hour
			bgc_ref.push(color("warm0"))
			bgc.push(color("warm0"))
			data.push(refHours[ix])
			data_ref.push(refHours[ix])
			labels.push("h"+ix + " " + hours[ix] + "/" + refHours[ix])
		else
			if sum_current_hour > ref_current_hour
				bgc_ref.push(ref_color)
				bgc.push(color(color_id("blue", "red", sum_current_hour, ref_current_hour)))
				data.push(hours[ix])
				data_ref.push(refHours[ix])
				labels.push("h"+ix + " " + sum_current_hour + "/" + ref_current_hour)
			else
				bgc_ref.push(ref_color)
				bgc.push(color(color_id("blue", "red", sum_current_hour, ref_current_hour)))
				data.push(hours[ix])
				data_ref.push(ref_current_hour)
				labels.push("h" + ix)
				bgc_ref.push("warm0")
				bgc.push("warm0")
				data.push(refHours[ix] - sum_current_hour)
				data_ref.push(refHours[ix] - ref_current_hour)
				labels.push("h" + ix + " " + hours[ix] + "/" + refHours[ix])

	const doughnut_data =
		labels: labels
		datasets: [
			{
				circumference: 360
				rotation: 180
				label: 'Current data'
				data: data
				backgroundColor: bgc
				hoverOffset: 4
			},
			{
				circumference: 360
				rotation: 180
				label: 'Reference data'
				data: data_ref
				backgroundColor: bgc_ref
				hoverOffset: 4
			}
		]

	const config =
		type: 'doughnut'
		plugins:
			afterDraw: do(chart)
				const needleValue = chart.config.data.datasets[0].needleValue;
				const dataTotal = chart.config.data.datasets[0].data.reduce((do(a, b) a + b), 0);
				const angle = Math.PI + (1 / dataTotal * needleValue * Math.PI);
				const ctx = chart.ctx;
				const cw = chart.canvas.offsetWidth;
				const ch = chart.canvas.offsetHeight;
				const cx = cw / 2;
				const cy = ch - 6;

				ctx.translate(cx, cy);
				ctx.rotate(angle);
				ctx.beginPath();
				ctx.moveTo(0, -3);
				ctx.lineTo(ch - 20, 0);
				ctx.lineTo(0, 3);
				ctx.fillStyle = 'rgb(0, 0, 0)';
				ctx.fill();
				ctx.rotate(-angle);
				ctx.translate(-cx, -cy);
				ctx.beginPath();
				ctx.arc(cx, cy, 5, 0, Math.PI * 2);
				ctx.fill();

		data: doughnut_data
	console.log(config)
	return config

export default date_data