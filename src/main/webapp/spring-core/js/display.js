"use strict";

document.addEventListener("DOMContentLoaded", function () {
    const resultsElement = document.getElementById("results");
    const noResultsElement = document.getElementById("no-results");
    let result;

    try {
        const storedResult = sessionStorage.getItem("springCoreAssessmentResult");
        if (storedResult) {
            result = JSON.parse(storedResult);
        }
    } catch (error) {
        console.error("Could not read the Spring Core assessment results from this browser tab.", error);
    }

    const isValidResult = result
        && typeof result.username === "string"
        && typeof result.email === "string"
        && typeof result.summary === "string"
        && Number.isInteger(result.matchedKeywords)
        && result.matchedKeywords >= 0
        && result.matchedKeywords <= 50
        && result.totalKeywords === 50
        && typeof result.keywordPercentage === "number"
        && typeof result.marks === "number"
        && typeof result.passed === "boolean"
        && result.passed === (result.matchedKeywords >= 35);

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

    const statusBanner = document.getElementById("status-banner");
    const feedback = document.getElementById("result-feedback");
    if (result.passed) {
        statusBanner.textContent = "PASSED";
        statusBanner.classList.add("status-passed");
        feedback.textContent = result.matchedKeywords >= 45
            ? "Excellent work! You demonstrated a strong understanding of Spring Core. Keep practicing with dependency injection and bean configuration."
            : "Good work! You passed the assessment. Continue practicing and revisit any topics you would like to strengthen.";
    } else {
        statusBanner.textContent = "KEEP LEARNING";
        statusBanner.classList.add("status-improve");
        feedback.textContent = "Your summary matched " + result.matchedKeywords
            + " of 50 concepts; at least 35 are needed to pass. Revisit the learning page, strengthen your summary with distinct Spring Core ideas, and try again.";
    }

    resultsElement.hidden = false;
});
