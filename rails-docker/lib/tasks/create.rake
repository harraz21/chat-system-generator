# bin/rake create:import
desc 'create rake task'
task :import => :environment do
        MessageBody.import(force: true)
end
