class Message < ApplicationRecord

  belongs_to :inbox
  belongs_to :outbox

  after_create :increment_inbox_counter
  after_update :decrement_inbox_counter
  
  private
  
  def increment_inbox_counter
    inbox.increment!(:unreaded_messages_count)
  end
  
  def decrement_inbox_counter
    if changes[:read]&.last == true
      inbox.decrement!(:unreaded_messages_count)
    end
  end
end