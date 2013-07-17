module Models
class Base
    include ::App  
  
    def Base.save doc
        DB.save_doc doc
    end
    
    def update 
       DB.update_doc self.id do |_doc|
            yield _doc
            _doc
        end
    end
end
end
