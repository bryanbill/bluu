List urlLink(String text) {
  List url = [];
  RegExp exp =
      new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
  Iterable<RegExpMatch> matches = exp.allMatches(text);

  matches.forEach((match) {
    url.add(text.substring(match.start, match.end));
  });
  return url;
}
