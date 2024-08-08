import { Socket } from "phoenix";

const WEBSOCKET_URL = 'ws://127.0.0.1:4080/socket';
const socket = new Socket(WEBSOCKET_URL, { params: { token: "TokenHere" }});
socket.connect();

export default socket;
