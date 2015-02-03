json.id container.id.to_s
json.server_id container.server_id.to_s
json.application_name container.application.name
json.image_name container.image.name
json.status container.status
json.current_instances container.current_instances
json.wanted_instances container.wanted_instances
json.scalable container.scalable
