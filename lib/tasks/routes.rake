namespace :grape do
  namespace :v1 do
    desc "TODO"
    # rake grape:v1:routes
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
      V1::Crumbs.routes.each do |route|
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
      V1::Players.routes.each do |route|
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

  namespace :v2 do
    desc "TODO"
    # rake grape:v2:routes
    task routes: :environment do
      V2::Users.routes.each do |route|
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
      V2::Crumbs.routes.each do |route|
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
      V2::Players.routes.each do |route|
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
end