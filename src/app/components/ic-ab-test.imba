 
import {state} from "../controls/index.imba"
import * as actions from "../controls/actions.imba"


tag ic-ab-test
	prop sitekey = "nettav"
	prop testid = "7c0e542d1a"
	prop histdate
	css .signin-window zi:10 c:white pos:absolute t:50% l:50% x:-50% y:-50% bgc:black/70 p:30px rd:10px

	def subscribe
		actions.ab_test_subscribe({sitekey, testid, histdate})

	<self>
		<global
			@click.outside=(actions.flip_state("ab_test"))
		>
		console.log("ab-test", window.location.href)
		<div.signin-window>
			<header> "Subscribe to test"
			<section>
				<form @submit.prevent.throttle(1000)=subscribe>
					<div> <input bind=sitekey>
					<div> <input bind=testid>
					<div> <input bind=histdate>
					<button type="submit"> "Subscribe"
