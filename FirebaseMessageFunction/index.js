const admin = require('firebase-admin');
const functions = require('firebase-functions');
const serviceAccount = require('./pepally-ieu-firebase-adminsdk-kzzor-4008bca5fb.json');

admin.initializeApp({credential: admin.credential.cert(serviceAccount)});
const database = admin.firestore();

async function sendNotif(topic, payload, options = {}){
    // https://www.techotopia.com/index.php/Sending_Firebase_Cloud_Messages_from_a_Node.js_Server
    return await admin.messaging().sendToTopic(topic, payload, options);
}

exports.LoveProblems = functions.region('us-central1').pubsub.schedule('0 */6 * * *').onRun(async () => {
    const LoveProblemsPayLoad = await database.collection('LoveProblems').doc('0').get();
        const resp = await sendNotif('QuitSmoking', {
            notification: {
                title: LoveProblemsPayLoad.data().Title,
                body: LoveProblemsPayLoad.data().Body
            }
        });
        console.log(resp);
});

exports.QuitSmoking = functions.region('us-central1').pubsub.schedule('0 */6 * * *').onRun(async () => {
    const QuitSmokingPayLoad = await database.collection('QuitSmoking').doc('0').get();
    const resp = await sendNotif('QuitSmoking', {
        notification: {
            title: QuitSmokingPayLoad.data().Title,
            body: QuitSmokingPayLoad.data().Body
        }
    });
    console.log(resp);
});

exports.StudyExams = functions.region('us-central1').pubsub.schedule('0 */6 * * *').onRun(async () => {
    const StudyExamsPayLoad = await database.collection('StudyExams').doc('0').get();
    const resp = await sendNotif('QuitSmoking', {
        notification: {
            title: StudyExamsPayLoad.data().Title,
            body: StudyExamsPayLoad.data().Body
        }
    });
    console.log(resp);
});
