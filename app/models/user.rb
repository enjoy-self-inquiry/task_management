class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password
  before_validation { email.downcase! }
  validates :password, presence: true, length: { minimum: 6 }
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_destroy :delete_check
  #before_update :update_check

  private
  def delete_check
    throw(:abort) if User.where(admin: true).count <= 1 && self.admin == true
  end
  #def update_check
  #  if User.where(admin: true).count == 1 && self.admin == false
  #    errors.add(:admin,"は、最低でも１人は必要です。")
  #    throw(:abort)
  #  end
  #end
end
