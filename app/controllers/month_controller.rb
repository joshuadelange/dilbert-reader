require 'nokogiri'
require 'uri'
require 'open-uri'

class MonthController < ApplicationController

  def view

    # lazy shortcuts
    m = params[:month].to_i
    y = params[:year].to_i

    # simple validations
    if m > 12
      render :text => "Please enter a valid month"
      return
    end

    if y < 1989
      render :text => "Dilbert didn't exist back then"
      return
    end

    if y > Date.today.strftime("%Y").to_i
      render :text => "There are no comics for this date yet"
      return
    end

    @comics = []

    d = 1
    while d < 32

      comic = Comic.find_by_day_and_month_and_year(d, m, y)

      unless comic

        doc = Nokogiri::HTML(open("http://dilbert.com/strips/comic/#{y}-#{m}-#{d}/"))

        # find sub pages on this website!
        doc.css(".STR_Image img").each do |link|

          comic = Comic.create!(
            :day => d,
            :month => m,
            :year => y,
            :location => link['src']
          ) ;

        end

      end

      @comics.push(comic)


      d += 1
    end

    puts "comics! #{@comics}"

  end

end
