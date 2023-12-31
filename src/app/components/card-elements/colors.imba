import { defaults } from 'chart.js'

const colors = {
	pink: [
		'hsl(327,73%,97%)'
		'hsl(326,78%,95%)'
		'hsl(326,85%,90%)'
		'hsl(327,87%,82%)'
		'hsl(329,86%,70%)'
		'hsl(330,81%,60%)'
		'hsl(333,71%,51%)'
		'hsl(335,78%,42%)'
		'hsl(336,74%,35%)'
		'hsl(336,69%,30%)'
	],
	purple: [
		'hsl(270,100%,98%)'
		'hsl(269,100%,95%)'
		'hsl(269,100%,92%)'
		'hsl(269,97%,85%)'
		'hsl(270,95%,75%)'
		'hsl(271,91%,65%)'
		'hsl(271,81%,56%)'
		'hsl(272,72%,47%)'
		'hsl(273,67%,39%)'
		'hsl(274,66%,32%)'
	],
	red: [
		'hsl(0,86%,97%)'
		'hsl(0,93%,94%)'
		'hsl(0,96%,89%)'
		'hsl(0,94%,82%)'
		'hsl(0,91%,71%)'
		'hsl(0,84%,60%)'
		'hsl(0,72%,51%)'
		'hsl(0,74%,42%)'
		'hsl(0,70%,35%)'
		'hsl(0,63%,31%)'
	],
	blue: [
		'hsl(214,100%,97%)'
		'hsl(214,95%,93%)'
		'hsl(213,97%,87%)'
		'hsl(212,96%,78%)'
		'hsl(213,94%,68%)'
		'hsl(217,91%,60%)'
		'hsl(221,83%,53%)'
		'hsl(224,76%,48%)'
		'hsl(226,71%,40%)'
		'hsl(224,64%,33%)'
	],
	yellow: [
		'hsl(55,92%,95%)'
		'hsl(55,97%,88%)'
		'hsl(53,98%,77%)'
		'hsl(50,98%,64%)'
		'hsl(48,96%,53%)'
		'hsl(45,93%,47%)'
		'hsl(41,96%,40%)'
		'hsl(35,92%,33%)'
		'hsl(32,81%,29%)'
		'hsl(28,73%,26%)'
	],
	green: [
		'hsl(138,76%,97%)'
		'hsl(141,84%,93%)'
		'hsl(141,79%,85%)'
		'hsl(142,77%,73%)'
		'hsl(142,69%,58%)'
		'hsl(142,71%,45%)'
		'hsl(142,76%,36%)'
		'hsl(142,72%,29%)'
		'hsl(143,64%,24%)'
		'hsl(144,61%,20%)'
	],
	emerald: [
		'hsl(152,81%,96%)'
		'hsl(149,80%,90%)'
		'hsl(152,76%,80%)'
		'hsl(156,72%,67%)'
		'hsl(158,64%,52%)'
		'hsl(160,84%,39%)'
		'hsl(161,94%,30%)'
		'hsl(163,94%,24%)'
		'hsl(163,88%,20%)'
		'hsl(164,86%,16%)'
	],
	cyan: [
		'hsl(183,100%,96%)'
		'hsl(185,96%,90%)'
		'hsl(186,94%,82%)'
		'hsl(187,92%,69%)'
		'hsl(188,86%,53%)'
		'hsl(189,94%,43%)'
		'hsl(192,91%,36%)'
		'hsl(193,82%,31%)'
		'hsl(194,70%,27%)'
		'hsl(196,64%,24%)'
	],
	indigo: [
		'hsl(226,100%,97%)'
		'hsl(226,100%,94%)'
		'hsl(228,96%,89%)'
		'hsl(230,94%,82%)'
		'hsl(234,89%,74%)'
		'hsl(239,84%,67%)'
		'hsl(243,75%,59%)'
		'hsl(245,58%,51%)'
		'hsl(244,55%,41%)'
		'hsl(242,47%,34%)'
	],
	fuchsia: [
		'hsl(289,100%,98%)'
		'hsl(287,100%,95%)'
		'hsl(288,96%,91%)'
		'hsl(291,93%,83%)'
		'hsl(292,91%,73%)'
		'hsl(292,84%,61%)'
		'hsl(293,69%,49%)'
		'hsl(295,72%,40%)'
		'hsl(295,70%,33%)'
		'hsl(297,64%,28%)'
	],
	warm: [
		'hsl(0,0%,98%)'
		'hsl(0,0%,96%)'
		'hsl(0,0%,90%)'
		'hsl(0,0%,83%)'
		'hsl(0,0%,64%)'
		'hsl(0,0%,45%)'
		'hsl(0,0%,32%)'
		'hsl(0,0%,25%)'
		'hsl(0,0%,15%)'
		'hsl(0,0%,9%)'
	],
	sky: [
		'hsl(204,100%,97%)'
		'hsl(204,94%,94%)'
		'hsl(201,94%,86%)'
		'hsl(199,95%,74%)'
		'hsl(198,93%,60%)'
		'hsl(199,89%,48%)'
		'hsl(200,98%,39%)'
		'hsl(201,96%,32%)'
		'hsl(201,90%,27%)'
		'hsl(202,80%,24%)'
	]
}


export def color(clr)
	const col = clr.substring(0, clr.length - 1)
	const i = clr.substring(clr.length - 1)

	if colors[col] and i >= 0 and i <= 9
		return colors[col][i]
	else 
		console.log("invalid color", clr, col, i)
		return 'rgb(255, 255, 255)'

export default color