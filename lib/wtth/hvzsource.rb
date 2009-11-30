module WTTH
  private
  def self.get_new_zombies
    to_welcome = []
    zombies = []

    puts "fetching from hvzsource"

    uri = URI.parse(CONFIG[:player_list_uri])
    preq = Net::HTTP::Post.new(uri.path)
    preq['user-agent'] = "welcome to the horde #{VERSION}"
    preq.set_form_data({'faction' => 'h', 'sort_by' => 'kd', 'order' => 'd', 'show_killed' => '1', 'submit' => 'Refresh'}, '&')

    req = Net::HTTP.new(uri.host, uri.port)
    req.start do |http|
      http.request(preq) do |resp|
        doc = Nokogiri::HTML(resp.read_body)
        # hvzsource produces some malformed html, so we can't use rows
        # the table is <name> | horde | <tod>
        cells = doc.xpath('//form/table//td')
        ((cells.length - 3) / 3).times do |i|
          name = cells[i * 3 + 3].content
          zombies << name
          to_welcome << name unless CONFIG[:zombies] != nil and CONFIG[:zombies].include?(name)
        end
      end
    end
    CONFIG[:zombies] = zombies unless zombies.length == 0
    return to_welcome
  end
end
