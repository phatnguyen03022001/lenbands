# frozen_string_literal: true

# Reads capability-manifest.yaml (projection seed, NOT source_of_truth).
# Only used by generators and reports — NOT by validators.

module Lenbands::Registries::ManifestRegistry
  MANIFEST_PATH = File.join(Lenbands::ROOT, "artifacts/operations/capability-manifest.yaml")

  def self.all
    @all ||= Lenbands::Registries::Support.load_mapping(MANIFEST_PATH)
  end

  def self.p0_families
    @p0_families ||= Lenbands::Registries::Support.required_array(all, "capability_families", MANIFEST_PATH)
  end

  def self.p0_ids
    @p0_ids ||= Lenbands::Registries::Support.deep_freeze(p0_families.map { |f| f["family_id"] })
  end

  def self.p0_pack(pack_id)
    p0_families.find { |f| f["family_id"] == pack_id }
  end
end
