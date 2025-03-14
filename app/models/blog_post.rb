class BlogPost < ApplicationRecord
  has_rich_text :content

  validates :title, presence: true
  validates :content, presence: true

  # version ancienne pour les requetes sql
  # scope :sorted, -> { order(Arel.sql("published_at DESC NULLS LAST").order(updated_at: :desc)) }
  # version nouvelle
  scope :sorted, -> { order(arel_table[:published_at].desc.nulls_last).order(updated_at: :desc) }
  scope :draft, -> { where(published_at: nil) }
  scope :published, -> { where("published_at <= ?", Time.current) }
  scope :scheduled, -> { where("published_at > ?", Time.current) }

  def draft?
    published_at.nil?
  end

  def published?
    published_at? && published_at <= Time.current
  end

  def scheduled?
    published_at? && published_at > Time.current
  end
end
