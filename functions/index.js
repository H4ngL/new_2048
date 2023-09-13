/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const { onCall } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.sortAndTrimArray = onRequest((request, response) => {
//   const inputArray = request.body;

//   const resultArray = sortAndTrim(inputArray);
//   response.status(200).json(resultArray);
// });


exports.sortAndTrim = onRequest({ cors: [/firebase\.com$/, "flutter.com"] }, (request, response) => {
  const inputArray = request.body['data']['text'];
  const resultArray = inputArray.sort((a, b) => b - a);

  if (resultArray.length > 10) {
    resultArray.splice(10, resultArray.length - 10); 
  }

  response.status(200).json({ data: { 'text': resultArray } });
});



