class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[ show update destroy ]

  # GET /posts
  def index
    Rails.logger.debug "getting posts..."

    time = Time.now.to_i
    posts = Post.all.to_a
    Rails.logger.info "returning #{posts.count} posts"

    time_now = Time.now.to_i
    Rails.logger.info "Load time: #{time_now - time} seconds"

    if time_now - time > 2
      Rails.logger.error "The query took a lot of time!"
    end

    render json: posts.take(10)
  end

  # GET /posts/1
  def show
    Rails.logger.info "getting post #{params[:id]}"
    Rails.logger.info "user #{current_user.id}"
    Rails.logger.error "Someone requested debug posts!" if @post.id < 1000

    render json: @post
  end

  # POST /posts
  def create
    Rails.logger.info "Creating a post..."

    command = Posts::CreatePost.new(user: current_user, name: post_params[:name], content: post_params[:content])
    post = command.call

    if post.persisted?
      Rails.logger.info "success!"
      Rails.logger.info post.to_json
      render json: post, status: :created, location: post
    else
      Rails.logger.error "Creation of a post failed"
      Rails.logger.info post.errors
      render json: post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    Rails.logger.warn "Updating a post!"

    if @post.update(post_params)
      Rails.logger.info "ok"
      render json: @post
    else
      Rails.logger.info "not ok: #{@post.errors.inspect}"
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    Rails.logger.warn "Deleting a post!"

    command = Posts::DeletePost.new(post_id: params[:id], user: current_user)
    unless command.call
      # We have a nasty bug and we want to know who makes the request
      if browser.platform.android?
        Rails.logger.error "Android request!"
      elsif browser.platform.ios?
        Rails.logger.error "IOS request!"
      else 
        Rails.logger.info "Some other request: #{browser.platform}"
      end
    end

    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    Rails.logger.info "a post requested"
    @post = Post.find_by!(id: params[:id], user_id: current_user.id)
  end

  # Only allow a list of trusted parameters through.
  def post_params
    Rails.logger.debug "params: #{params.inspect}"
    params.require(:post).permit(:name, :content)
  end
end
