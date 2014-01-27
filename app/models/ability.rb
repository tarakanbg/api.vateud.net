class Ability
  include CanCan::Ability

  def initialize(user)
    can :access, :rails_admin 
    can :dashboard  
    cannot :approve_staff_member, :all    

    if user && user.admin?
      can :manage, AdminUser     
      can :manage, Event     
      can :manage, ApiKey
      can :manage, ChartOverride
      can :manage, StaffMember
      can :manage, Airport      
      can :manage, CustomChartSource      
      can :manage, IndividualCustomChart      
      can :manage, AtcBooking      
      can :manage, MassBooking      
      can :approve_staff_member, StaffMember

      can :read, Subdivision     
      can :edit, Subdivision     
      can :history, Subdivision     
      
      can :read, Member
      can :history, Member
      can :edit, Member
      can :export, Member
      can :read, Country
      can :edit, Country
      can :history, Country
      can :read, Vacc
      can :read, WelcomeEmail
      can :read, ApiCall
      can :read, CustomChart
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

        can :index, Subdivision, :hidden => false
        can :read, Subdivision, :hidden => false 
        can :history, Subdivision, :hidden => false 

        cannot :approve_staff_member, StaffMember  

        can :read, Country, :eud => true  

        can :read, Airport
        can :history, Airport
        can :new, Airport
        can :export, Airport
        can :edit, Airport, :country => user.subdivision.countries
        can :destroy, Airport, :country => user.subdivision.countries

        can :index, MassBooking
        can :read, MassBooking
        can :history, MassBooking
        can :new, MassBooking

        can :index, AtcBooking
        can :read, AtcBooking
        can :history, AtcBooking
        can :new, AtcBooking
        can :export, AtcBooking
        can :edit, AtcBooking, :admin_user_id => user.id
        can :destroy, AtcBooking, :admin_user_id => user.id


      end

      if user.is? :staff        
        can :read, Event         
        can :history, Event

        can :index, Subdivision, :hidden => false 
        can :read, Subdivision, :hidden => false 
        can :history, Subdivision, :hidden => false 
        can :export, Subdivision, :hidden => false 
        can :edit, Subdivision, :id => user.subdivision.id

        can :read, Country, :eud => true 

        can :read, StaffMember
        can :history, StaffMember
        can :export, StaffMember
        can :edit, StaffMember, :vacc_code => user.subdivision.code
        can :destroy, StaffMember, :vacc_code => user.subdivision.code
        can :new, StaffMember, :vacc_code => user.subdivision.code
        cannot :approve_staff_member, StaffMember
        
        can :manage, CustomChartSource, :subdivision_id => user.subdivision.id

        can :read, Member, :subdivision => user.subdivision.code
        can :edit, Member, :subdivision => user.subdivision.code
        can :export, Member, :subdivision => user.subdivision.code
        can :history, Member, :subdivision => user.subdivision.code

        can :manage, IndividualCustomChart

        can :index, MassBooking
        can :read, MassBooking
        can :history, MassBooking
        can :new, MassBooking

        can :index, AtcBooking
        can :read, AtcBooking
        can :history, AtcBooking
        can :new, AtcBooking
        can :export, AtcBooking
        can :edit, AtcBooking, :admin_user_id => user.id
        can :destroy, AtcBooking, :admin_user_id => user.id
      end
    end
    
  end
end
