const express = require('express');
const { exec } = require('child_process');
const path = require('path');

const db = require('./db');
const router = require('./router');

const app = express();
const iocContainer = {
    express,
    db
};

app.use(router(iocContainer));

app.get('/init', async (req, res) => {
    exec(`bash ${path.join(__dirname, 'dev/db/init.sh')}`, { cwd: __dirname }, (error, stdout, stderr) => {
        console.log(stdout);
        console.log(stderr);
        if (error !== null) {
            console.log(`exec error: ${error}`);
        }
    });
    res.send('done');
});

app.get('/refresh', async (req, res) => {
    exec(`bash ${path.join(__dirname, 'dev/db/refresh.sh')}`, { cwd: __dirname }, (error, stdout, stderr) => {
        console.log(stdout);
        console.log(stderr);
        if (error !== null) {
            console.log(`exec error: ${error}`);
        }
    });
    res.send('done');
});

app.listen(process.env.PORT || 3000);