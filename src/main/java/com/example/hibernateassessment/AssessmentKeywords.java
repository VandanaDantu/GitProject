package com.example.hibernateassessment;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.regex.Pattern;

public final class AssessmentKeywords {
    private static final List<String> KEYWORDS = loadKeywords();

    private AssessmentKeywords() {
    }

    public static List<String> getKeywords() {
        return KEYWORDS;
    }

    public static int countMatches(String summary) {
        String normalizedSummary = normalize(summary);
        int matchCount = 0;

        for (String keyword : KEYWORDS) {
            String normalizedKeyword = normalize(keyword);
            Pattern wholePhrase = Pattern.compile(
                    "(?<![\\p{L}\\p{N}_])" + Pattern.quote(normalizedKeyword)
                            + "(?![\\p{L}\\p{N}_])");
            if (wholePhrase.matcher(normalizedSummary).find()) {
                matchCount++;
            }
        }

        return matchCount;
    }

    public static String toJsonArray() {
        StringBuilder json = new StringBuilder("[");
        for (int index = 0; index < KEYWORDS.size(); index++) {
            if (index > 0) {
                json.append(',');
            }
            json.append(toJsonString(KEYWORDS.get(index)));
        }
        return json.append(']').toString();
    }

    public static String toJsonString(String value) {
        StringBuilder json = new StringBuilder("\"");
        for (int index = 0; index < value.length(); index++) {
            char character = value.charAt(index);
            switch (character) {
                case '"':
                    json.append("\\\"");
                    break;
                case '\\':
                    json.append("\\\\");
                    break;
                case '\b':
                    json.append("\\b");
                    break;
                case '\f':
                    json.append("\\f");
                    break;
                case '\n':
                    json.append("\\n");
                    break;
                case '\r':
                    json.append("\\r");
                    break;
                case '\t':
                    json.append("\\t");
                    break;
                case '<':
                    json.append("\\u003c");
                    break;
                case '>':
                    json.append("\\u003e");
                    break;
                case '&':
                    json.append("\\u0026");
                    break;
                case '\u2028':
                    json.append("\\u2028");
                    break;
                case '\u2029':
                    json.append("\\u2029");
                    break;
                default:
                    if (character < 0x20) {
                        json.append(String.format("\\u%04x", (int) character));
                    } else {
                        json.append(character);
                    }
            }
        }
        return json.append('"').toString();
    }

    public static String escapeHtml(String value) {
        StringBuilder escaped = new StringBuilder();
        for (int index = 0; index < value.length(); index++) {
            char character = value.charAt(index);
            switch (character) {
                case '&':
                    escaped.append("&amp;");
                    break;
                case '<':
                    escaped.append("&lt;");
                    break;
                case '>':
                    escaped.append("&gt;");
                    break;
                case '"':
                    escaped.append("&quot;");
                    break;
                case '\'':
                    escaped.append("&#39;");
                    break;
                default:
                    escaped.append(character);
            }
        }
        return escaped.toString();
    }

    private static String normalize(String text) {
        return text.toLowerCase(Locale.ROOT).replaceAll("(?U)\\s+", " ").strip();
    }

    private static List<String> loadKeywords() {
        List<String> keywords = new ArrayList<>();
        Set<String> distinctKeywords = new HashSet<>();
        try (InputStream input = AssessmentKeywords.class.getResourceAsStream("/assessment-keywords.txt")) {
            if (input == null) {
                throw new IllegalStateException("The assessment keyword resource is missing.");
            }
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(input, StandardCharsets.UTF_8))) {
                String keyword;
                while ((keyword = reader.readLine()) != null) {
                    String trimmedKeyword = keyword.trim();
                    if (trimmedKeyword.isEmpty()
                            || !distinctKeywords.add(trimmedKeyword.toLowerCase(Locale.ROOT))) {
                        throw new IllegalStateException("The assessment keyword resource has an empty or duplicate entry.");
                    }
                    keywords.add(trimmedKeyword);
                }
            }
        } catch (IOException exception) {
            throw new IllegalStateException("The assessment keyword resource could not be read.", exception);
        }
        if (keywords.size() != 50) {
            throw new IllegalStateException("The assessment requires exactly 50 distinct keywords.");
        }
        return Collections.unmodifiableList(keywords);
    }
}
