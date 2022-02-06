const express = require('express')
const actions = require('../methods/actions')
const router = express.Router()
const multer = require('multer');

// set up multer for storing uploaded files
var storage = multer.diskStorage({
    destination: (req, file, callback) => {
        callback(null, './assets/books')
    },
    filename: (req, file, callback) => {
        callback(null, req.body.bookId+'.png')
    }
});
  
var upload = multer({ storage: storage });

var storeBookImage = multer.diskStorage({
    destination: (req, file, callback) => {
        callback(null, './assets/books')
    },
    filename: (req, file, callback) => {
        callback(null, req.body.id+'.png')
    }
});
  
var uploadBookImage = multer({ storage: storeBookImage });

router.get('/', (req, res) => {
    res.send('Hello World')
})

router.get('/dashboard', (req, res) => {
    res.send('Dashboard')
})

//@desc Adding new user
//@route POST /adduser
router.post('/adduser', actions.addNew)

//@desc Authenticate a user
//@route POST /authenticate
router.post('/authenticate', actions.authenticate)

//@desc Change Password of a user
//@route POST /changePassword
router.post('/changePassword', actions.changePassword)

//@desc Adding new book
//@route POST /addBook
router.post('/addBook', uploadBookImage.single('image'), actions.addBook)

//@desc Get Book Details
//@route POST /getBookDetails
router.post('/getBookDetails', actions.getBookDetails)

//@desc Get Recommended Book
//@route POST /getRecommendBook
router.post('/getRecommendBook', actions.getRecommendBook)

//@desc Get All Books
//@route POST /getAllBook
router.post('/getAllBooks', actions.getAllBooks)

//@desc Get Book Image
//@route POST /getBookImage
router.post('/getBookImage', actions.getBookImage)

//@desc Adding book to current users favourites
//@route POST /addToFavourites
router.post('/addToFavourites', actions.addToFavourites)

//@desc Removing book from current users favourites
//@route POST /removeFromFavourites
router.post('/removeFromFavourites', actions.removeFromFavourites)

//@desc Adding book to current users WishList
//@route POST /addToWishList
router.post('/addToWishList', actions.addToWishList)

//@desc Removing book from current users WishList
//@route POST /removeFromWishList
router.post('/removeFromWishList', actions.removeFromWishList)

//@desc Update User's Cart
//@route POST /updateCart
router.post('/updateCart', actions.updateCart)

//@desc Update User's Reward
//@route POST /addReward
router.post('/addReward', actions.addReward)

//@desc Adding new book image
//@route POST /addBookImage
router.post('/addBookImage', upload.single('img'), actions.addBookImage.bind(actions))

//@desc Get info on a user
//@route GET /getinfo
router.get('/getinfo', actions.getinfo)

module.exports = router