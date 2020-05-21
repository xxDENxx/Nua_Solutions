class AddUnreadMessagesCount < ActiveRecord::Migration[5.0]
  def change
    add_column :inboxes, :unreaded_messages_count, :integer, :default => 0
  
    Inbox.reset_column_information
    Inbox.all.each do |i|
      i.update_attribute :unreaded_messages_count, i.unreaded_messages.count
    end
  end
end
