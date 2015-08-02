class ConversationsController < ApplicationController
  before_filter :signed_in_user
  before_filter :current_user_has_access?
  before_filter :load_recipient, only: [:new, :create]

  def index
    @conversations = current_user.mailbox.conversations

    current_user.mailbox.conversations.where(id: params[:conversation_id]).first.try(:mark_as_read, current_user)
  end

  def show
    @conversation = current_user.mailbox.conversations.where(:id => params[:id]).first
    redirect_to(:index) && return unless @conversation.present?
    current_user.mailbox.conversations.where(id: params[:conversation_id]).first.try(:mark_as_read, current_user)
  end

  def reply
    conversation = current_user.mailbox.conversations.where(id: params[:id]).first

    if current_user.reply_to_conversation(conversation, params[:reply_body])
      flash[:notice] = "Reply successfully sent"
    else
      flash[:error] = "Error sending reply"
    end

    redirect_to conversations_path(conversation_id: conversation.id)
  end


  def new
  end

  def create
    if receipt = current_user.send_message(@recipient, params[:message_body], params[:message_subject])
      flash[:notice] = "Message successfully send"
    else
      flash[:error] = "Error sending message"
    end

    redirect_to conversations_path(conversation_id: receipt.conversation)
  end


  private

    def load_recipient
      unless (@recipient = User.find_by_id(params[:recipient_id])) && @recipient != current_user
        redirect_to conversations_path, error: 'Error with message recipient'
      end
    end
end
