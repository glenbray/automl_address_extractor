class Site < ApplicationRecord
  has_many :pages, dependent: :delete_all
  has_many :addresses, dependent: :delete_all
end
