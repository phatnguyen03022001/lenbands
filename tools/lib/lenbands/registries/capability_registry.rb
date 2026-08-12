# frozen_string_literal: true

module Lenbands::Registries::CapabilityRegistry
  MAP_PATH = File.join(Lenbands::ROOT, "artifacts/operations/capability-family-map.yaml")

  def self.all
    @all ||= Lenbands::Registries::Support.load_mapping(MAP_PATH)
  end

  def self.entries
    @entries ||= Lenbands::Registries::Support.required_array(all, "capability_map", MAP_PATH)
  end

  def self.count
    entries.length
  end

  def self.find(capability_id)
    entries.find { |e| e["capability_id"] == capability_id }
  end

  def self.family_for(capability_id)
    entry = find(capability_id)
    entry&.dig("family_id")
  end

  def self.active
    @active ||= Lenbands::Registries::Support.deep_freeze(entries.select { |e| e["lifecycle"] == "ACTIVE" })
  end

  def self.ids
    @ids ||= Lenbands::Registries::Support.deep_freeze(entries.map { |e| e["capability_id"] }.to_set)
  end

  def self.each(&block)
    entries.each(&block)
  end

  def self.family_ids
    @family_ids ||= Lenbands::Registries::Support.deep_freeze(entries.map { |e| e["family_id"] }.uniq.sort)
  end
end
