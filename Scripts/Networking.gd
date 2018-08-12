extends Node

const urlBase = "http://ludumdare.nikitech.eu"
const listUrl = "/list_scores.php"
const postUrl = "/upload_score.php"

var thread = Thread.new()

signal load_complete

func list_scores_async():
	if thread.is_active():
		return
	thread.start(self, "list_scores")
	
func list_scores(required_parameter_for_thread):
	return request(HTTPClient.METHOD_GET, listUrl, null)

func post_score(nickname, score):
	var payload = "nickname=" + str(nickname) + "&score=" + str(score)
	return request(HTTPClient.METHOD_POST, postUrl, payload)

func request(method, url, payload):
	var err = 0

	var http = HTTPClient.new()

	http.connect_to_host(urlBase, 80)
	assert(err == OK) # Make sure connection was OK

	# Wait until resolved and connected
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		print("Connecting..")
		OS.delay_msec(500)

	# Some headers
	var headers = [
		"User-Agent: Pirulo/1.0 (Godot)",
		"Accept: */*"
	]

	if payload != null:
		headers.append("Content-Type: application/x-www-form-urlencoded")
		err = http.request(method, url, headers, payload)
	else:
		err = http.request(method, url, headers)

	#assert(err == OK) # Make sure all is OK

	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		# Keep polling until the request is going on
		http.poll()
		print("Requesting..")
		OS.delay_msec(500)

	#assert(http.get_status() == HTTPClient.STATUS_BODY
	#or http.get_status() == HTTPClient.STATUS_CONNECTED) # Make sure request finished well.

	# Array that will hold the data
	var rb = PoolByteArray()

	while http.get_status() == HTTPClient.STATUS_BODY:
		# While there is body left to be read
		http.poll()
		var chunk = http.read_response_body_chunk() # Get a chunk
		if chunk.size() == 0:
			# Got nothing, wait for buffers to fill a bit
			OS.delay_usec(1000)
		else:
			rb = rb + chunk # Append to read buffer

	var text = rb.get_string_from_ascii()
	print("Response: " + str(text))
	var json = JSON.parse(text).result
	http.close()
	
	emit_signal("load_complete", json)
	
	return json


















