# Example resource for use with Sitefile's odata router
require 'odata-server'


$data.Entity.extend "Todo",
    Id: { type: "id", key: true, computed: true },
    Task: { type: String, required: true, maxLength: 200 },
    DueDate: { type: Date },
    Completed: { type: Boolean }

$data.EntityContext.extend "TodoDatabase",
    Todos: { type: $data.EntitySet, elementType: Todo }


module.exports.sitefile_odata = TodoDatabase


# $data.createODataServer TodoDatabase, '/example-data-resource', 52999, 'localhost'

# app.use(config.path || path || '/', $data.ODataServer(type));

