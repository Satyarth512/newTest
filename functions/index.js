const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotifications = functions.https.onCall( (data, ctx) => {
  try {
    admin.messaging().sendToTopic("topic", {
      notification: {
        title: "Message Received",
        body: "Detail data received",
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    });
    return "Notifications Send Successfully";
  } catch (e) {
    return "Notification Not Sent";
  }
});

