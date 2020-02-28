module HomeHelper
  def lastest_posts
    Post.published.limit(10).order('created_at desc')
  end
end
