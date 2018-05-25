import React from 'react'

export class Loader extends React.Component ::
    render() ::
        return @
            <div className="modal is-active">
                <div className="modal-background" />
                <div className="modal-content">
                    <img src="/img/loader.gif" />
                </div>
            </div>
