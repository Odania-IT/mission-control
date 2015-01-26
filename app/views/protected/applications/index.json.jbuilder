json.array!(@applications) do |application|
	json.extract! application, :id, :name, :domains
	json.url application_url(application, format: :json)
end
