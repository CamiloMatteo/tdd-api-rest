module RequestSpecHelper
	# parse json response
	def json
		JSON.parse(response.body)
	end
end
