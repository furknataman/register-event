/// Helper function to extract localized text from bilingual strings
/// Format: "Turkish / English"
///
/// Example:
/// - Input: "Sunum / Presentation", locale: "tr" → Output: "Sunum"
/// - Input: "Sunum / Presentation", locale: "en" → Output: "Presentation"
/// - Input: "Single Text", locale: "tr" → Output: "Single Text"
String getLocalizedText(String? text, String locale) {
  if (text == null || text.isEmpty) {
    return '';
  }

  // Check if text contains the bilingual separator
  if (text.contains(' / ')) {
    final parts = text.split(' / ');

    // If split was successful and we have both parts
    if (parts.length >= 2) {
      // Turkish is first, English is second
      return locale == 'tr' ? parts[0].trim() : parts[1].trim();
    }
  }

  // If no separator found or split failed, return original text
  return text.trim();
}
