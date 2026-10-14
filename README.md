# Hibernate Learning Assessment

A small beginner-friendly Java web application that teaches Hibernate, accepts a learner's summary, checks the submission on the server, and displays the result. The assessment itself uses no database.

## Project structure

```text
HibernateAssessment/
├── pom.xml
├── README.md
└── src/
    └── main/
        ├── java/com/example/hibernateassessment/
        │   └── AssessmentKeywords.java
        ├── resources/
        │   └── assessment-keywords.txt
        └── webapp/
            ├── about.html
            ├── test.html
            ├── verify.jsp
            ├── display.html
            ├── css/style.css
            └── js/
                ├── test.js
                └── display.js
```

### What each file does

- `about.html` teaches the Hibernate and ORM concepts used by the assessment.
- `test.html` collects a username, Gmail address, and written summary in a POST form.
- `verify.jsp` validates all fields on the server, counts distinct matching concepts, calculates the score, and preserves submitted values when showing errors. On success it safely transfers the result to the browser tab and opens `display.html`.
- `display.html` is the final results page. Its JavaScript uses text-only DOM properties to render results and shows a helpful page if the tab has no valid assessment.
- `assessment-keywords.txt` is the single authoritative list of exactly 50 distinct assessment keywords.
- `AssessmentKeywords.java` loads and validates that list, performs case-insensitive whole-word/whole-phrase matching, and safely encodes output.
- `js/test.js` points submissions opened from a local `file://` URL to the default local Tomcat URL; normal deployed pages submit to `verify.jsp` in the current context. Server validation remains authoritative.
- `js/display.js` reads the successful assessment stored in this tab's session storage and renders it without interpreting user input as HTML.
- `css/style.css` provides the shared responsive styling.
- `pom.xml` builds a deployable WAR and declares the Jakarta Servlet API used by Tomcat.

## Requirements

- JDK 17 or newer (the source is compiled for Java 11 bytecode).
- Apache Tomcat 11.x. Tomcat 11 uses the Jakarta namespace and Servlet 6.1.
- Maven 3.8 or newer.
- VS Code. The Java Extension Pack and a Maven extension are helpful but not required.

The assessment only needs Tomcat and a browser. It does not connect to a database or require Hibernate libraries. Hibernate examples on the learning page are for study; running those examples in a separate application would require Hibernate, a JDBC driver, and a configured database.

## Build and run

1. Open the `HibernateAssessment` folder in VS Code.
2. In the VS Code terminal, run `mvn clean package`.
3. Copy `target\HibernateAssessment.war` into Tomcat's `webapps` folder.
4. Start Tomcat using its normal startup command or Windows service and wait for the WAR to deploy.
5. Open **http://localhost:8082/HibernateAssessment/about.html** (the default connector port in the installed Tomcat configuration for this workspace).

If Tomcat is configured to use a different port or deployment context, adjust the URL accordingly. The context path above comes from the WAR filename. When `test.html` is opened directly from disk, its form targets `http://localhost:8082/HibernateAssessment/verify.jsp`; deployed pages submit to `verify.jsp` in the current application context.

`verify.jsp` must be run by a JSP-capable Tomcat server. It cannot execute by opening the JSP file from disk or by using VS Code Live Server. Live Server only serves static files; it does not compile JSP or run Java server-side validation.

## Data flow and assessment

1. The learner studies `about.html` and follows its test button to `test.html`.
2. `test.html` posts `username`, `email`, and `summary` to `verify.jsp`.
3. `verify.jsp` applies the required username and Gmail format rules, rejects an empty summary, and uses `AssessmentKeywords` to compare the summary with the canonical 50-entry file.
4. Matching is case-insensitive, normalizes repeated whitespace, requires whole-word or whole-phrase boundaries, and counts each listed concept at most once.
5. The summary passes with 35 or more matches. The mark is `(matchedKeywords / 50.0) * 10`, rounded to one decimal place.
6. A passing result is JSON-encoded safely into the server response, stored in this tab's `sessionStorage`, and opened in `display.html`. The summary is not placed in a URL. The results page writes all user data with `textContent`, so markup in a submitted summary is displayed as text.
7. Invalid submissions remain on the verification page with specific messages and escaped form values. Users can return to either learning or assessment pages.

## Test checklist

- [ ] Valid uppercase username and Gmail address with 35 or more matching concepts passes.
- [ ] Lowercase-first username is rejected.
- [ ] Username with 10 or more characters is rejected.
- [ ] An address ending in `@yahoo.com` is rejected.
- [ ] Empty username, email, and summary are each rejected with useful messages.
- [ ] A summary matching fewer than 35 distinct concepts is not passed and preserves entered values.
- [ ] A summary matching exactly 35 concepts passes with 7.0 / 10.
- [ ] A summary containing all 50 concepts passes with 10.0 / 10.
- [ ] Repeated concepts do not increase the match count.
- [ ] A keyword inside a longer unrelated word does not count (for example, `JavaScript` does not count as `Java`).
- [ ] HTML or JavaScript entered in the summary is displayed as text, not executed.
- [ ] Opening `display.html` without a successful assessment shows the no-results message.
- [ ] Navigate between learning, assessment, and results pages using their links and buttons.
- [ ] Build and deploy the WAR to Tomcat 11, then use the local URL above.
