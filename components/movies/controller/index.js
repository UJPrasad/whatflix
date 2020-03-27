const searchBuilder = require('./searchBuilder');

const search = ({ db, dao }) => ({ userId, text }) => {
    const { options, inputs } = searchBuilder({ userId, text });
    return dao.search({ db })({ options, inputs });
}

const getRecommendations = ({ db, dao }) => () => dao.getRecommendations({ db })();

module.exports = {
    search,
    getRecommendations
}