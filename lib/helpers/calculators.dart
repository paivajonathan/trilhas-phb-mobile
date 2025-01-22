int calculateAge(DateTime birthDate) {
  final DateTime today = DateTime.now();

  int age = today.year - birthDate.year;

  // Subtracts age if the birthday hasn't happened yet this year
  if ((today.month < birthDate.month) || 
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age -= 1;
  }

  return age;
}
