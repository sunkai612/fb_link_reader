class Link < ActiveRecord::Base
  belongs_to :linking, polymorphic: true
end
