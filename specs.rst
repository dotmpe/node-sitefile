
1. Sitefile_yaml [_`1.`]

   1. The local Sitefile.yaml serves the local documentation, and doubles is an example for all handlers. [_`1.1.`]

      1. should serve its own ReadMe
      2. should serve its own ReadMe and redirect ReadMe.rst
      3. should serve its own ChangeLog
      4. should serve a CoffeeScript file to Javascript
      5. should serve a Pug file to HTML
      6. should serve a Stylus file to CSS file
      7. should serve routes for a local extension router example

2. lib_dotmpe_conf [_1.]

   1. Module conf

      1. .get:

         1. Should get the name of the nearest Sitefile
         2. Should get the path of the nearest sitefilerc
         3. Should get the names of all the sitefilerc

      2. .load_file:

         1. Should load the data of a sitefilerc

      3. .load

         1. Should load the data of the nearest sitefilerc

3. lib_sitefile_express

   1. Module sitefile.express:

      1. just loads, nothing more.

4. lib_sitefile_index

   Module sitefile:
     .version:
       - should be valid semver
       - should equal package versions
     .get_local_sitefile_name:
       - should use options
       - should export default option values
       - should pick up the local Sitefile.yaml
       - should pick up Sitefiles for all extensions
       - should throw "No Sitefile"
     .prepare_context:
       accepts options:
         - object

       - Should return an object
       - Should export options
       - Should load the config
       - Should load rc
       - Should load the sitefile
     local Sitefile:
       - contains references, globalized after loading

5. lib_sitefile_router_du

   1. Module sitefile.router.du.

      1. just loads, nothing more.


