module UsersHelper
  def gravatar_for user, options = {size: Settings.gravatar_for_user}
    gravatar_id = Digest::MD5::hexdigest user.email.downcase
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def follow_form
    current_user.active_relationships.build
  end

  def unfollow_form
    current_user.active_relationships.find_by(followed_id: @user.id)
  end
end
