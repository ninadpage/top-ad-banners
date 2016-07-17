# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# require 'csv'

case Rails.env
  when 'test'
    # Seed data for test environment
    # Normally, sample data for tests is defined under test/fixtures. It's added afresh every time a test suite is
    # executed.
    # Add code to generate any additional seed data if it's required to be added when the test environment is created.
    # This data will stay remain in the database.

  when 'development'
    # Seed data for development environment

    # The Ruby code commented out below is painfully slow for our seed data, because it uses a different transaction
    # for each row, and we're inserting hundreds of thousands of them!
    # With sqlite, it's not straight-forward to execute import csv command directly either,
    # not least because created_at & updated_at columns do not exist in the CSV.

    # So we are, regrettably, doing it the dirty way: compile all rows in memory and batch-insert them
    # in a single transaction, using raw SQL. We can only afford this because we know the seed data is clean.
    # This takes seconds vs an hour, though.
    inserts = []
    tstamp = Time.new.strftime('%Y-%m-%d %H:%M:%S.%6L')
    File.readlines('db/migrate/seed_data/development/impressions.csv').drop(1).each do |line|
      inserts.push("(#{line.strip},'#{tstamp}','#{tstamp}')")
    end
    Impression.connection.execute "INSERT INTO impressions (`banner_id`, `campaign_id`, `created_at`, `updated_at`)
VALUES #{inserts.join(', ')}"

    inserts = []
    tstamp = Time.new.strftime('%Y-%m-%d %H:%M:%S.%6L')
    File.readlines('db/migrate/seed_data/development/clicks.csv').drop(1).each do |line|
      inserts.push("(#{line.strip},'#{tstamp}','#{tstamp}')")
    end
    Impression.connection.execute "INSERT INTO clicks (`id`, `banner_id`, `campaign_id`, `created_at`, `updated_at`)
VALUES #{inserts.join(', ')}"

    inserts = []
    tstamp = Time.new.strftime('%Y-%m-%d %H:%M:%S.%6L')
    File.readlines('db/migrate/seed_data/development/conversions.csv').drop(1).each do |line|
      inserts.push("(#{line.strip},'#{tstamp}','#{tstamp}')")
    end
    Impression.connection.execute "INSERT INTO conversions (`id`, `click_id`, `revenue`, `created_at`, `updated_at`)
VALUES #{inserts.join(', ')}"

    # CSV.foreach('db/migrate/seed_data/development/impressions.csv', {headers: true}) do |row|
    #   # row is of type CSV::Row.
    #   # to_a converts it to an array of elements, where each element is another array [header, value].
    #   banner_id, campaign_id = row.to_a.map {|el| el[1]}
    #   Impression.create   banner_id: banner_id,
    #                       campaign_id: campaign_id
    # end
    #
    # CSV.foreach('db/migrate/seed_data/development/clicks.csv', {headers: true}) do |row|
    #   click_id, banner_id, campaign_id = row.to_a.map {|el| el[1]}
    #   Click.create  id: click_id,
    #                 banner_id: banner_id,
    #                 campaign_id: campaign_id
    # end
    #
    # CSV.foreach('db/migrate/seed_data/development/conversions.csv', {headers: true}) do |row|
    #   conversion_id, click_id, revenue = row.to_a.map {|el| el[1]}
    #   Conversion.create   id: conversion_id,
    #                       click: Click.find(click_id),
    #                       revenue: revenue
    # end

  when 'production'
    # Seed data for production environment
    # Add code to generate any seed data if it's required to be added when the production environment is created.

  else
    # Do nothing
end

# Add code to generate any seed data if it's required to be added in ALL environments.