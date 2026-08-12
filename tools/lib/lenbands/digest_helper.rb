# frozen_string_literal: true

module Lenbands::DigestHelper
  def self.sha256_file(path)
    Digest::SHA256.file(path).hexdigest
  end

  def self.sha256_prefixed(path)
    "sha256:#{sha256_file(path)}"
  end

  def self.valid_checksum?(value)
    value.is_a?(String) && value.match?(/\Asha256:[0-9a-f]{64}\z/)
  end
end
