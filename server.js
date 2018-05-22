const express = require( 'express' )
const bodyParser = require( 'body-parser' )

const app = express()

app.use( bodyParser.urlencoded({ extended: true }) )
app.use( express.static( 'public' ) )
//app.set( 'view engine', 'pug' )
//app.set( 'views', 'private/views' )

app.post( '/etstats/webhook', ( req, res ) => {
    console.log( req.body )
})

app.listen( 5300, () => console.log( 'Enemy Territory Stats Processor listening on port 1337 locally.' ) )
