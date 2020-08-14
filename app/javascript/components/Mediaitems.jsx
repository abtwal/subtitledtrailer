import React from "react";
import PropTypes from "prop-types";

class Mediaitems extends React.Component {
  render () {
    return (
      <React.Fragment>
        Mediaitems:
        {this.props.mediaitems.map(mediaitem => (
          <li key={mediaitem.id}>{`${mediaitem.title}`}</li>
        ))}
      </React.Fragment>
    );
  }
}

Mediaitems.propTypes = {
  mediaitems: PropTypes.array
};

export default Mediaitems;
