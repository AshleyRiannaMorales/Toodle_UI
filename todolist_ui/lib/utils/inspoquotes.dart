// List of sample inspirational quotes
final List<String> _quotes = [
  "Believe you can and you're halfway there.",
  "The only way to do great work is to love what you do.",
  "Don't watch the clock; do what it does. Keep going.",
  "Success is not how high you have climbed, but how you make a positive difference to the world.",
  "Your limitation—it's only your imagination.",
  "Push yourself, because no one else is going to do it for you.",
  "Great things never come from comfort zones.",
  "Dream it. Wish it. Do it.",
  "Success doesn’t just find you. You have to go out and get it.",
  "The harder you work for something, the greater you’ll feel when you achieve it."
];

// Function to get the current day of the year
int getDayOfYear(DateTime date) {
  final startOfYear = DateTime(date.year, 1, 1);
  return date.difference(startOfYear).inDays + 1;
}

// Function to get a daily quote
String getDailyQuote() {
  final int dayOfYear = getDayOfYear(DateTime.now());
  return _quotes[dayOfYear % _quotes.length];
}
