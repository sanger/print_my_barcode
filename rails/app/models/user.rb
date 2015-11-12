class User < ActiveRecord::Base

  validates :login, presence: true, uniqueness: true

  def self.authenticate(username, password)
    exists?(login: username) && Ldap.authenticate(username, password)
  end
end
