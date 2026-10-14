"use strict";

document.addEventListener("DOMContentLoaded", function () {
    if (window.location.protocol !== "file:") {
        return;
    }

    const form = document.querySelector("form");
    const serverNote = document.getElementById("server-note");
    if (form) {
        form.action = "http://localhost:8082/HibernateAssessment/spring-jdbc/verify.jsp";
    }
    if (serverNote) {
        serverNote.textContent = " Tomcat must be running at localhost:8082; verification cannot run when this page is opened directly from disk.";
    }
});
