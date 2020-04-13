module HomeHelper
  def lastest_posts
    Post.published.limit(15).order('created_at desc')
  end
end
