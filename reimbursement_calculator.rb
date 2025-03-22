#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/project'
require_relative 'lib/reimbursement_calculator'

def run_scenario(name, projects)
  puts "===== Scenario: #{name} ====="
  projects.each do |project|
    puts "Project #{project[:number]}: #{project[:city_type]} Cost City, #{project[:start_date]} to #{project[:end_date]}"
  end

  calculator = ReimbursementCalculator.new(
    projects.map { |p| Project.new(p[:start_date], p[:end_date], p[:city_type]) }
  )

  total = calculator.calculate
  puts "Total Reimbursement: $#{total}\n\n"
  total
end

TEST_SCENARIOS = {
  set_1: [
    { number: 1, city_type: 'low', start_date: '10/1/24', end_date: '10/4/24' }
  ],

  set_2: [
    { number: 1, city_type: 'low', start_date: '10/1/24', end_date: '10/1/24' },
    { number: 2, city_type: 'high', start_date: '10/2/24', end_date: '10/6/24' },
    { number: 3, city_type: 'low', start_date: '10/6/24', end_date: '10/9/24' }
  ],

  set_3: [
    { number: 1, city_type: 'low', start_date: '9/30/24', end_date: '10/3/24' },
    { number: 2, city_type: 'high', start_date: '10/5/24', end_date: '10/7/24' },
    { number: 3, city_type: 'high', start_date: '10/8/24', end_date: '10/8/24' }
  ],

  set_4: [
    { number: 1, city_type: 'low', start_date: '10/1/24', end_date: '10/1/24' },
    { number: 2, city_type: 'low', start_date: '10/1/24', end_date: '10/1/24' },
    { number: 3, city_type: 'high', start_date: '10/2/24', end_date: '10/3/24' },
    { number: 4, city_type: 'high', start_date: '10/2/24', end_date: '10/6/24' }
  ]
}.freeze

puts "Project Reimbursement Calculator\n\n"

results = {
  set_1: run_scenario(:set_1, TEST_SCENARIOS[:set_1]),
  set_2: run_scenario(:set_2, TEST_SCENARIOS[:set_2]),
  set_3: run_scenario(:set_3, TEST_SCENARIOS[:set_3]),
  set_4: run_scenario(:set_4, TEST_SCENARIOS[:set_4])
}

puts 'All scenarios completed.'
