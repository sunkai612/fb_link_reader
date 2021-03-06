class Link < ActiveRecord::Base
  has_many :user_link_statuses, dependent: :destroy
  has_many :receiver, through: :user_link_statuses, source: :user
  has_many :subscription_links, dependent: :destroy
end
