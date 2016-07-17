# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

case Rails.env
  when 'test'
    # Seed data for test environment
    # Normally, sample data for tests is defined under test/fixtures. It's added afresh every time a test suite is
    # executed.
    # Add code to generate any additional seed data if it's required to be added when the test environment is created.
    # This data will stay remain in the database.

  when 'development'
    # Seed data for development environment

    CSV.foreach('db/migrate/seed_data/development/impressions.csv', {headers: true}) do |row|
      # row is of type CSV::Row.
      # to_a converts it to an array of elements, where each element is another array [header, value].
      banner_id, campaign_id = row.to_a.map {|el| el[1]}
      Impression.create   banner_id: banner_id,
                          campaign_id: campaign_id
    end

    CSV.foreach('db/migrate/seed_data/development/clicks.csv', {headers: true}) do |row|
      click_id, banner_id, campaign_id = row.to_a.map {|el| el[1]}
      Click.create  id: click_id,
                    banner_id: banner_id,
                    campaign_id: campaign_id
    end

    CSV.foreach('db/migrate/seed_data/development/conversions.csv', {headers: true}) do |row|
      conversion_id, click_id, revenue = row.to_a.map {|el| el[1]}
      Conversion.create   id: conversion_id,
                          click: Click.find(click_id),
                          revenue: revenue
    end

  when 'production'
    # Seed data for production environment
    # Add code to generate any seed data if it's required to be added when the production environment is created.

  else
    # Do nothing
end

# Add code to generate any seed data if it's required to be added in ALL environments.