class WelcomeController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::DateHelper

  def index
    get_blog_posts
  end

  private
  def get_blog_posts
    # this would be so much easier if the Medium API allowed GET requests for posts
    require 'rss'
    @posts = []
    run_sanitizer
    rss = RSS::Parser.parse(open('https://medium.brianemory.com/feed').read, false).items[0..2]

    rss.each do |result|
      result = { title: get_title(result.title),
                 date: get_date(result.pubDate),
                 link: get_link(result.link),
                 heading: get_heading(result.content_encoded),
                 content: get_content(result.content_encoded) }
      @posts.push(result)
    end
    @posts
  end

  def run_sanitizer
    @sanitizer = Rails::Html::FullSanitizer.new
  end

  def get_title(title)
    title
  end

  def get_date(date)
    if date > 1.day.ago
      "#{time_ago_in_words(date)} ago"
    else
      date.strftime('%b %d, %Y')
    end
  end

  def get_link(link)
    link[/[^?]+/]
  end

  def get_heading(content)
    @sanitizer.sanitize(content.sub(/(<h4>|<h3>)/, '<Z>')
                               .sub(/(<\/h4>|<\/h3>)/, '<Z>')[/(<Z>).*(<Z>)/])
  end

  def get_content(content)
    @sanitizer.sanitize(content.sub(/(<figure>).*(<\/figure>)/, '')
                               .truncate(300, separator: ' ')
                               .sub(/(<h4>|<h3>).*(<\/h4>|<\/h3>)/, ''))
  end
end

