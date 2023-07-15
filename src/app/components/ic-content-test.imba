 
import {state} from "../controls/index.imba"
import * as actions from "../controls/actions.imba"


tag ic-content-test
	prop testid = "5-95-1085593"
	prop histdate
	css .signin-window zi:10 c:white pos:absolute t:50% l:50% x:-50% y:-50% bgc:black/70 p:30px rd:10px

	def subscribe
		actions.content_test_subscribe({testid, histdate})

	<self>
		<global
			@click.outside=(actions.flip_state("content_test"))
		>
		console.log("content-test", window.location.href)
		<div.signin-window>
			<header> "Subscribe to content"
			<section>
				<form @submit.prevent.throttle(1000)=subscribe>
					<div> <input bind=testid>
					<div> <input bind=histdate>
					<button type="submit"> "Subscribe to content"
