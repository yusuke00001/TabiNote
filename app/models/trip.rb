class Trip < ApplicationRecord
  belongs_to :user

  enum :status, { in_progress: 1, completed: 2 }
  enum :transportation, { car: 1, train: 2, walk: 3 }
end
