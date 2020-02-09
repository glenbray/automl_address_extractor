class Page < ApplicationRecord
  belongs_to :site, counter_cache: true
end
