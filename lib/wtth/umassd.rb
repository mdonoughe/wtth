module WTTH
  private
  def self.get_new_zombies
    to_welcome = []
    zombies = []

    puts "fetching from umassdhvz"

    uri = URI.parse(CONFIG[:player_list_uri])
    preq = Net::HTTP::Post.new(uri.path)
    preq['user-agent'] = "welcome to the horde #{VERSION}"
    preq.set_form_data({'show' => 'all_zombie', 'order_by' => 'fname', 'order' => 'asc', 'submit' => 'Update'}, '&')

    req = Net::HTTP.new(uri.host, uri.port)
    req.start do |http|
      http.request(preq) do |resp|
        doc = Nokogiri::HTML(resp.read_body)
        # the table is <name> | <junk>
        rows = doc.xpath('//div[@id="player_table"]/table/tr')
        rows.each do |row|
          cells = row.xpath('td')
          next if cells.empty?
          name = cells.first.content
          zombies << name
          to_welcome << name unless CONFIG[:zombies] != nil and CONFIG[:zombies].include?(name)
        end
      end
    end
    CONFIG[:zombies] = zombies unless zombies.length == 0
    return to_welcome
  end
end
