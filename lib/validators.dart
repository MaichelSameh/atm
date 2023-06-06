class Validators {
  static String? validateEmail(String? text, [bool isRequired = true]) {
    text = (text ?? "").trim();
    if (text.isEmpty && isRequired) {
      return "field-required";
    }
    if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(text)) {
      return "enter-valid-email";
    }
    return null;
  }

  static String? validatePassword(String? text, [bool isRequired = true]) {
    text = (text ?? "").trim();
    if (text.isEmpty && isRequired) {
      return "field-required";
    }
    if (text.length < 8) {
      return "password-too-short";
    }
    // if (!RegExp(".*[A-Z].*[A-Z].*").hasMatch(text)) {
    //   return "no-upper-case-characters";
    // }
    // if (!RegExp(".*[a-z].*[a-z].*").hasMatch(text)) {
    //   return "no-lower-case-characters";
    // }
    if (!RegExp(".*[a-zA-Z].").hasMatch(text)) {
      return "no-letters";
    }
    if (!RegExp(".*[0-9].*").hasMatch(text)) {
      return "no-numbers";
    }
    return null;
  }

  static String? validateConfirmPassword(
      String? password, String? passwordConfirmation) {
    if (password != passwordConfirmation) {
      return "password-do-not-match";
    }
    return null;
  }

  static String? validatePhoneNumber(String? text, [bool isRequired = true]) {
    text = (text ?? "").trim();
    if (text.isEmpty && isRequired) {
      return "field-required";
    }
    if (!RegExp(r'(^(?:[+0]9)?[0-9]{8,12}$)').hasMatch(text)) {
      return "enter-valid-phone";
    }
    return null;
  }

  static String? validateNumber(String? text, [bool isRequired = true]) {
    text = (text ?? "").trim();
    if (text.isEmpty && isRequired) {
      return "field-required";
    }
    if (!RegExp("[0-9]+").hasMatch(text)) {
      return "enter-valid-number";
    }
    return null;
  }

  static String? validateUrl(String? text, [bool isRequired = true]) {
    text = (text ?? "").trim();
    if (text.isEmpty && isRequired) {
      return "field-required";
    }
    if (!Uri.parse(text).isAbsolute) {
      return "enter-valid-url";
    }
    return null;
  }

  static String? validateName(String? text, [bool isRequired = true]) {
    text = (text ?? "").trim();
    if (text.isEmpty && isRequired) {
      return "field-required";
    }
    return null;
  }

  static String? validatePhoneOrEmail(String? text, [bool isRequired = true]) {
    text = (text ?? "").trim();
    if (text.isEmpty && isRequired) {
      return "field-required";
    }
    if (!RegExp(r'(^(?:[+0]9)?[0-9]{8,12}$)').hasMatch(text) &&
        !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(text)) {
      return "enter-valid-email-or-phone";
    }
    return null;
  }
}
