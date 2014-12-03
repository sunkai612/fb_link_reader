class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  after_create :setup_preference

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_one :show_setting, dependent: :destroy
  has_many :subscribed_objs, dependent: :destroy
  has_many :subscribeds, through: :subscribed_objs, source: :subscription
  has_many :collections, dependent: :destroy
  has_many :user_link_statuses, dependent: :destroy
  has_many :news_links, through: :user_link_statuses, source: :link

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
      user.token = auth.credentials.token
    end
  end

  def setup_preference
    ShowSetting.create({user_id: self.id})
  end
end
