json.id application.id.to_s
json.name application.name
json.domains application.domains
json.ports application.ports
json.basic_auth application.basic_auth
json.is_global application.is_global

json.images application.images, partial: 'api/images/show', as: :image
