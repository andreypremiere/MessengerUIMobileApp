class Token {
  final String? _token;

  Token._(String this._token);

  String? get token => _token;

  factory Token.fromJSON(Map<String, dynamic> jsonObj) {
    return Token._(jsonObj['token']);
  }
}
