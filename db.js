const pgp = require('pg-promise')();
const dotenv = require('dotenv');
dotenv.config();
const db = pgp(`postgres://${process.env.DB_USER}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}:5432/${process.env.DB_NAME}`);

module.exports = db;