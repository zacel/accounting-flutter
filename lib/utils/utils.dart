 num tryParse(String input) {
String source = input.trim();
return int.tryParse(source) ?? double.tryParse(source);
}