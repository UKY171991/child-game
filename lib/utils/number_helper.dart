String intToWords(int number) {
  if (number < 0) return "minus ${intToWords(-number)}";
  if (number == 0) return "zero";
  
  if (number < 20) {
    return const [
      "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
      "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
    ][number];
  }
  
  if (number < 100) {
    List<String> tens = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"];
    String tenStr = tens[number ~/ 10];
    String unitStr = number % 10 > 0 ? " ${intToWords(number % 10)}" : "";
    return "$tenStr$unitStr";
  }
  
  if (number < 1000) {
    return "${intToWords(number ~/ 100)} hundred${number % 100 > 0 ? " ${intToWords(number % 100)}" : ""}";
  }
  
  return number.toString(); // Fallback for larger numbers
}
