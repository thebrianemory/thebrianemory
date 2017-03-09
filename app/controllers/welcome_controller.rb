class WelcomeController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def index
    get_blog_posts
  end

  private
  def get_blog_posts
    # this would be so much easier if the Medium API allowed GET requests for posts
    # I'll have to clean this up later after it is working
    require 'rss'
    sanitizer = Rails::Html::FullSanitizer.new
    @posts = []
    rss = RSS::Parser.parse(open('https://medium.brianemory.com/feed').read, false).items[0..2]

    rss.each do |result|
      result = { title: result.title,
                 date: result.pubDate.strftime('%A, %d %b %Y at%l:%M %p'),
                 link: result.link[/[^?]+/],
                 heading: sanitizer.sanitize(result.content_encoded.sub(/(<h4>|<h3>)/, '<Z>').sub(/(<\/h4>|<\/h3>)/, '<Z>')[/(<Z>).*(<Z>)/]),
                 content: sanitizer.sanitize(result.content_encoded.sub(/(<figure>).*(<\/figure>)/, '').truncate(300, separator: ' ').sub(/(<h4>|<h3>).*(<\/h4>|<\/h3>)/, '')) }
      @posts.push(result)
    end
    @posts
  end
end

