<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.hibernateassessment.AssessmentKeywords" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.regex.Pattern" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(405);
        response.setHeader("Allow", "POST");
    }

    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String summary = request.getParameter("summary");
    username = username == null ? "" : username;
    email = email == null ? "" : email;
    summary = summary == null ? "" : summary;

    List<String> errors = new ArrayList<>();
    if (!Pattern.matches("^[A-Z][A-Za-z0-9_]{0,8}$", username)) {
        errors.add("Username must be 1–9 characters, start with an uppercase English letter (A–Z), and contain only English letters, digits, or underscores.");
    }
    if (!Pattern.matches("(?i)^[^\\s@]+@gmail\\.com$", email)) {
        errors.add("Email must have a nonempty local part, contain no spaces, and end with @gmail.com. This checks the format only; it does not confirm that the mailbox exists.");
    }
    if (summary.isBlank()) {
        errors.add("Summary cannot be empty or contain only whitespace. Write what you learned from the Hibernate guide.");
    }

    int matchedKeywords = summary.isBlank() ? 0 : AssessmentKeywords.countMatches(summary);
    double keywordPercentage = matchedKeywords / 50.0 * 100.0;
    double marks = Math.round((matchedKeywords / 50.0 * 10.0) * 10.0) / 10.0;
    boolean summaryPassed = matchedKeywords >= 35;
    if (!summary.isBlank() && !summaryPassed) {
        errors.add("Your summary needs improvement. Please revisit the Hibernate learning page, revise the important concepts, and try again. You matched "
                + matchedKeywords + " of 50 concepts; at least 35 are needed to pass.");
    }
    boolean assessmentPassed = errors.isEmpty() && summaryPassed;
%>
<% if (assessmentPassed) { %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Preparing Your Results | Hibernate Learning Assessment</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<main class="container narrow-content page-content">
    <section class="content-card centered">
        <h1>Assessment verified</h1>
        <p id="handoff-status" role="status">Your results are ready. Opening the results page…</p>
        <p id="handoff-error" class="notice notice-error" role="alert" hidden>
            Your browser could not keep the results for this tab. Please enable session storage and submit the assessment again.
        </p>
        <a class="button button-secondary" href="test.html">Return to the assessment</a>
    </section>
</main>
<script>
    "use strict";
    const assessmentResult = {
        username: <%=AssessmentKeywords.toJsonString(username)%>,
        email: <%=AssessmentKeywords.toJsonString(email)%>,
        summary: <%=AssessmentKeywords.toJsonString(summary)%>,
        matchedKeywords: <%=matchedKeywords%>,
        totalKeywords: 50,
        keywordPercentage: <%=keywordPercentage%>,
        marks: <%=marks%>,
        passed: true
    };
    try {
        sessionStorage.setItem("hibernateAssessmentResult", JSON.stringify(assessmentResult));
        window.location.replace("display.html");
    } catch (error) {
        document.getElementById("handoff-status").textContent = "The assessment passed, but your browser could not open the results page.";
        document.getElementById("handoff-error").hidden = false;
        console.error("Could not hand assessment results to the results page.", error);
    }
</script>
</body>
</html>
<% } else { %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Review Your Submission | Hibernate Learning Assessment</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<header class="site-header">
    <div class="container header-inner">
        <a class="brand" href="about.html">Hibernate <span>Learning Lab</span></a>
        <nav aria-label="Main navigation"><a href="about.html">Learn</a><a href="test.html">Assessment</a></nav>
    </div>
</header>
<main class="container narrow-content page-content">
    <section class="hero hero-compact">
        <p class="eyebrow">Submission not accepted</p>
        <h1>Review your submission</h1>
        <p class="hero-copy">Correct the items below, then submit again. Your entered values have been kept so you can edit them.</p>
    </section>
    <section class="content-card">
        <div class="notice notice-error" role="alert">
            <h2>Please make these changes</h2>
            <ul>
                <% for (String error : errors) { %>
                <li><%=AssessmentKeywords.escapeHtml(error)%></li>
                <% } %>
            </ul>
        </div>
        <div class="score-summary">
            <p><strong>Matched concepts:</strong> <%=matchedKeywords%> / 50</p>
            <p><strong>Keyword match:</strong> <%=String.format(java.util.Locale.ROOT, "%.0f", keywordPercentage)%>%</p>
            <p><strong>Current marks:</strong> <%=String.format(java.util.Locale.ROOT, "%.1f", marks)%> / 10</p>
        </div>
        <form action="verify.jsp" method="post" accept-charset="UTF-8">
            <div class="form-field">
                <label for="username">Username</label>
                <input id="username" name="username" type="text" value="<%=AssessmentKeywords.escapeHtml(username)%>" required>
            </div>
            <div class="form-field">
                <label for="email">Gmail address</label>
                <input id="email" name="email" type="email" value="<%=AssessmentKeywords.escapeHtml(email)%>" required>
            </div>
            <div class="form-field">
                <label for="summary">Your Hibernate summary</label>
                <textarea id="summary" name="summary" rows="10" required><%=AssessmentKeywords.escapeHtml(summary)%></textarea>
            </div>
            <div class="form-actions">
                <a class="button button-secondary" href="about.html">Return to About Hibernate</a>
                <a class="button button-secondary" href="test.html">Start a fresh test</a>
                <button class="button button-primary" type="submit">Submit Again</button>
            </div>
        </form>
    </section>
</main>
<footer class="site-footer"><div class="container">Correct your details or revisit the guide before trying again.</div></footer>
</body>
</html>
<% } %>
