module TwitterHelper
  def twitter_embed(tweet_id)
    begin
      Twitter.oembed(tweet_id, :omit_script => true).html.html_safe
    rescue Exception => e
      logger.info "Can't get Twitter oEmbed for #{tweet_id}: #{e}"
      return nil
    end
  end
end
