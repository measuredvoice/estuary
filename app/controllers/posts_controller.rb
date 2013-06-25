class PostsController < ApplicationController
  layout 'browse'

  def show
    @posts = Post.recent.where('image_url IS NOT NULL').page(params[:page])

    @post_count = Post.count
    @account_count = Account.active.count

    @show_sharers = false
    @embed_tweets = false
  end
end
