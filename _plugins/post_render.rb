require 'ruby-pinyin'

Jekyll::Drops::UrlDrop.class_eval do |a|
  def title
    PinYin.of_string(@obj.basename_without_ext).join('-')
  end
end
