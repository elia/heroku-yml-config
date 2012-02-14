require 'heroku/command/config'
require 'heroku-yml-config/version'

class Heroku::Command::Config
  def upload
    unless args.size == 1
      raise CommandFailed, "Usage: heroku config:upload YML_FILENAME"
    end
    
    config_file_path = args.shift
    config_file_path = File.expand_path(config_file_path)
    vars = YAML.load_file(config_file_path)
    # system 'heroku', 'config:add', *config_hash.to_a.map{|(k,v)| "#{k.upcase}=#{v}"}
  
    # try to get the app to fail fast
    detected_app = app
    
    display "Adding config vars and restarting app...", false
    heroku.add_config_vars(detected_app, vars)
    display " done", false
    
    begin
      release = heroku.releases(detected_app).last
      display(", #{release["name"]}", false) if release
    rescue RestClient::RequestFailed => e
    end

    display
    display_vars(vars, :indent => 2)
  end
end