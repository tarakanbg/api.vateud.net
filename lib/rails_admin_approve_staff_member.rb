require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdminApproveStaffMember
end
 
module RailsAdmin
  module Config
    module Actions
      class ApproveStaffMember < RailsAdmin::Config::Actions::Base
        register_instance_option :visible? do
          authorized? && !bindings[:object].vateud_confirmed
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-check'
        end

        register_instance_option :controller do
          Proc.new do
            @object.approve_staff_member
            flash[:notice] = "You have approved the staff member with cid: #{@object.cid}."       
            redirect_to back_or_index
          end
        end
      end
    end
  end
end