'use strict';

module.exports = {
  setUpDatabase: async(event, context, callback) => {
    /* SET UP INITIAL USER ROW WITH EMPTY DATA */
    const userId = event.userName;
    console.log(userId);
    callback(null, event);
  }
}