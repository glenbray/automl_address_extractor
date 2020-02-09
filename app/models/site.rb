class Site < ApplicationRecord
  has_many :pages, dependent: :delete_all
end
