json.array!(@images) do |image|
	json.extract! image, :id, :name, :image, :volumes, :ports, :image_type, :links, :environment
	json.url image_url(image, format: :json)
end
