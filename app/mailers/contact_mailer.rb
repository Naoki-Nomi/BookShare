class ContactMailer < ApplicationMailer
  def contact_mail(contact)
    @contact = contact
    mail(:to => ENV['SEND_MAIL'], :subject => 'お問い合わせを承りました')
  end
end