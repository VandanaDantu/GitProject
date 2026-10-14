"use strict";

document.addEventListener("DOMContentLoaded", function () {
    if (window.location.protocol === "file:") {
        const form = document.querySelector("form");
        const serverNote = document.getElementById("server-note");
        if (form) {
            form.action = "http://localhost:8082/HibernateAssessment/verify.jsp";
        }
        if (serverNote) {
            serverNote.textContent = " The form is ready, but verification requires the app to be running on Tomcat at localhost:8082.";
        }
    }
});
