const sql = require('./sql')
const pgp = require('pg-promise')();

const search = ({ db }) => ({ options, inputs }) => 
    db.oneOrNone(`${sql.baseFilter[pgp.as.ctf.toPostgres]()} ${options}`, { ...inputs });

const getRecommendations = ({ db }) => () => db.any(sql.recommendations, {});

module.exports = {
    search,
    getRecommendations
};