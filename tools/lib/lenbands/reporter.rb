# frozen_string_literal: true

class Lenbands::Reporter
  attr_reader :errors

  def initialize(label)
    @label = label
    @errors = []
  end

  def <<(msg)
    @errors << msg
  end

  def fail!
    errors.each { |e| warn e }
    warn "#{@label} failed: #{errors.length} issue(s)"
    exit 1
  end

  def pass!(msg)
    fail! unless errors.empty?
    puts msg
    exit 0
  end
end
