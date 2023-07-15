const WebSocket = require("ws");
const prompt = require('prompt-sync')();

// send shutdown to maximinus test med server som parameter  
console.log(process.argv)
const server = prompt('Confirm server to shut down?');
if (process.argv[2] != server) {
    throw new Error(`parameter ${process.argv[2]} not equal ${server}!`);
}
console.log(server)

let connectionOpen = false
wsaddress = "wss://maximinus-test.gcloud.api.no "
const wss = new WebSocket(wsaddress);
wss.on("open", () => {
    console.log("connection open " + wsaddress)
    connectionOpen = true;
});
wss.on("message", (msgin) => {
    console.log("From server ----------", msgin.substring(0, 2000))
})
wss.on("close", () => {
    console.error("connection closed");
    connectionOpen = false;
});
wss.on("error", (err) => {
    console.error("ws error");
    console.error(err);
    connectionOpen = false;
    exit
});

function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
}


console.log("WS sucessfullyy established, wait for open");
let ct = 0
delay(1000).then(() => {
    if (connectionOpen) {

        const shutdownmsg = {
            message_data: {
                id: "abc",
                type: "pyasera.shutdown",
                "request_data": {
                }
            },
            identity_data: {
                server: server
            },
            payload: {}
        }

        wss.send(JSON.stringify(shutdownmsg))
    }
})
