# frozen_string_literal: true

module Lenbands::EventOwnershipContract
  module_function

  def family_alignment_errors(ownership:, families:)
    errors = []
    family_by_id = index_families(families, errors)

    ownership.each do |event, declaration|
      unless declaration.is_a?(Hash)
        errors << "#{event}: ownership declaration must be a mapping"
        next
      end

      family_id = declaration["owner_family"]
      family = family_by_id[family_id]
      next unless family

      shared_events = Array(family["shared_events"])
      errors << "#{event}: absent from #{family_id}.shared_events" unless shared_events.include?(event)
    end

    family_by_id.each do |family_id, family|
      next unless family["lifecycle"] == "ACTIVE"

      Array(family["shared_events"]).each do |event|
        declaration = ownership[event]
        if declaration.nil?
          errors << "#{family_id}.shared_events contains unowned event #{event}"
        elsif declaration.is_a?(Hash) && declaration["owner_family"] != family_id
          errors << "#{family_id}.shared_events contains #{event}, owned by #{declaration["owner_family"]}"
        end
      end
    end

    errors
  end

  def index_families(families, errors)
    families.each_with_object({}) do |family, index|
      unless family.is_a?(Hash)
        errors << "family registry entry must be a mapping"
        next
      end

      family_id = family["family_id"]
      if family_id.to_s.empty?
        errors << "family registry entry missing family_id"
      elsif index.key?(family_id)
        errors << "duplicate family_id #{family_id}"
      else
        index[family_id] = family
      end
    end
  end
  private_class_method :index_families
end
