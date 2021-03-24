class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  # お問い合わせ確認画面で内容が確定された後、セッションに保存された情報を保存する
  def confirm
    @contact = Contact.new(contact_params)
    if @contact.valid?
      render :confirm
    else
      render :new
    end
    session[:contact] = @contact
    session[:contact][:name] = @contact.name
    session[:contact][:email] = @contact.email
    session[:contact][:content] = @contact.content
  end

  def create
    contact = Contact.new(session[:contact])
    if contact.save
      ContactMailer.contact_mail(contact).deliver
      session[:contact].clear
      redirect_to contact_thanks_path
    else
      redirect_to new_contact_path
    end
  end

  def thnaks
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :content)
  end
end
