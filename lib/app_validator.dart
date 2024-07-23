class AppValidator {
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatedPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length != 8) {
      return 'Please enter an 8-digit password';
    }
    return null;
  }

  String? isEmptyCheck(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ('Please fill details');
    }

    return null;
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }

    final RegExp regExp = RegExp(r'^\d+(\.\d{1,2})?$');
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid amount';
    }

    return null;
  }
}
