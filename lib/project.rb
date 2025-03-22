# frozen_string_literal: true

require 'date'

class Project
  VALID_CITY_TYPES = %i[high low].freeze
  DATE_FORMAT = '%m/%d/%y'

  attr_reader :start_date, :end_date, :city_type

  def initialize(start_date, end_date, city_type)
    @start_date = parse_date(start_date)
    @end_date = parse_date(end_date)
    @city_type = city_type.to_s.downcase.to_sym
    validate_dates
  end

  def days
    (@start_date..@end_date).to_a
  end

  def high_cost?
    city_type == :high
  end

  private

  def parse_date(date)
    return date if date.is_a?(Date)
    Date.strptime(date, DATE_FORMAT)
  end

  def validate_dates
    return unless @start_date > @end_date
    raise ArgumentError, 'Start date cannot be after end date'
  end
end 