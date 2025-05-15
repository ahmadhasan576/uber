// firebase-messaging-sw.js

importScripts("https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyBY3aBQoVmhsLU2n3D5xU-kdYsWxyxiYIg",
  authDomain: "uber-ola-and-indriver-cl-fecfa.firebaseapp.com",
  projectId: "uber-ola-and-indriver-cl-fecfa",
  storageBucket: "uber-ola-and-indriver-cl-fecfa.appspot.com",
  messagingSenderId: "659490985048",
  appId: "1:659490985048:web:b74b97f03dc78ba5e2262d"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('📩 Received background message: ', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/icon-192.png' // أو أيقونة إشعار مخصصة
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
