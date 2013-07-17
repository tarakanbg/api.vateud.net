class WelcomeEmail < ActiveRecord::Base
  attr_accessible :member_id
  belongs_to :member

  after_create :send_welcome_mail

  def send_welcome_mail
    MemberMailer.welcome_mail(self.member).deliver    
  end
end
