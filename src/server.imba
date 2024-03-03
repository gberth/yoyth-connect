import { publicEncrypt } from "node:crypto";
const WebSocket = require("ws");

import { dirname } from 'path/posix'
import express from 'express'
import path from 'path'
import index from './app/index.html'
import fs from "fs";


# A simple state that exists until the server stops
const state = {
	count: 0,
}

# Using Imba with Express as the server is quick to set up:
const app = express()
const port = process.env.PORT or 3000
let wss
let connectionOpen = false
let connected = false
let connection_id

def encrypt_secret(key, secret)
	let usekey
	if not (key.startsWith("---") or key.startsWith("ssh"))
		usekey = fs.readFileSync(process.env[key] || key).toString("utf-8");
	else
		usekey = key
	return publicEncrypt(
		usekey,
		Buffer.from(secret, "utf-8")
		);

const openmessage =
	message_data:
		type: 'server_login'
		creator: "yoyth_connect"
		request_data:
			stream_id: "web_server"
	identity_data:
		identity: process.env.YOYTHCONNECTID
	payload:
		yoyth_login_identity: process.env.YOYTHCONNECTID,
		yoyth_login_name: process.env.YOYTHSERVERNAME,
		yoyth_secret: encrypt_secret(process.env.YOYTHIDSPUBLICKEY, process.env.YOYTHSECRET),
		yoyth_ids_public_key: process.env.YOYTHSECRET

console.dir(openmessage)

def initiate_connection
	console.log(process.env.YOYTHWSADDRESS);
	wss = new WebSocket(
		process.env.YOYTHWSADDRESS
	);
	wss.on("open", do 
		connectionOpen = true;
		console.log("open"))
	wss.on("message", do |msgin|
		let msg;
		console.log(msgin)
		const smsg = JSON.parse(msgin);
		console.log(smsg)
		if smsg.connection_id
			if connection_id and not smsg.reidentify
				console.log("send back")
				wss.send(JSON.stringify({
					connection_id: smsg.connection_id,
					reconnect_id: connection_id,
					identity: process.env.YOYTHCONNECTID
				}))
				return;
			if smsg.reconnected
				console.log("reconnected")
				connected = true
				return
			wss.send(JSON.stringify(openmessage))			
	)
	wss.on("close", do |reason|
		let msg;
		console.log("close")
	)
	wss.on("error", do |error|
		let msg;
		console.log("error")
		console.dir(error)
	)


initiate_connection()

# Express works like usual, so we can allow JSON in the POST request:
const jsonBody = express.json({ limit: '1kb' })

app.use('/v1/', express.static(path.join(__dirname,'../dist/public')))
app.use('/vipps/', express.static(path.join(__dirname,'../dist/public')))
app.use('/yoyth/', express.static(path.join(__dirname,'../dist/public')))

app.post('/increment', jsonBody) do(req,res)
	# A good exercise here is to add validation for the request body.
	# For example, what would happen if you send a string instead of a number?
	state.count += req.body.increment

	# Sending the state back to the client lets us update it right away:
	res.send({
		count: state.count
	})

app.get('/count') do(req,res)
	res.send({
		count: state.count
	})

app.get('/yoythconfig') do(req,res)
	console.log("addr", process.env.YOYTHWSADDRESS)
	res.send({
		wsaddress: process.env.YOYTHWSADDRESS
	})

app.get('/yoyth-connect/apiadmin/ping') do(req,res)
	res.send({
		ping: "OK"
	})
# catch-all route that returns our index.html
app.get(/.*/) do(req,res)
	# only render the html for requests that prefer an html response
	unless req.accepts(['image/*', 'html']) == 'html'
		return res.sendStatus(404)

	res.send(index.body)

# Express is set up and ready to go!
imba.serve(app.listen(port))
