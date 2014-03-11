#on production
every :monday, :at => '5:00 am' do
  runner "Teacher.send_email"
end

#on development
every 2.minutes do
  runner "Teacher.send_email", :environment => :development
end