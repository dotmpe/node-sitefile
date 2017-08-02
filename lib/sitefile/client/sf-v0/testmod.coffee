define 'sf-v0/testmod', [

  'cs!./component'
  'cs!./mixins'

], ( Compoment, mixins ) ->

  class TestMod extends Compoment
    
  mixins.mixin TestMod

  TestMod
    
