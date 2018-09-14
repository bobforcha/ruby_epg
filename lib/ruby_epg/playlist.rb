module RubyEpg
  class Playlist
    attr_accessor :parsed_list

    def initialize
      @path = "playlist"
      @username = File.read("certs/username.txt")
      @password = File.read("certs/password.txt")
      @raw_list = download_playlist
      @parsed_list = parse_playlist
    end

    def save_m3u
      FileUtils.rm_r(@path, force: true)
      FileUtils.mkdir_p(@path)
      File.open("#{@path}/final.m3u", 'w') do |f|
        f.write(@parsed_list)
      end
    end

    private

    def download_playlist
      Net::HTTP.get(URI("http://unlockyourtv.com:8000/get.php?username=#{@username}&password=#{@password}&type=m3u_plus&output=ts"))
    end

    def parse_playlist
      play_array = @raw_list.split("\r\n")

      play_array.each_with_index do |val, index|
        if val.include?("CA:")
          remove_entry(play_array, index)
        end

        if val.include?("tvg-ID")
          val.gsub!(/tvg-ID/, "tvg-id")
        end

        if val.include?("Collage")
          val.gsub!(/Collage/, "College")
        end

        if val.include?("USA Regional") && !val.include?("D.C.")
          remove_entry(play_array, index)
        end

        if val.include?("Latino")
          remove_entry(play_array, index)
        end
      end
      play_array.delete_if { |val| val.empty? }
      play_array
    end

    def remove_entry(array, index)
      array[index] = ""
      array[index + 1] = ""
    end
  end
end
