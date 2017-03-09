class WelcomeController < ApplicationController

  def index
    get_blog_posts
  end

  private
  def get_blog_posts
    require 'rss'
    @posts = []
    rss = RSS::Parser.parse(open('https://medium.brianemory.com/feed').read, false).items[0..2]

    rss.each do |result|
      result = { title: result.title,
                 date: result.pubDate.strftime('%A, %d %b %Y at%l:%M %p'),
                 link: result.link[/[^?]+/],
                 content: result.content_encoded.sub(/(<figure>).*(<\/figure>)/, '').truncate(200, separator: ' '),
                 image: result.content_encoded[/(https).*(.jpeg)/] }
      @posts.push(result)
    end
    @posts
  end
end
