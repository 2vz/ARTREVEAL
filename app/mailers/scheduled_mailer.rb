
class ScheduledMailer < ApplicationMailer
  def future_email(recipient, subject, content)
    @content = content
    mail(to: recipient, subject: subject)
  end
end
