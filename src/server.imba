import { publicEncrypt } from "node:crypto";
const WebSocket = require("ws");

import { dirname } from 'path/posix'
import express from 'express'
import path from 'path'
import index from './app/index.html'
import fs from "fs";
import {get_type, get_original_type, msg_ok, is_ack} from "./app/controls/helpers.imba"


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
let n_errors = 0
let n_identify_errors = 0
let n_pings = 0
let app_in_error = false
let msg_waiting = []

console.log("env?")
console.dir(process.env)

def send_msgs(msg)
	if not connectionOpen and msg
		msg_waiting.push(msg)
		return
	if msg_waiting.length > 0
		for m in msg_waiting
			console.dir(m)
			wss.send(JSON.stringify(m))
		msg_waiting = []
	if msg
		console.dir(msg)
		wss.send(JSON.stringify(msg))

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
			stream_id: "yoyth_connect"
	identity_data:
		identity: process.env.YOYTHCONNECTID
	payload:
		yoyth_login_identity: process.env.YOYTHCONNECTID,
		yoyth_login_name: process.env.YOYTHAPP,
		yoyth_secret: encrypt_secret(process.env.YOYTHIDSPUBLICKEY, process.env.YOYTHSECRET),
		yoyth_ids_public_key: process.env.YOYTHSECRET

const pingmessage =
	message_data:
		type: 'ping'
		creator: "yoyth_connect"
		request_data:
			stream_id: "yoyth_connect"
		original:
			type: 'ping'			
	identity_data:
		identity: process.env.YOYTHCONNECTID
	payload: {}

const vippsquery =
	message_data:
		type: 'vipps_access_request'
		creator: "yoyth_connect"
		request_data:
			stream_id: "web_server"
	identity_data:
		identity: process.env.YOYTHCONNECTID
		from_identity: process.env.YOYTHCONNECTID
		to_identity: process.env.YOYTHIDSIDENTITY
	payload:
		query: {}

console.dir(openmessage)

def initiate_connection
	console.log(process.env.YOYTHWSADDRESS);
	wss = new WebSocket(
		process.env.YOYTHWSADDRESS
	);
	wss.on("open", do 
		connectionOpen = true;
		console.log("open")
		send_msgs(undefined))
	wss.on("message", do |msgin|
		console.log(msgin)
		const smsg = JSON.parse(msgin);
		console.log(smsg)
		n_errors = 0
		if smsg.connection_id
			if connection_id and not smsg.reidentify
				console.log("send back")
				send_msgs({
					connection_id: smsg.connection_id,
					reconnect_id: connection_id,
					identity: process.env.YOYTHCONNECTID
				})
				return;
			if smsg.reconnected
				console.log("reconnected")
				connected = true
				return
			send_msgs(openmessage)
		if smsg.message_data
			// can be ack on login or ping
			if is_ack(smsg)
				if get_original_type(smsg) === get_type(openmessage)
					if msg_ok(smsg)
						connected = true
						n_identify_errors = 0
						console.log("connect to identity server ok")
					else
						console.error("connect to identity server failed")
						n_identify_errors += 1
						connected = false
				elif get_original_type(smsg) === get_type(pingmessage)
					n_pings -= 1
					console.log("ping ok")
			else
				console.log("what msg?")
				console.dir(smsg)

	)
	wss.on("close", do |reason|
		console.error("close")
		console.dir(reason)
		n_errors += 1
		connected = false
		connectionOpen = false;
		wait_a_second_and_retry()
	)
	wss.on("error", do |error|
		n_errors += 1
		console.log("error")
		console.dir(error)
		connected = false
		connectionOpen = false;
		wait_a_second_and_retry()
	)

def wait_a_second_and_retry 
	setTimeout(&,1000) do
		console.log('waited! errors=' + n_errors)  
		if n_errors > 10
			console.log("restart server")
			app_in_error = true
			process.exit(12)
			process.abort
		console.log("try to establish connection")
		initiate_connection()

def ping 
	n_pings += 1
	send_msgs(pingmessage)
	setTimeout(&,15000) do
		console.log('Send ping if outstanding pings < 3: ' + n_pings)
		if n_pings >= 3
			console.log("restart server")
			process.exit(12)
			return
		ping()

initiate_connection()
ping()

# Express works like usual, so we can allow JSON in the POST request:
const jsonBody = express.json({ limit: '1kb' })

app.use('/v1/', express.static(path.join(__dirname,'../dist/public')))
app.use('/', express.static(path.join(__dirname,'../dist/public')))
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
app.post('/justtesting') do(req,res)
	console.dir(req)
	console.dir("body")
	console.dir(req.body)
	res.send({
		body: req.body
	})


app.get('/count') do(req,res)
	res.send({
		count: state.count
	})

app.get('/yoythconfig') do(req,res)
	console.log("addr", process.env.YOYTHWSADDRESS)
	res.send({
		YOYTHWSADDRESS: process.env.YOYTHWSADDRESS,
		VIPPSAPI: process.env.YOYTHVIPPSAPI,
		VIPPSCLIENT: process.env.YOYTHVIPPSCLIENT,
		VIPPSREDIRECT: process.env.YOYTHVIPPSREDIRECT,
		YOYTHANONYMID: process.env.YOYTHANONYMID,
		YOYTHBANKIDENTITY: process.env.YOYTHBANKIDENTITY,
		YOYTHUSERSERVERIDENTITY: process.env.YOYTHUSERSERVERIDENTITY,
		YOYTHAPP: process.env.YOYTHAPP,
		TESTUSER: process.env.TESTUSER

	})

app.get('/yoythvippsrequest') do(req,res)
	console.log("vippsrequest")
	console.dir(req.body)
	console.dir(req.query)
	res.send()
	vippsquery.payload.query = req.query
	send_msgs(vippsquery)			

	# lag msg og send til ids-server

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
