"use strict";

document.addEventListener("DOMContentLoaded", function () {
    const resultsElement = document.getElementById("results");
    const noResultsElement = document.getElementById("no-results");
    let result;

    try {
        const storedResult = sessionStorage.getItem("hibernateAssessmentResult");
        if (storedResult) {
            result = JSON.parse(storedResult);
        }
    } catch (error) {
        console.error("Could not read the assessment results from this browser tab.", error);
    }

    const isValidResult = result
        && typeof result.username === "string"
        && typeof result.email === "string"
        && typeof result.summary === "string"
        && Number.isInteger(result.matchedKeywords)
        && result.matchedKeywords >= 35
        && result.matchedKeywords <= 50
        && result.totalKeywords === 50
        && typeof result.keywordPercentage === "number"
        && typeof result.marks === "number"
        && result.passed === true;

    if (!isValidResult) {
        noResultsElement.hidden = false;
        return;
    }

    document.getElementById("result-username").textContent = result.username;
    document.getElementById("result-email").textContent = result.email;
    document.getElementById("result-matches").textContent = result.matchedKeywords + " / " + result.totalKeywords;
    document.getElementById("result-percentage").textContent = result.keywordPercentage.toFixed(0) + "%";
    document.getElementById("result-marks").textContent = result.marks.toFixed(1) + " / 10";
    document.getElementById("result-summary").textContent = result.summary;
    document.getElementById("result-feedback").textContent = result.matchedKeywords >= 45
        ? "Excellent work! You demonstrated a strong understanding of the Hibernate concepts. Keep practicing with real entity mappings and queries."
        : "Good work! You demonstrated a good understanding of the Hibernate concepts. Continue practicing and revisit any topics you would like to strengthen.";

    const statusBanner = document.getElementById("status-banner");
    statusBanner.textContent = "PASSED";
    statusBanner.classList.add("status-passed");
    resultsElement.hidden = false;
});
