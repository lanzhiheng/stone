# frozen_string_literal: true

atom_feed do |feed|
  feed.title(meta_title)
  feed.updated(lastest_posts.first.created_at)

  @posts.each do |post|
    detail_url = post_url(post)
    schema_date = post.created_at

    feed.entry(post, url: detail_url, schema_date: schema_date) do |entry|
      entry.title(post.title)
      entry.excerpt(post.excerpt)
      entry.content(post.content, type: 'html')
      entry.tag!('app:edited', Time.now)
      entry.author('Lan')
    end
  end
end
