import React from 'react'
import ReactDOM from 'react-dom'

import { Viewport } from './components/Viewport.jsx'
import { Loader } from './components/Loader.jsx'

class Application extends React.Component ::
  constructor( props ) ::
    super @ props

    this.state = ::
        loading: true

    fetch( this.props.apiRoot + 'data' )
        .then @ res => ::
            res.json().then @ data => ::
                this.setState @ ::
                    loading: false
        .catch @ err => ::
            console.log @ 'fetch err', err

  render() ::
    return @
        <section className="section">
            <div className="container">
                { this.state.loading ? <Loader /> : <Viewport apiRoot={ this.props.apiRoot } /> }
            </div>
        </section>

ReactDOM.render @ <Application apiRoot='http://localhost:1337/' />, document.getElementById @ "app"
