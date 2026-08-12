# frozen_string_literal: true

module Lenbands::Registries::FamilyRegistry
  REGISTRY_PATH = File.join(Lenbands::ROOT, "artifacts/operations/capability-family-registry.yaml")

  def self.all
    @all ||= Lenbands::Registries::Support.load_mapping(REGISTRY_PATH)
  end

  def self.families
    @families ||= Lenbands::Registries::Support.required_array(all, "families", REGISTRY_PATH)
  end

  def self.find(family_id)
    families.find { |f| f["family_id"] == family_id }
  end

  def self.each(&block)
    families.each(&block)
  end

  def self.ids
    @ids ||= Lenbands::Registries::Support.deep_freeze(families.map { |f| f["family_id"] })
  end

  def self.active_families
    @active_families ||= Lenbands::Registries::Support.deep_freeze(families.select { |f| f["lifecycle"] == "ACTIVE" })
  end

  def self.owner_spec_for(family_id)
    find(family_id)&.dig("owner_spec")
  end
end
