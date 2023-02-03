module Posts
  class CreatePost
    extend Dry::Initializer

    option :user
    option :name
    option :content

    def call
      post = Post.new(user: user, name: name, content: content)

      if post.invalid?
        Rails.logger.error "Post parameters are invalid!"
        Rails.logger.error "User: #{user.id}"
        Rails.logger.error "Name: #{name}"
        Rails.logger.error "Content: #{content}"
        Rails.logger.error post.errors

        return post
      end

      if post.save
        Rails.logger.info "Post has been created. Id: #{post.id}"
        Rails.logger.info "Post data: #{post.to_json}"
      else
        Rails.logger.error "Creation of a post failed"
        Rails.logger.error "User: #{user.id}"
        Rails.logger.error "Params: name: #{name}, content: #{content}"
        Rails.logger.error "Errors: #{post.errors}"
      end

      post
    end
  end
end
