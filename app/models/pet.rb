class Pet < ApplicationRecord
  enum :pet_type, [ :cat, :dog ], prefix: true
  enum :tracker_type, [ :small, :medium, :big ], prefix: true

  validates :pet_type, presence: true
  validates :tracker_type, presence: true
  validates :owner_id, presence: true

  validates :in_zone, inclusion: { in: [ true, false ] }
  validates :lost_tracker, inclusion: { in: [ true, false ] }

  validate :tracker_type_allowed_for_pet_type
  validate :lost_tracker_only_for_cat

  private

  def tracker_type_allowed_for_pet_type
    if pet_type_cat? && tracker_type_medium?
      errors.add(:tracker_type, :cats_cannot_have_medium_tracker)
    end
  end

  def lost_tracker_only_for_cat
    if pet_type_dog? && lost_tracker
      errors.add(:lost_tracker, :can_only_be_true_for_cats)
    end
  end
end
