namespace :carrierwave do
  desc 'Recreate and reprocess files stored on fog'
  task reprocess: :environment do
    Profile.find_each do |ym|
      begin
        ym.profile_picture.cache_stored_file!
        ym.profile_picture.retrieve_from_cache!(ym.profile_picture.cache_name)
        ym.profile_picture.recreate_versions!(:thumb)
        ym.save!
      rescue => e
        puts  "ERROR: Model: #{ym.id} -> #{e.to_s}"
      end
    end
  end
end
