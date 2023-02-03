module Posts
  class DeletePost
    extend Dry::Initializer

    option :user
    option :post_id

    def call
      if user.email == "anonymous@blinkist"
        Rails.logger.error "An anonymous user tried to delete a post!"
        Rails.logger.error "post_id: #{post_id}"
        Rails.logger.error user.to_json

        return false
      end

      Post.where(id: post_id, user_id: user.id).delete_all

      true
    end
  end
end
