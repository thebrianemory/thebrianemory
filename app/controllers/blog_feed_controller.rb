class BlogFeedController < ApplicationController

  def blog_posts
    require 'rss'
    rss_results = []
    rss = RSS::Parser.parse(open('https://medium.brianemory.com/feed').read, false).items[0..2]

    rss.each do |result|
      result = { title: result.title,
                 date: result.pubDate.strftime('%A, %d %b %Y at%l:%M %p'),
                 link: result.link[/[^?]+/],
                 content: result.content_encoded.sub(/(<figure>).*(<\/figure>)/, '').truncate(200, separator: ' '),
                 image: result.content_encoded[/(https).*(.jpeg)/] }
      rss_results.push(result)
    end
    rss_results
  end
end
