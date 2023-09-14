/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const cors = require('cors')({ origin: true });

const admin = require('firebase-admin');
admin.initializeApp();

exports.getData = onRequest((request, response) => {
  cors(request, response, async () => {
    //console.log('start');
    const uid = request.body['data']['uid'];
    const docRef = await admin.firestore().collection('scores').doc(uid).get().then((doc) => {
      if(doc.exists) {
        //console.log('Document data:', doc.data());
        return doc.data();
      } else {
        //console.log('No such document!');
        return null;
      }
    });

    response.status(200).json({ data: { 'data': docRef } });
  });
});

exports.sortAndTrim = onRequest((request, response) => {
  cors(request, response, () => {
    //console.log('start');
    const inputArray = request.body['data']['text'];
    //console.log('inputArray : ' + inputArray);
    const resultArray = inputArray.sort((a, b) => b - a);
    
    if (resultArray.length > 10) {
      resultArray.splice(10, resultArray.length - 10); 
    }

    //console.log('resultArray : ' + resultArray);
    response.status(200).json({ data: { 'text': resultArray } });
  });
});

exports.getTop10 = onRequest((request, response) => {
  cors(request, response, async () => {
    //console.log('start');
    const uid = request.body['data']['uid'];
    const docRef = await admin.firestore().collection('scores').doc(uid).get().then((doc) => {
      if(doc.exists) {
        //console.log('Document data:', doc.data());
        const inputArray = doc.data()['best'];
        const resultArray = inputArray.sort((a, b) => b - a);
        if (resultArray.length > 10) {
          resultArray.splice(10, resultArray.length - 10); 
        }
        return resultArray;
      } else {
        console.log('No such document!');
        return null;
      }
    });

    response.status(200).json({ data: { 'data': docRef } });
  });
});


