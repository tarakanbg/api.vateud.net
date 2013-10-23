class Ability
  include CanCan::Ability

  def initialize(user)
    can :access, :rails_admin   # grant access to rails_admin
    can :dashboard  
    cannot :approve_staff_member, :all    
    if user && user.admin?
      can :manage, AdminUser     
      can :manage, Event     
      can :manage, ApiKey
      can :manage, ChartOverride
      can :manage, StaffMember
      can :approve_staff_member, StaffMember

      can :read, Subdivision     
      can :edit, Subdivision     
      can :history, Subdivision     
      
      can :read, Country
      can :edit, Country
      can :history, Country
      # can :manage, Staff
      can :read, Member
      can :read, Vacc
      can :read, WelcomeEmail
      can :read, ApiCall
    end
    if user
      if user.is? :events
        can :index, Event 
        can :new, Event   
        can :export, Event
        can :show, Event 
        can :edit, Event, :subdivisions => {:id => user.subdivision.id}
        can :destroy, Event, :subdivisions => {:id => user.subdivision.id}
        can :history, Event
        can :index, Subdivision 
        can :read, Subdivision 
        can :history, Subdivision 
        cannot :approve_staff_member, StaffMember    
      end
      if user.is? :staff
        can :read, Event         
        can :history, Event
        can :index, Subdivision 
        can :read, Subdivision 
        can :history, Subdivision 
        can :export, Subdivision 
        can :edit, Subdivision, :id => user.subdivision.id
        can :read, Country
        can :read, StaffMember
        can :history, StaffMember
        can :export, StaffMember
        can :edit, StaffMember, :vacc_code => user.subdivision.code
        can :destroy, StaffMember, :vacc_code => user.subdivision.code
        can :new, StaffMember, :vacc_code => user.subdivision.code
        cannot :approve_staff_member, StaffMember
        # can :read, Member
      end
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
