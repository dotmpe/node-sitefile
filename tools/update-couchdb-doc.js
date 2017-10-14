var fs = require('fs');

var url = "https://"+process.env.CI_DB_INFO+"@"+process.env.CI_DB_HOST;
var dbname = 'build-log';
var key = 'node-sitefile';


console.log("update-couchdb-doc: DB '"+dbname+"', key: "+key);
var server = require('nano')(url);
var db = server.db.use(dbname);
var buildkey = key+':'+process.env.TRAVIS_JOB_NUMBER;

var results = JSON.parse(fs.readFileSync(process.env.CI_BUILD_RESULTS));
var build = {
  "env": {},
  "stats": {
    "total": results.stats.asserts,
    "passed": results.stats.passes,
    "failed": results.stats.failures
  },
  "tests": results.asserts
};
for (k in process.env) {
  if (k.substr(0, 6) == 'TRAVIS') {
    build.env[k] = process.env[k];
  }
}

// FIXME: need secure dropslot to deposit results, or whitelist travis for
// build-log somehow.
//
// 52.0.0.0/8
// ec2-52-0-0-0.compute-1.amazonaws.com/8
//
// Store current build
db.insert(build, buildkey);

// TODO: Set latest build info
//buildlog = db.get(key);
//console.log('existing', key, buildlog);

//db.update = function(obj, key, callback) {
//    var db = this;
//
//    db.get(key, function (error, existing) {
//        if(!error) obj._rev = existing._rev;
//        db.insert(obj, key, callback);
//    });
//};

//db.update(buildlog, key);
