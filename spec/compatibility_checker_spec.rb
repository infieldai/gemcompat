
RSpec.describe Gemcompat::CompatibilityChecker do
  let(:package_name) { 'rails' }
  let(:valid_target_version) { '7.1' }

  subject { described_class.new(package_name:, target_version: valid_target_version) }

  context "initialization" do
    it "works" do
      expect(subject.package_name).to eq('rails')
      expect(subject.target_version).to eq('7.1')
    end

    it "loads package data on initialize" do
      expect(subject.package_incompatibilities['activerecord-import']).to be(Gem::Version.new('1.5.0'))
    end
  end

  context "parse_lockfile" do
    it "detects incompatibilities" do
      subject.parse_lockfile!(lockfile: File.read('spec/file_fixtures/rails_7_1_upgrade_lockfile'))
      expect(subject.found_incompatibilities).to include({ name: 'blazer', using_version: '2.6.5', required_version: '3.0.1' })
    end
  end
end
