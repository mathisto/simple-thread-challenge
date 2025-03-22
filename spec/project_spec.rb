# frozen_string_literal: true

require_relative '../lib/project'

RSpec.describe Project do
  describe '#initialize' do
    it 'creates a project with valid parameters' do
      project = Project.new('10/1/24', '10/4/24', 'low')
      expect(project.start_date).to eq(Date.new(2024, 10, 1))
      expect(project.end_date).to eq(Date.new(2024, 10, 4))
      expect(project.city_type).to eq(:low)
    end
  end

  describe '#days' do
    it 'returns array of all dates in the project range' do
      project = Project.new('10/1/24', '10/4/24', 'low')
      expected_days = [
        Date.new(2024, 10, 1),
        Date.new(2024, 10, 2),
        Date.new(2024, 10, 3),
        Date.new(2024, 10, 4)
      ]
      expect(project.days).to eq(expected_days)
    end

    it 'returns single date for single-day project' do
      project = Project.new('10/1/24', '10/1/24', 'low')
      expect(project.days).to eq([Date.new(2024, 10, 1)])
    end
  end

  describe '#high_cost?' do
    it 'returns true for high cost city' do
      project = Project.new('10/1/24', '10/4/24', 'high')
      expect(project.high_cost?).to be true
    end

    it 'returns false for low cost city' do
      project = Project.new('10/1/24', '10/4/24', 'low')
      expect(project.high_cost?).to be false
    end
  end
end 