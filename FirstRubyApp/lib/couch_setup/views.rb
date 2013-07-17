module CouchSetup
    VIEWS = [
      {
        '_id' => '_design/users',
        'views' => {
          'all' => {
            'map' => <<-JS
function(doc) {
    if (doc.type === 'User') {
        emit(doc._id, doc);
    }
}
          JS
          }
        }
      }
    ].freeze
end

