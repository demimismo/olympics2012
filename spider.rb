# coding: UTF-8
require 'nokogiri'
require 'open-uri'
require 'json'
require 'csv'
require 'carmen'
include Carmen

countries = ["afghanistan", "albania", "algeria", "american-samoa", "andorra", "angola", "antigua-and-barbuda", "argentina", "armenia", "aruba", "australia", "austria", "azerbaijan", "bahamas", "bahrain", "bangladesh", "barbados", "belarus", "belgium", "belize", "benin", "bermuda", "bhutan", "bolivia", "bosnia-and-herzegovina", "botswana", "brazil", "brunei", "bulgaria", "burkina-faso", "burundi", "cambodia", "cameroon", "canada", "cape-verde", "cayman-islands", "central-african-republic", "chad", "chile", "china", "colombia", "comoros", "congo", "cook-islands", "costa-rica", "cote-divoire", "croatia", "cuba", "cyprus", "czech-republic", "denmark", "djibouti", "dominica", "dominican-republic", "north-korea", "dr-congo", "ecuador", "egypt", "el-salvador", "equatorial-guinea", "eritrea", "estonia", "ethiopia", "fiji", "finland", "france", "gabon", "gambia", "georgia", "germany", "ghana", "great-britain", "greece", "grenada", "guam", "guatemala", "guinea", "guinea-bissau", "guyana", "haiti", "honduras", "hong-kong", "hungary", "iceland", "independent-olympic-athletes", "india", "indonesia", "iran", "iraq", "ireland", "israel", "italy", "jamaica", "japan", "jordan", "kazakhstan", "kenya", "kiribati", "south-korea", "kuwait", "kyrgyzstan", "laos", "latvia", "lebanon", "lesotho", "liberia", "libya", "liechtenstein", "lithuania", "luxembourg", "madagascar", "malawi", "malaysia", "maldives", "mali", "malta", "marshall-islands", "mauritania", "mauritius", "mexico", "micronesia", "fmr-rep-of-macedonia", "monaco", "mongolia", "montenegro", "morocco", "mozambique", "myanmar", "namibia", "nauru", "nepal", "netherlands", "new-zealand", "nicaragua", "niger", "nigeria", "norway", "oman", "pakistan", "palau", "palestine", "panama", "papua-new-guinea", "paraguay", "peru", "philippines", "poland", "portugal", "puerto-rico", "qatar", "moldova", "romania", "russia", "rwanda", "sao-tome-and-principe", "saint-lucia", "samoa", "san-marino", "saudi-arabia", "senegal", "serbia", "seychelles", "sierra-leone", "singapore", "slovakia", "slovenia", "solomon-islands", "somalia", "south-africa", "spain", "sri-lanka", "saint-kitts-and-nevis", "stv-and-grenadines", "sudan", "suriname", "swaziland", "sweden", "switzerland", "syria", "chinese-taipei", "tajikistan", "tanzania", "thailand", "timor-leste", "togo", "tonga", "trinidad-and-tobago", "tunisia", "turkey", "turkmenistan", "tuvalu", "united-arab-emirates", "uganda", "ukraine", "united-states", "uruguay", "uzbekistan", "vanuatu", "venezuela", "vietnam", "british-virgin-islands", "virgin-islands", "yemen", "zambia", "zimbabwe"]
country_names = ["Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Antigua&Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia&Herzegov", "Botswana", "Brazil", "Brunei Daruss", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Centr Afric Rep", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo", "Cook Islands", "Costa Rica", "Côte d'Ivoire", "Croatia", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Rep.", "DPR Korea", "DR Congo", "Ecuador", "Egypt", "El Salvador", "Equator. Guinea", "Eritrea", "Estonia", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Great Britain", "Greece", "Grenada", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hong Kong, CHN", "Hungary", "Iceland", "Independent Olympic Athletes", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea", "Kuwait", "Kyrgyzstan", "Lao PDR", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Is", "Mauritania", "Mauritius", "Mexico", "Micronesia", "MKD", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Norway", "Oman", "Pakistan", "Palau", "Palestine", "Panama", "Papua N Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Puerto Rico", "Qatar", "Rep. of Moldova", "Romania", "Russia", "Rwanda", "S.Tome&Principe", "Saint Lucia", "Samoa", "San Marino", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "Spain", "Sri Lanka", "StKitts&Nevis", "StV&Grenadines", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria", "Taipei (Chinese Taipei)", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Tonga", "Trinidad&Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "UA Emirates", "Uganda", "Ukraine", "United States", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Isl, B", "Virgin Isl, US", "Yemen", "Zambia", "Zimbabwe"]

total_athletes = 0
not_found = 0
filename = "olympics2012__.csv"
headers = [:name, :age, :gender, :height, :weight, :sport, :date_and_birth_place, :country_code, :birth_place, :birth_country, :country_represented]

CSV.open(filename, "wb") do |csv|
  csv << headers
end

countries.each_with_index do |country, i|
  
  url = "http://www.london2012.com/country/#{country}/athletes/index.html"

  until url == nil
    doc = Nokogiri::HTML(open(url))
    doc.css('div.athletePhoto a').each do |link|
      doc2 = Nokogiri::HTML(open("http://www.london2012.com#{link['href']}"))
      total_athletes = total_athletes + 1
      athlete = {}

      athlete[:name] = doc2.css('h1')[0].text
      athlete[:age] = doc2.css('table.athleteBio div.d')[2].text
      athlete[:gender] = doc2.css('table.athleteBio tr:eq(8) td:last')[0].text.match(/^([MF])\s/)[1] rescue ""
      athlete[:height] = doc2.css('table.athleteBio div.d')[3].text.match(/^([0-9]{2,3}) cm/)[1] rescue ""
      athlete[:weight] = doc2.css('table.athleteBio div.d')[4].text.match(/^([0-9]{2,3}) kg/)[1] rescue ""
      athlete[:sport] = doc2.css('div.sportName a')[0].text

      athlete[:date_and_birth_place] = doc2.css('table.athleteBio div.d')[1].content.to_s
      athlete[:birth_place] = athlete[:date_and_birth_place].gsub(/\(.*\).*$/, '').gsub(/\s*$/, '').gsub(/^\s*/, '').split('-')[1]
      athlete[:country_code] = athlete[:date_and_birth_place].match(/\(([A-Z]{3})\).*$/)[1] rescue ''
      athlete[:birth_country] = Carmen::Country.coded(athlete[:country_code]).name rescue country_names[i]

      athlete[:country_represented] = country_names[i]

      puts "\n\n========================================\nGoing after #{athlete[:name]} \##{total_athletes}"

      # tries = 0
      # until !athlete[:lat].nil? || !athlete[:lat] == "" || tries == 3
      #   begin
      #     tries = tries + 1

      #     q = athlete[:birth_place].nil? ? athlete[:birth_country] : "#{athlete[:birth_place]}, #{athlete[:birth_country]}"

      #     url = "http://services.gisgraphy.com/fulltext/fulltextsearch?q=#{URI.encode(q)}&format=json&from=1&to=1"
      #     result = JSON.parse(open(url).read)["response"]["docs"].first
      #     athlete[:lat] = result["lat"] rescue ""
      #     athlete[:lng] = result["lng"] rescue ""
      #   rescue => e
      #     puts ":( Georeferencing error #{athlete[:date_and_birth_place]}"
      #     puts e.inspect
      #   end
      # end

      # Save the data
      CSV.open(filename, "ab") do |csv|
        csv << headers.map {|h| athlete[h] }
      end

      puts "Saved!"
    end
    url = "http://www.london2012.com#{doc.css('div.nextLink a').first.attr('href')}" rescue nil
  end
end

puts "\n\n========================\nOMG COMPLETED!!"
puts "Total athletes   : #{total_athletes}"
puts "Not georeferenced: #{not_found}"
