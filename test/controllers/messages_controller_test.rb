require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  test "should reply for fresh message in correct boxes" do
    message = messages(:fresh)
    assert_difference('Message.count') do
      post messages_url, params: { message: { body: 'some body' }, reply_to: message.id }
    end

    assert Message.last.inbox == User.default_doctor.inbox
    assert Message.last.outbox == User.current.outbox
  end
  
  test "should reply for old message in correct boxes" do
    message = messages(:old)
    assert_difference('Message.count') do
      post messages_url, params: { message: { body: 'some body' }, reply_to: message.id }
    end

    assert Message.last.inbox == User.default_admin.inbox
    assert Message.last.outbox == User.current.outbox
  end
  
  test 'reissue create a message' do
    assert_difference('Message.count') do
      get reissue_message_path(messages(:old))
    end
  end
  
  test 'reissue call a API' do
    mocked_method = MiniTest::Mock.new
    mocked_method.expect :call, nil, [User.current]
    some_instance = PaymentProviderFactory.provider
    some_instance.stub :debit_card, mocked_method do
      get reissue_message_path(messages(:old))
    end
    assert mocked_method.verify
  end
  
  test 'reissue create a Payment' do
    assert_difference('Payment.count') do
      get reissue_message_path(messages(:old))
    end
  end
end
