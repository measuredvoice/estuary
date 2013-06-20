class PostsController < ApplicationController
  layout 'browse'

  def show
    page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : 15

    @posts = Post.most_recent

    @post_count = Post.count
    @account_count = Account.active.count

    # uncomment the next line to show g+ and tweet sharers
    # @show_sharers = 1
  end
end
