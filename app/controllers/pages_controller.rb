class PagesController < ApplicationController
  
  def home
  end

  def result
    @google_site = params[:pages][:google_site]
    @search_term = params[:pages][:search_term]
    @nb_result   = params[:pages][:nb_result]
    @proxy       = params[:pages][:proxy]
    
    if @google_site.empty?
      @google_site = nil
    end
    
    if @search_term.empty?
      @search_term = nil
    end
    
    if @nb_result.empty?
      @nb_result = 10
    end
    
    if @proxy.empty?
      @proxy = nil
    end
    
    @result = google_search(:google_site => @google_site, :search_term => @search_term, :nb_result => @nb_result, :proxy => @proxy)
    
  end
  
end
