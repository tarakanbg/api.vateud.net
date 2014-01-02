# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 10.hours do
  rake "api:update"
end

# clears page caching; not needed for action caching

# every 6.hours do
#   rake "api:cleanup"
# end

every 1.day, :at => '3:12 am' do
  rake "api:custom_charts"
end

every 1.day, :at => '1:05 am' do
  rake "tmp:clear"
end
