require 'test_helper'
 
class MessageTest < ActiveSupport::TestCase
  setup do
    @inbox = inboxes(:doctor)
    @outbox = outboxes(:patient)
  end
  test "has an unread status after creation" do
    message = Message.new(inbox: @inbox, outbox: @outbox)
    assert message.save
    assert_not message.read
  end
  test "Increment inbox counter when create" do
    assert_difference(-> { @inbox.unreaded_messages_count }) do
      Message.create(inbox: @inbox, outbox: @outbox)
    end
  end
  test "Decrement inbox counter when readed" do
    message = Message.create(inbox: @inbox, outbox: @outbox)
    assert_difference(-> { @inbox.unreaded_messages_count }, -1) do
      message.update(read: true)
    end
  end
end