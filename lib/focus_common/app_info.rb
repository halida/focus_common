class FocusCommon::AppInfo

  def get_database_time_info
    conn = ActiveRecord::Base.connection
    if conn.class.name.demodulize == 'Mysql2Adapter'
      {zone: conn.execute("SELECT @@global.time_zone, @@session.time_zone;").to_a.flatten,
       time: conn.execute("select concat(now(), '');").to_a.flatten.first,
      }
    else
      {}
    end
  end

  def git_version
    if Rails.env.development?
      `git rev-parse HEAD`
    else
      filename = File.join(Rails.root, 'REVISION')
      if File.exists?(filename)
        File.read(filename).strip
      else
        nil
      end
    end
  end

  def get_info
    db_time_info = self.get_database_time_info
    info = \
    {
      environment: {
        rails: Rails.env,
        stage: ENV['STAGE'],
      },
      version: {
        ruby: RUBY_VERSION,
        rails: Rails::VERSION::STRING,
        git: git_version,
      },
      time: {
        system: {
          time: Time.now.to_s,
          zone: Time.now.zone,
        },
        rails: {
          time: Time.zone.now,
          zone: Time.zone.to_s,
        },
        database: {
          time: db_time_info[:time],
          global_zone: db_time_info[:zone].try(:first),
          session_zone: db_time_info[:zone].try(:second),
        },
      },
      important_gems: get_gems.map{|g| [g.name, g.version]}.to_h.slice(*self.important_gems),
    }

    if defined?(CbaDB)
      info[:cba_site] = \
      CbaDB.enabled_sites.map do |site|
        namespace = CbaDB.sites_info.fetch(site, {})[:db_name]
        [site, namespace]
      end.to_h
    end

    info
  end

  def important_gems
    ['sidekiq',
     'grape',
     'elasticsearch',
     'twitter-bootstrap-rails',
    ]
  end

  def get_gems
    Gem::Specification.sort_by{ |g| [g.name.downcase, g.version] }
  end

end
