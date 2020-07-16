# Set the host name for URL creation

# We can use `gzip --decompress  --stdout public/sitemap.xml.gz | tidy -xml -i` to check the results

SitemapGenerator::Sitemap.default_host = "https://www.lanzhiheng.com"

SitemapGenerator::Sitemap.create_index = false

# https://github.com/kjvarga/sitemap_generator#sitemaps-with-no-index-file
SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add "/"

  Post.published.find_each do |post|
    add post_path(post.category.key, post.slug), lastmod: post.updated_at
  end

  add "/about"
  add "/contact"
end
