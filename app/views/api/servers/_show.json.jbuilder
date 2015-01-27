json.id server.id.to_s
json.name server.name
json.hostname server.hostname
json.ip server.ip
json.memory server.memory
json.cpu server.cpu
json.active server.active

json.applications server.applications, partial: 'api/applications/show', as: :application
