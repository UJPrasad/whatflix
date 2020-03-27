const movieRouter = require("../components/movies");

module.exports = (iocContainer) => {

    const { express } = iocContainer;

    const router = express.Router();

    router.use('/movies', movieRouter(iocContainer));
    
    return router;
}