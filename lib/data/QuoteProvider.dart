
import 'dart:math';

import 'package:streak/models/Quote.dart';

class QuoteProvider {
  var _random = new Random();


  Quote random() {
    var quoteIndex = _random.nextInt(quotes.length);
    var attributionIndex = _random.nextInt(attributions.length);
    var continueIndex = _random.nextInt(continueLabels.length);
    return Quote(quotes[quoteIndex],
        attributions[attributionIndex],
        continueLabels[continueIndex]);
  }

  var quotes = [
    "You did it!",
    "Great Job. Keep Going!",
    "You go girl!",
    "You can do anything.",
    "Repetition is the key to success.",
    "Another step towards mastery.",
    "You did good.",
    "You're on a roll.",
    "Nothing can stop you.",
  ];

  var attributions = [
    "Barack Obama",
    "The Dalai Lama",
    "Psalm 14",
    "Psalm 28",
    "Jesus",
    "Buddha",
    "Luke 23:56",
    "Deuteronomy 4:12",
    "Corinthians 2:18",
    "Sun Zu",
    "Queen Elizabeth II",
    "Stephen Fry",
    "Gandalf the Grey",
    "Gandalf the White",
    "Abraham Lincoln",
    "Angela Merkel",
    "Oprah Winfrey",
    "John F. Kennedy",
    "Kim Kardashian",
    "Al Gore",
    "Joe Biden",
    "William Shakespeare",
    "Mark Twain",
    "Voltaire",
    "Charles Dickens",
    "Oscar Wilde",
    "Johann Wolfgang von Goethe",
    "Edgar Allan Poe",
    "Dante Alighieri",
    "Muhammad",
    "Aristotle",
    "Socrates",
    "Alexander the Great",
    "Julius Caesar",
    "Martin Luther",
    "Albert Einstein",
    "Plato",
    "Homer",
    "Jane Austen",
    "Lord Byron",
    "Virgil",
    "Leo Tolstoy",
    "Emily Dickinson",
    "Fyodor Dostoyevsky",
    "T S Eliot"
  ];

  var continueLabels = [
    "I know. I'm the best.",
    "I know, I'm great.",
    "Let's keep going.",
    "Ok",
    "Continue",
    "Just let me relax.",
    "I couldn't have done it without you."
  ];
}