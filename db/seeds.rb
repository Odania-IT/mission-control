# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Server.find_or_create_by!(name: 'lvh.me', hostname: 'lvh.me', ip: '127.0.0.1', memory: 8192, cpu: 4, active: true)

application = Application.find_or_create_by!(name: 'lvh.me', domains: ['lvh.me'])

Image.find_or_create_by!(name: 'mysql', image_type: :db, image: 'mysql:latest', volumes: [], ports: [], links: [], environment: [], application: application)
Image.find_or_create_by!(name: 'phpmyadmin', image_type: :web, image: 'odaniait/phpmyadmin-docker:latest', volumes: [], ports: ['127.0.0.1:8081:80'],
														links: ['mysql'], environment: %w(MYSQL_DATABASE=discreteer MYSQL_ROOT_PASSWORD=alligator3), application: application)
