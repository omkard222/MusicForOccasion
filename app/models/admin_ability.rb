# limit acess for admin base on role
class AdminAbility
  include CanCan::Ability

  def initialize(admin)
    admin ||= Admin.new
    if admin && admin.role == 'Master Admin'
      can :access, :rails_admin
      can :manage, :all
    elsif admin && admin.role == 'Admin'
      can :access, :rails_admin
      can :manage, :all
      cannot :read, Admin
    end
  end
end
