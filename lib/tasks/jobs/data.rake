namespace :job do
  namespace :data do
    desc "Remove data that is old enough that it should be removed"
    task clear: :environment do
      OldDataRemovalService.call
    end
  end
end
