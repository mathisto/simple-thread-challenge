# frozen_string_literal: true

require_relative '../lib/project'
require_relative '../lib/reimbursement_calculator'

RSpec.describe ReimbursementCalculator do
  describe '#calculate' do
    context 'with empty projects' do
      it 'returns 0' do
        calculator = ReimbursementCalculator.new([])
        expect(calculator.calculate).to eq(0)
      end
    end

    context 'with single project' do
      it 'calculates correctly for low cost city' do
        project = Project.new('10/1/24', '10/4/24', 'low')
        calculator = ReimbursementCalculator.new([project])
        # First and last days are travel ($45 each)
        # Two middle days are full ($75 each)
        # Total: (2 * 45) + (2 * 75) = 240
        expect(calculator.calculate).to eq(240)
      end

      it 'calculates correctly for high cost city' do
        project = Project.new('10/1/24', '10/4/24', 'high')
        calculator = ReimbursementCalculator.new([project])
        # First and last days are travel ($55 each)
        # Two middle days are full ($85 each)
        # Total: (2 * 55) + (2 * 85) = 280
        expect(calculator.calculate).to eq(280)
      end

      it 'handles single-day project as travel day' do
        project = Project.new('10/1/24', '10/1/24', 'low')
        calculator = ReimbursementCalculator.new([project])
        # Single day is travel day ($45)
        expect(calculator.calculate).to eq(45)
      end
    end

    context 'with multiple projects' do
      it 'handles contiguous projects with same city type' do
        projects = [
          Project.new('10/1/24', '10/2/24', 'low'),
          Project.new('10/3/24', '10/4/24', 'low')
        ]
        calculator = ReimbursementCalculator.new(projects)
        # First and last days are travel ($45 each)
        # Two middle days are full ($75 each)
        # Total: (2 * 45) + (2 * 75) = 240
        expect(calculator.calculate).to eq(240)
      end

      it 'handles projects with gaps' do
        projects = [
          Project.new('10/1/24', '10/2/24', 'low'),
          Project.new('10/4/24', '10/5/24', 'low')
        ]
        calculator = ReimbursementCalculator.new(projects)
        # All days are travel days due to gap ($45 each)
        # Total: 4 * 45 = 180
        expect(calculator.calculate).to eq(180)
      end

      it 'uses high cost rate when day appears in both city types' do
        projects = [
          Project.new('10/1/24', '10/2/24', 'low'),
          Project.new('10/2/24', '10/3/24', 'high')
        ]
        calculator = ReimbursementCalculator.new(projects)
        # First day is travel low ($45)
        # Middle day is full high ($85) due to precedence
        # Last day is travel high ($55)
        # Total: 45 + 85 + 55 = 185
        expect(calculator.calculate).to eq(185)
      end

      it 'handles overlapping projects' do
        projects = [
          Project.new('10/1/24', '10/4/24', 'low'),
          Project.new('10/2/24', '10/3/24', 'high')
        ]
        calculator = ReimbursementCalculator.new(projects)
        # First day is travel low ($45)
        # Middle days are full high ($85 each) due to precedence
        # Last day is travel low ($45)
        # Total: 45 + (2 * 85) + 45 = 260
        expect(calculator.calculate).to eq(260)
      end
    end
  end
end 