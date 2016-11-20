define 'app.topic.Topics', [

  'app.collection.Collection'

], ( Collection ) ->

  Topics = Collection.extend
    url: '/topics'

  Topics


