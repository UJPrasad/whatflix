module.exports = (iocContainer) => {
    
    const {
      express,
      controller
    } = iocContainer;
    const router = express.Router();
  
    router.get('/user/:userId/search', async (req, res) => 
      res.json(await controller.search(iocContainer)({ text: req.query.text,  userId: req.params.userId }))
    );

    router.get('/users', async (req, res) => res.json(await controller.getRecommendations(iocContainer)()));
  
    return router;
}