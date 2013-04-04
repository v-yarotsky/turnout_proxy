require 'posix/spawn'

module TravisSpawn
  include POSIX::Spawn

  def spawn(command, *args)
    if ENV["TRAVIS"]
      command = "rvmsudo " + command
    end
    super(command, *args)
  end
end
