module GoogleModule
  
  def google_search(args={})
    require 'open-uri'
    require 'nokogiri'
    
    # Get multiple optional arguments
    google_site = args[:google_site]      || 'www.google.com'
    search_term = args[:search_term]      || 'Hello world'
    nb_result   = args[:nb_result].to_i   || 0 
    proxy       = args[:proxy]            || nil
    
    # Return table (+10 for safety). One row = Title + URL name + URL link
    return_table = Array.new(nb_result + 10) { Array.new(3) }
    
    # Initialize variables
    result_per_page = 0
    result_found = 0
    current_page = 0
    index = 0
    
    # While we did not reach all the result asked
    while result_found < nb_result
    
      # How many result per page to show ?
      if (nb_result - result_found) < 100
        result_per_page = (nb_result - result_found)
      else
        result_per_page = 100
      end
      
      puts "Results found       : " + result_found.to_s + " / " + nb_result.to_s
      puts "Results per page    : " + result_per_page.to_s
      puts "Current Google Page : " + current_page.to_s
    
      # Construct the URL
      search_url = "http://#{google_site}/search?num=#{result_per_page}&q=#{URI.escape(search_term)}&start=#{current_page}"
      page = open(search_url, "User-Agent" => "Ruby/#{RUBY_VERSION}", :proxy => proxy)
      html = Nokogiri::HTML page
      
      # For each link found
      html.search("li.g").each do |a|
        
        # Bypass images, URL must have a '.' 
        if a.at_css("cite") != nil and a.at_css("cite").text.strip.include? "."
          
          title = a.at_css("h3 a").text.strip
          link_name = a.at_css("cite").text.strip
          link_url = google_site + a.at_css("h3 a")['href']
          
          puts "----- Link #{index+1} -----------"
          puts title
          puts link_name
          puts link_url
          
          # Record the link informations
          return_table[index][0] = title
          return_table[index][1] = link_name
          return_table[index][2] = link_url
          index += 1
          
        end
        
      end
      
      result_found += result_per_page
      current_page += 1
      
    end
    
    return return_table
    
  end
  
end