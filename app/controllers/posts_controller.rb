class PostsController < ApplicationController
  layout 'browse'

  def show
    @posts = Post.recent.page(params[:page])

    @post_count = Post.count
    @account_count = Account.active.count

    # uncomment the next line to show g+ and tweet sharers
    # @show_sharers = 1
  end
end
