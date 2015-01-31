# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Server.find_or_create_by!(name: 'lvh.me', hostname: 'lvh.me', ip: '127.0.0.1', memory: 8192, cpu: 4, active: true)

application = Application.find_or_create_by!(name: 'lvh.me', domains: ['lvh.me'])

Image.find_or_create_by!(name: 'mysql', image_type: 'background', image: 'mysql:latest', volumes: [], ports: [], links: [],
								 environment: %w(MYSQL_DATABASE=my_db MYSQL_ROOT_PASSWORD=my_password), application: application, scalable: false)
Image.find_or_create_by!(name: 'phpmyadmin', image_type: 'expose', image: 'odaniait/phpmyadmin-docker:latest', volumes: [], ports: ['127.0.0.1::80'],
								 links: ['mysql'], environment: [], application: application, scalable: true)
