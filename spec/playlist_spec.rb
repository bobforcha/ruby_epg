module RubyEpg
  RSpec.describe Playlist do
    let(:path)      { "cache/playlist/raw.m3u" }
    let(:playlist)  { described_class.new }
    describe "#save_playlist" do
      it "creates an m3u file" do
        playlist.save_m3u
        expect(File.exist?("playlist/final.m3u")).to be_truthy
      end
    end
  end
end
