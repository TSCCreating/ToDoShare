class Todo < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :images, dependent: :destroy
  validates :first_body, presence: true

  def tweet(todo)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_API_KEY']
      config.consumer_secret = ENV['TWITTER_SECRET_KEY']
      config.access_token = current_user.access_token
      config.access_token_secret = current_user.access_token_secret
    end
    client.update(todo_url(todo))
  end

  def like?(id)
    likes.find_by(twitter_id: id)
  end

end