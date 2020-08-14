import React from "react";
import PropTypes from "prop-types";

class Mediaitems extends React.Component {
  render () {
    return (
      <div className="mediaitems">
        Mediaitems:
        {this.props.mediaitems.map(mediaitem => (
          <li className="item" key={mediaitem.id}>{`${mediaitem.title}`}</li>
        ))}
      </div>
    );
  }
}

Mediaitems.propTypes = {
  mediaitems: PropTypes.array
};

export default Mediaitems;
