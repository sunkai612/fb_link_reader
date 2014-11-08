class Category < ActiveRecord::Base
  has_many :links, as: :linking
  has_many :captions, dependent: :destroy
end
