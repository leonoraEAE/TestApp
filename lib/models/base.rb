module Models
class Base
    include ::App  
  
    def Base.save doc
        DB.save_doc doc
    end
    
    def Base.update(doc, id)
       DB.update_doc id do |doc|
            yield doc
            doc
        end
    end
    
    def Base.delete doc
      DB.delete_doc doc
    end
end
end
