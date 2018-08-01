class Transaction < ApplicationRecord
  default_scope { order(posted_on: :desc) }
end
