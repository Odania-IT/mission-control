json.id server.id.to_s
json.name server.name
json.hostname server.hostname
json.ip server.ip
json.memory server.memory
json.cpu server.cpu
json.active server.active
json.os server.os
json.container_count server.container_count
json.running_container_count server.running_container_count
json.image_count server.image_count
json.basic_auth server.basic_auth
json.volumes_path server.volumes_path
json.proxy_type server.proxy_type

json.applications server.applications, partial: 'api/applications/show', as: :application
json.containers server.containers, partial: 'api/containers/show', as: :container
