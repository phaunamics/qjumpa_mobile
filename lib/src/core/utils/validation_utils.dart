class ValidationUtils {
  static String? isValidEmail(String? email) {
    if (email == null) return 'please provide your email address';

    // Use a regular expression for basic email validation
    final emailRegExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');

    return emailRegExp.hasMatch(email) ? null : 'please provide a valid email address';
  }

  static String? isPhoneNumberValid(String? phoneNumber) {
    if (phoneNumber == null) return 'please provide your phone number';

    // Check if the phone number length is 11
    return phoneNumber.length == 11 ? null : 'please provide a valid phone number';
  }

  static String? isValidFullName(String? fullName) {
    if (fullName == null) return 'please provide your full name';

    // Check if the full name length is above 8 characters
    return fullName.length > 8 ? null : "Full name must be longer than 8 characters";
  }

  static String? isValidField(String? field, {String? fieldName}) {
    if (field == null) return 'Field is required';

    return field.length > 8 ? null : "${fieldName ?? 'value'} name must be longer than 8 characters";
  }

  static String? isValidPassword(String? password) {
    // Check if the password contains at least one letter and one symbol
    final RegExp letterRegExp = RegExp(r'[a-zA-Z]');
    final RegExp symbolRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (password == null) return 'please provide your password';

    if (!letterRegExp.hasMatch(password)) {
      return 'Password must contain at least one letter';
    } else if (!symbolRegExp.hasMatch(password)) {
      return 'Password must contain at least one symbol';
    }

    return null;
  }
}
