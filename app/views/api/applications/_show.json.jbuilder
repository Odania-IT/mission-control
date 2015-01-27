json.id application.id.to_s
json.name application.name
json.domains application.domains

json.images application.images, partial: 'api/images/show', as: :image
