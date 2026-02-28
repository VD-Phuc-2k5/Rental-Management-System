class CollapseText {
  CollapseText._();

  static int getWordCount(String text) {
    return text.trim().split(RegExp(r'\s+')).length;
  }

  static String getTruncatedText(String text, int wordLimit) {
    final words = text.trim().split(RegExp(r'\s+'));
    if (words.length <= wordLimit) {
      return text;
    }
    return '${words.take(wordLimit).join(' ')}...';
  }
}
