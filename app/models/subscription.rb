class Subscription < ActiveRecord::Base
  has_many :subscribed_objs, dependent: :destroy
  has_many :subscribers, through: :subscribed_objs, source: :user
  has_many :subscription_links, dependent: :destroy
end
