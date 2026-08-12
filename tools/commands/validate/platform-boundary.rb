#!/usr/bin/env ruby
# frozen_string_literal: true

root = File.expand_path("../../..", __dir__)
errors = []

required_policy = {
  "artifacts/engineering/decisions/ADR-0004-composition-first-application-platform.md" => %w[composition-first dependency manifests exception ADR],
  "artifacts/business/decisions/build-buy-register.md" => ["Build / Buy", "must not build", "Procurement gate"]
}
required_policy.each do |relative, markers|
  path = File.join(root, relative)
  unless File.file?(path)
    errors << "missing composition policy: #{relative}"
    next
  end
  body = File.read(path)
  markers.each { |marker| errors << "#{relative}: missing policy marker #{marker.inspect}" unless body.downcase.include?(marker.downcase) }
end

stacks = [
  {name: "Go backend", roots: %w[services apps], glob: "**/*.go", manifest: "go.mod", locks: ["go.sum"]},
  {name: "Python engine", roots: %w[engines services], glob: "**/*.py", manifest: "pyproject.toml", locks: ["uv.lock", "poetry.lock", "requirements.lock"]},
  {name: "Next.js frontend", roots: %w[apps], glob: "**/*.{ts,tsx,js,jsx}", manifest: "package.json", locks: ["pnpm-lock.yaml", "package-lock.json", "yarn.lock", "bun.lock", "bun.lockb"]}
]

stacks.each do |stack|
  source_files = stack[:roots].flat_map { |base| Dir.glob(File.join(root, base, stack[:glob])) }
  next if source_files.empty?
  manifests = stack[:roots].flat_map { |base| Dir.glob(File.join(root, base, "**", stack[:manifest])) }
  errors << "#{stack[:name]} source exists without #{stack[:manifest]}" if manifests.empty?
  locks = stack[:roots].flat_map { |base| stack[:locks].flat_map { |lock| Dir.glob(File.join(root, base, "**", lock)) } }
  errors << "#{stack[:name]} source exists without a committed dependency lock/checksum file" if locks.empty?
end

forbidden_roots = %w[runtime-framework workflow-engine job-framework auth-framework orm-framework fsrs-engine]
%w[apps services engines packages].each do |base|
  forbidden_roots.each do |name|
    path = File.join(root, base, name)
    errors << "forbidden generic runtime package requires approved exception ADR: #{path.delete_prefix(root + '/')}" if Dir.exist?(path)
  end
end

if errors.empty?
  puts "platform boundary validation passed (composition-first; source manifests enforced when code appears)"
else
  warn errors.join("\n")
  warn "platform boundary validation failed: #{errors.length} issue(s)"
  exit 1
end
