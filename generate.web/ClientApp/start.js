/**
 * Wrapper script for Angular CLI dev server.
 * The ASP.NET Core SPA proxy (UseAngularCliServer) looks for:
 *   "open your browser on (http\S+)"
 * Angular 19+ (esbuild) outputs:
 *   "  ➜  Local:   http://localhost:PORT/"
 * This script runs ng serve and emits the expected string for the SPA proxy.
 */
const { spawn } = require('child_process');
const path = require('path');

// Args forwarded by SPA proxy (e.g. --port 12345)
const args = process.argv.slice(2);

const ngBin = path.resolve(__dirname, 'node_modules', '@angular', 'cli', 'bin', 'ng.js');

const ng = spawn(process.execPath, [ngBin, 'serve', ...args], {
    stdio: ['inherit', 'pipe', 'pipe'],
    cwd: __dirname
});

let urlEmitted = false;

ng.stdout.on('data', (data) => {
    const text = data.toString();
    process.stdout.write(text);

    // Angular 19 esbuild outputs: "  ➜  Local:   http://localhost:PORT/"
    // Strip ANSI escape codes before matching (Angular CLI uses color output)
    if (!urlEmitted) {
        const stripped = text.replace(/\x1b\[[0-9;]*[mGKHF]/g, '');
        const match = stripped.match(/Local:\s+(http\S+)/);
        if (match) {
            urlEmitted = true;
            // Emit the string that UseAngularCliServer is waiting for
            console.log('open your browser on ' + match[1]);
        }
    }
});

ng.stderr.on('data', (data) => {
    process.stderr.write(data);
});

ng.on('exit', (code) => {
    process.exit(code != null ? code : 0);
});
