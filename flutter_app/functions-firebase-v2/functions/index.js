const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.messageAlert = functions.database.ref('device/{deviceId}/device_status').onWrite((snapshot,context) => {
    //console.log(snapshot);
    //console.log(context);
    const data = snapshot.after.val();
    var deviceId  = context.params.deviceId;
    var uid = "";
    var deviceStatus = data.device_status;
    var db = admin.database().ref('/device/'+deviceId);
    db.once("value", function(snapshot){
        //console.log(snapshot.val());
        uid = snapshot.val().user_uid;
        console.log(uid);
        deviceStatus = snapshot.val().device_status;
        var msgPayload = "";
        if(deviceStatus == 1){
            msgPayload = "The motorcycle default";
            console.log("Default");
        }else if(deviceStatus == 2){
            msgPayload = "The motorcycle CrashDown";
            console.log("CrashDown");
        }else if(deviceStatus == 3){
            msgPayload = "The motorcycle Lift";
            console.log("Lift");
        }
        const payload = { 
            notification:{
                title : 'Alarm Tracker',
                body : msgPayload,
                badge : '1',
                sound : 'default'
            }
        };
        admin.database().ref('users/'+uid+'/fcm-token/').once('value', function (data){
            console.log(data.val().token);
           if(data.val()){
                console.log('token available');
                const token = data.val().token;
                return admin.messaging().sendToDevice(token,payload);
            }else{
                console.log('No token available');
            }
        });

    });
});