json.id image.id.to_s
json.image_type image.image_type
json.name image.name
json.image image.image
json.volumes image.volumes
json.ports image.ports
json.links image.links
json.environment image.environment
json.scalable image.scalable
json.is_global image.is_global
json.template_id image.template_id.nil? ? nil : image.template_id.to_s
json.template_environment image.template_environment
