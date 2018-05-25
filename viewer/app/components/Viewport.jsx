import React from 'react'
import { Loader } from './Loader.jsx'

export class Viewport extends React.Component ::
  constructor( props ) ::
    super @ props

    this.state = ::
        loading: true
        , data: { mapname: '', stats: {} }

    this.sse = new EventSource @ this.props.apiRoot + 'sse'

    this.sse.addEventListener @ 'message', e => ::
        let data = JSON.parse @ e.data
        console.log @ 'sse got data', data
    , false

    this.sse.addEventListener @ 'open', e => ::
        console.log @ 'sse connection opened'
    , false

    this.sse.addEventListener @ 'error', e => ::
        if e.target.readyState == EventSource.CLOSED ::
            console.log @ 'sse disconnected'
        else if e.target.readyState == EventSource.CONNECTING ::
            console.log @ 'sse connecting...'
        else ::
            console.log @ 'browser does not support sse'
    , false

    fetch( this.props.apiRoot + 'data-lagged' )
        .then @ res => ::
            res.json().then @ data => ::
                console.log @ data
                this.setState @ ::
                    loading: false
                    , data: data
        .catch @ err => ::
            console.log @ 'fetch err', err

  render() ::
    if this.state.loading ::
        return @ <Loader />
    else ::
        return @
            <section className="section">
                <nav className="navbar is-light">
                    <div className="navbar-start">
                        <div className="navbar-item">
                            <div className="field has-addons">
                                <p className="control">
                                    <input className="input" type="text" placeholder="Find a player" />
                                </p>
                                <p className="control">
                                    <button className="button">Search</button>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div className="navbar-end">
                        <p className="navbar-item"><strong>Leaderboard</strong></p>
                        <p className="navbar-item"><a>Previous LAN Parties</a></p>
                        <p className="navbar-item"><a>Data Log</a></p>
                        <p className="navbar-item"><a className="button is-info">Begin New LAN Party</a></p>
                    </div>
                </nav>

                <section className="hero is-dark is-bold">
                    <div className="hero-body">
                        <h1 className="title">LAN Party 24 May 2018</h1>
                        <h2 className="subtitle">Leaderboard</h2>
                    </div>
                </section>

                <table className="table is-fullwidth">
                    <thead>
                        <tr>
                            <th></th>
                            <th>Overall</th>
                            <th>Previous Match ({ this.state.data.mapname })</th>
                            <th>2 Matches Ago  ({ this.state.data.mapname })</th>
                            <th>3 Matches Ago  ({ this.state.data.mapname })</th>
                            <th>4 Matches Ago  ({ this.state.data.mapname })</th>
                        </tr>
                    </thead>
                    <tbody>
                        { Object.keys( this.state.data.stats ).map @ stat => ::
                            return @
                                <tr>
                                    <th>{ stat }</th>
                                    <td>{ this.state.data.stats[stat] }</td>
                                    <td>{ this.state.data.stats[stat] }</td>
                                    <td>{ this.state.data.stats[stat] }</td>
                                    <td>{ this.state.data.stats[stat] }</td>
                                    <td>{ this.state.data.stats[stat] }</td>
                                </tr>
                        }
                    </tbody>
                </table>
            </section>
