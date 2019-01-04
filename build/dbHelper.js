'use strict';

Object.defineProperty(exports, "__esModule", {
    value: true
});
exports.sql = sql;

var _db = require('./db');

var path = require('path');


// Helper for linking to external query files:
function sql(filePath, file) {
    var fullPath = path.join(filePath, file);
    return new _db.pgp.QueryFile(fullPath, { minify: true });
}