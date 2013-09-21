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

  task :cleanup => :environment do 
    cache_dir = ActionController::Base.page_cache_directory
    unless cache_dir == RAILS_ROOT+"/public"
      FileUtils.rm_r(Dir.glob(cache_dir+"/*")) rescue Errno::ENOENT
    end
  end

end
