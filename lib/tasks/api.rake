namespace :api do

  # Below is an example task for creating vACC (subdivision) recoirds from a .json file in the 
  # application root directory. Modifu and use those task as needed to create the countries and
  # subdivision records (country JSON file also included in the app root)

  desc "Migrating over old data"


  # task :migrate => :environment do 
  #   records = JSON.parse(File.read('vaccs.json'))
  #   records.each do |record|
  #     Vacc.create!(record)
  #   end

  # end

  task :update => :environment do 
    Member.parse_csv
  end

# clears page caching; not needed for action caching
  task :cleanup => :environment do 
    cache_dir = ActionController::Base.page_cache_directory
    unless cache_dir == Rails.root+"/public"
      FileUtils.rm_r(Dir.glob(cache_dir+"/*")) rescue Errno::ENOENT
    end
  end

  task :custom_charts => :environment do 
    CustomChartSource.import_charts
  end

end
