#
#  sesameAdapter.rb
#  ContextServer
#  This class connects to the OpenRDF Sesame semantic triple store and hands over all SPARQL queries
#
#  Created by Felix on 19.01.10.
#  Copyright 2010 Felix Mueller (felixmueller@mac.com). All rights reserved.
#
#  Special thanks to Stephan Pavlovic for his hints & support!
#

module SesameAdapter
  
  # Define the repository name
  repo = "contextserver"
  
  # Set up the server URL
  @url="http://localhost:8080/openrdf-sesame/repositories/#{repo}"
  #@url="http://www.gipsprojekt.de/openrdf-sesame/repositories/#{repo}"

  # Define the data types
  DATA_TYPES = {
    :XML => "application/sparql-results+xml",
    :JSON => "application/sparql-results+json"}
  
  #
  # This method executes a SPARQL query and returns the results.
  #
  # Parameters:
  #   query: The SPARQL query
  #
  # Returns:
  #   The query results
  #
  def self.query(query, infer = true, options = {})

    # Set up options
    options = {:result_type => DATA_TYPES[:JSON],:method => :get,:query_language => "sparql"}.merge(options)
    easy = Curl::Easy.new
    easy.headers["Accept"] = options[:result_type]
    
    # Hand over the query and get the results
    easy.url = (@url + "?" + "query=#{ easy.escape(query) }&"+"queryLn=#{ easy.escape(options[:query_language]) }" + "&infer=#{infer}")
    easy.http_get
    
    # Return the results
    return easy.body_str
    
  end
  
  #
  # This method executes a POST request.
  #
  # Parameters:
  #   data: The POST data
  #
  def self.post(data)

    # Prepare request
    easy = Curl::Easy.new
    easy.headers["Content-Type"] = "application/x-rdftransaction"
    easy.url = @url + "/statements"
    
    # Execute request
    easy.http_post(data)

  end
  
end