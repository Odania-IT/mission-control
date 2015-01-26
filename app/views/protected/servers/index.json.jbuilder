json.array!(@servers) do |server|
	json.extract! server, :id, :name, :hostname, :ip, :memory, :cpu, :active
	json.url server_url(server, format: :json)
end
