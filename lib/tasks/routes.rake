namespace :grape do
  desc "TODO"
  # rake grape:routes
  task routes: :environment do
    V1::Users.routes.each do |route|
      path = route.path
      path.sub!("(.:format)",".json")
      path.sub!("/:version","")
      r = {
        method: route.request_method,
        path: path,
        params: route.params,
        desc: route.description
      }
      puts r.map{|k,v| "#{k}:#{v}"}.join('  ')
    end
    V1::Positions.routes.each do |route|
      path = route.path
      path.sub!("(.:format)",".json")
      path.sub!("/:version","")
      r = {
        method: route.request_method,
        path: path,
        params: route.params,
        desc: route.description
      }
      puts r.map{|k,v| "#{k}:#{v}"}.join('  ')
    end    
  end
end