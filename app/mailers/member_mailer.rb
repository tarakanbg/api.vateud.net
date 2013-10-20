class MemberMailer < ActionMailer::Base
  default from: "no-reply@vateud.net"

  def welcome_mail(member)
    @member = member
    mail(:to => @member.email, :subject => "Welcome to VATEUD: VATSIM European division")
  end 

   def new_user_admins_email(user, emails)
    @user = user
    mail(:to => emails, :subject => "VATEUD API: new user registration")
  end 
end
