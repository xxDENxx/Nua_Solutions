class MessagesController < ApplicationController

  def show
    @message = Message.find(params[:id])
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to messages_path
    else
      render :new
    end
  end

  def reissue
    Message.create(reissue_params)
    PaymentProviderFactory.provider.debit_card(User.current)
    Payment.create(user: User.current)
    redirect_to messages_path
  end

  private

  def message_params
    m_params = params.require(:message).permit(:body)
    m_params[:outbox] = User.current.outbox
    m_params[:inbox] = detect_inbox
    m_params
  end

  def detect_inbox
    original = Message.find_by(id: params[:reply_to])
    if original && original.created_at < 1.week.ago
      User.default_admin.inbox
    else
      User.default_doctor.inbox
    end
  end

  def reissue_params
    {
      body: "I've lost my script, please issue a new one at a charge of €10",
      inbox: User.default_admin.inbox,
      outbox: User.current.outbox
    }
  end
end
