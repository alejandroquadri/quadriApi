const path = require('path');
import { pgp } from './db';

// Helper for linking to external query files:
export function sql(file) {
    const fullPath = path.join(__dirname, file);
    return new pgp.QueryFile(fullPath, {minify: true});
}

