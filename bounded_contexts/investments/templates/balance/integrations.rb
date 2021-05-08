# frozen_string_literal: true

module IntegrationTestsHelpers
  def command_service
    Sequent.command_service
  end

  def travel_in_future(seconds)
    Timecop.travel(current_time + seconds)
  end

  def current_time
    DateTime.current
  end

  def register_user
    proc do |user_id, options|
      binding.pry
      user_id ||= Sequent.new_uuid
      options ||= {}
      default_options = {
        aggregate_id: user_id,
        email: 'foo@example.com',
        firstname: "First name",
        lastname: "Last name",
      }

      command_args = default_options.merge(options)
      command_service.execute_commands RegisterUser.new(command_args)
      travel_in_future(1.seconds)
      user_id
    end
  end
end
