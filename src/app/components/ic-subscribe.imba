 
import {state} from "../controls/index.imba"
import * as actions from "../controls/actions.imba"


tag ic-subscribe
	prop source = "maximinus"
	prop group = ""
	css .subscribe-window zi:10 c:white pos:absolute t:50% l:50% x:-50% y:-50% bgc:black/70 p:30px rd:10px

	def subscribe
		actions.subscribe({source, group})

	<self>
		<global
			@click.outside=(actions.resetSubscribe())
		>
		console.log("subscrbie", window.location.href)
		<div.suubscribe-window>
			<header> "Subscribe to content"
			<section>
				<form @submit.prevent.throttle(1000)=subscribe>
					<div> "source" <input bind=source>
					<div> "id" <input bind=group>
					<button type="submit"> "Subscribe"
