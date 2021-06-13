const http = require('http');
const express = require('express');
const request = require('request');
const db = require('./database.js')
const emitter = require('./commonEmitter.js');
const formatter = require('./formatter.js');

const app = express();
app.use(express.json());
app.use(express.urlencoded());

const PORT = 8080;
app.use(express.static("."));

app.post('/NavigationInstructions', function(req, res) {
	console.log("Navigation Instructions - Retrieval Request...")
	var beaconName = req.body.beaconNodeScannedName;
	var destination = req.body.destination;
	emitter.once('navigationInstructionsRetrieved', function (snapshot){
		if (snapshot.val() == undefined) {
			console.log("Entry does not exist...");
		}
		// var json = formatter.formatJSON(snapshot);
		res.send(snapshot.val());
		console.log("Request Completed....\n\n");
	});
	db.getNavigationInstructions(destination);
});

app.post('/DestinationList', function(req, res) {
	console.log('Destination List - Retrieval Requested...');
	emitter.once('destinationListRetrieved', function (snapshot){
		if(snapshot.val() == undefined){
			console.log('Error retrieving list...');
			res.send("Error retrieving list...");
		} else {
			var arr = formatter.removeChildrenFromJSON(snapshot);
			var json = JSON.stringify(arr)
			res.send(json);
		}
		console.log("Request Completed....\n\n");
	});
	db.getDestinationList();
});

//UploadCustomMap
app.post('/UploadCustomMap', function(req, res) {
	console.log('Upload Custom Map - Requested...');
	var snapshot = req.body;
	var uid = snapshot.uid;
	var destination = snapshot.destination;
	delete snapshot.uid;

	emitter.once("uploadCustomMapCompleted", function(bool){
		if (bool) {
			res.send("Upload Succeeded!");
		} else {
			res.send("Upload Failed!");
		}
		console.log("Request Completed...\n\n");
	});
	db.uploadCustomMap(uid, destination, snapshot);
});

//Request Map NAmes
app.post('/DownloadCustomMapNames', function(req, res) {
	console.log('Download Custom Map Names - Requested...');
	var snapshot = req.body;
	var uid = snapshot.uid;

	emitter.once("downloadCustomMapNamesRetrieved", function(snapshot){
		if(snapshot.val() == undefined){
			console.log('Error retrieving list...');
			res.send("Error retrieving list...");
		} else {
			//console.log(snapshot.val());
			var arr = formatter.removeChildrenFromJSON(snapshot);
			var json = JSON.stringify(arr)
			res.send(json);
		}
		console.log("Request Completed....\n\n");
	});
	db.getCustomMapNames(uid);
});

//Download Custom Map
app.post('/DownloadCustomMap', function(req, res) {
	console.log('Download Custom Map - Requested...');
	var snapshot = req.body;
	var mapName = snapshot.map_name;
	var uid = snapshot.uid;

	emitter.once("customMapRetrieved", function(snapshot){
		if (snapshot.val() == undefined) {
			console.log("Entry does not exist...");
		}
		// var json = formatter.formatJSON(snapshot);
		res.send(snapshot.val());
		console.log("Request Completed....\n\n");
	});
	db.getCustomMap(uid, mapName);
});


app.listen(PORT, function(){
	console.log('Server Running on PORT:%s...\n', String(PORT));
});
