const admin = require('firebase-admin');
const functions = require('firebase-functions');
const serviceAccount = require('./pepally-ieu-firebase-adminsdk-kzzor-4008bca5fb.json');

admin.initializeApp({credential: admin.credential.cert(serviceAccount)});
const database = admin.firestore();

function RandomNumber(min, max) {
    return Math.floor(
        Math.random() * (max - min) + min
    )
}

async function sendNotif(topic, payload, options = {}){
    return await admin.messaging().sendToTopic(topic, payload, options);
}

exports.LoveProblems = functions.region('europe-west1').pubsub.schedule('0 0-22/2 * * *').onRun(async () => {
    const LoveProblemsPayLoad = await database.collection('LoveProblems').doc(RandomNumber(0,5).toString()).get();
        const resp = await sendNotif('QuitSmoking', {
            notification: {
                title: LoveProblemsPayLoad.data().Title,
                body: LoveProblemsPayLoad.data().Body
            }
        });
        console.log(resp);
});

exports.QuitSmoking = functions.region('europe-west1').pubsub.schedule('0 0-22/2 * * *').onRun(async () => {
    const QuitSmokingPayLoad = await database.collection('QuitSmoking').doc(RandomNumber(0,5).toString()).get();
    const resp = await sendNotif('QuitSmoking', {
        notification: {
            title: QuitSmokingPayLoad.data().Title,
            body: QuitSmokingPayLoad.data().Body
        }
    });
    console.log(resp);
});

exports.StudyExams = functions.region('europe-west1').pubsub.schedule('0 0-22/2 * * *').onRun(async () => {
    const StudyExamsPayLoad = await database.collection('StudyExams').doc(RandomNumber(0,5).toString()).get();
    const resp = await sendNotif('QuitSmoking', {
        notification: {
            title: StudyExamsPayLoad.data().Title,
            body: StudyExamsPayLoad.data().Body
        }
    });
    console.log(resp);
});
