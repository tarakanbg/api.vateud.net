namespace :api do
  desc "Migrating over old data"
  task :migrate => :environment do 

    records = JSON.parse(File.read('vaccs.json'))
    records.each do |record|
      Vacc.create!(record)
    end

  end

  task :update => :environment do 
    Member.parse_csv
  end

end
