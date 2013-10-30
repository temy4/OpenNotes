# coding: utf-8
#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path
configure :development do
  db = URI.parse(ENV['DATABASE_URL'] || 'mysql2://10.233.106.247/opennote')
 
  ActiveRecord::Base.establish_connection(
      :adapter => db.scheme == 'mysql' ? 'mysql2' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => 'toor',
      :database => db.path[1..-1],
      :encoding => 'utf8'
  )
end

configure :production do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///ec2-54-228-195-91.eu-west-1.compute.amazonaws.com/d22s6r0mv2ui8d')

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end