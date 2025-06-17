importScripts("https://www.gstatic.com/firebasejs/9.6.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.6.1/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyBY3aBQoVmhsLU2n3D5xU-kdYsWxyxiYIg",
  authDomain: "uber-ola-and-indriver-cl-fecfa.firebaseapp.com",
  projectId: "uber-ola-and-indriver-cl-fecfa",
  storageBucket: "uber-ola-and-indriver-cl-fecfa.appspot.com",
  messagingSenderId: "659490985048",
  appId: "1:659490985048:web:501ad8d498ea32f4e2262d",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function (payload) {
  console.log("📥 Received background message ", payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
