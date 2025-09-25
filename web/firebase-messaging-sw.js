importScripts("https://www.gstatic.com/firebasejs/12.3.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/12.3.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyBKb6rC6eXugh9Civd0nKnY8VuCtjTVvXI",
    authDomain: "guff-6e92b.firebaseapp.com",
    projectId: "guff-6e92b",
    storageBucket: "guff-6e92b.firebasestorage.app",
    messagingSenderId: "447061565088",
    appId: "1:447061565088:web:cc19808f2631a58126f3c5",
    measurementId: "G-P110BEM43L"
});

const messaging = firebase.messaging();

// This is the magic: background listener
messaging.onBackgroundMessage(function (payload) {
    console.log("Received background message ", payload);
    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});