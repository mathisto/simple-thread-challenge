# frozen_string_literal: true

require 'set'

class ReimbursementCalculator
  RATES = {
    travel: { low: 45, high: 55 },
    full: { low: 75, high: 85 }
  }.freeze

  def initialize(projects)
    @projects = projects
  end

  def calculate
    day_projects = collect_day_projects
    return 0 if day_projects.empty?

    dates = day_projects.keys.sort
    sequences = find_sequences(dates, day_projects)
    calculate_total_reimbursement(sequences, day_projects)
  end

  private

  def collect_day_projects
    @projects.each_with_object({}) do |project, day_projects|
      project.days.each do |date|
        day_projects[date] ||= []
        day_projects[date] << project
      end
    end
  end

  def find_sequences(dates, day_projects)
    sequences = []
    current_sequence = []

    dates.each_with_index do |date, index|
      # Look ahead to the next day's data (if any)
      next_date = dates[index + 1]
      current_projects = day_projects[date]
      next_projects = day_projects[next_date] if next_date

      # CASE 1: Starting a new sequence - either our first sequence or
      # we're starting fresh after a break in travel
      if current_sequence.empty?
        current_sequence << date
      
      # CASE 2: Projects overlap with next day - continue the sequence, ex:
      # - multiple projects spanning the same days
      # - one project ending as another begins
      # - multiple projects with different but overlapping date ranges
      elsif next_date && projects_overlap?(current_projects, next_projects)
        current_sequence << date
      
      # CASE 3: No overlap with tomorrow - end the current sequence; gap in 
      # travel or projects don't connect
      else
        current_sequence << date  
        sequences << current_sequence 
        current_sequence = []  
      end
    end

    # Sequences that were in progress when reaching the end
    sequences << current_sequence unless current_sequence.empty?
    sequences
  end

  def projects_overlap?(current_projects, next_projects)
    return false unless next_projects

    # This one was a bit tricky to get right. We need to check for projects that span 
    # both days OR projects that are contiguous
    (current_projects & next_projects).any? ||
      current_projects.any? { |p| p.end_date + 1 == next_projects.first&.start_date }
  end

  def calculate_total_reimbursement(sequences, day_projects)
    sequences.sum do |sequence|
      calculate_sequence_reimbursement(sequence, day_projects)
    end
  end

  def calculate_sequence_reimbursement(sequence, day_projects)
    return calculate_travel_day(sequence.first, day_projects) if sequence.length == 1

    sequence.each_with_index.sum do |date, index|
      calculate_daily_rate(date, index, sequence.length, day_projects)
    end
  end

  def calculate_daily_rate(date, index, sequence_length, day_projects)
    rate_type = determine_rate_type(index, sequence_length)
    city_type = determine_city_type(day_projects[date])
    RATES[rate_type][city_type]
  end

  def calculate_travel_day(date, day_projects)
    RATES[:travel][determine_city_type(day_projects[date])]
  end

  def determine_rate_type(index, sequence_length)
    index.zero? || index == sequence_length - 1 ? :travel : :full
  end

  def determine_city_type(projects)
    projects.any?(&:high_cost?) ? :high : :low
  end
end 