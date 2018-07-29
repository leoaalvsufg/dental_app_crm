class Validations {
  String validateName(String value) {
    if (value.isEmpty) return 'Obrigatório';
    final RegExp nameExp = RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Por favor, insira apenas caracteres alfabéticos.';
    return null;
  }

  String validatePhone(String value) {
    if (value.isEmpty) return 'Obrigatório';
    return null;
  }

  String validateCpf(String value) {
    if (value.isEmpty) return 'Obrigatório';
    else if (!_isCpfValid(value))
      return 'CPF inválido.';
    return null;
  }

  String validateText(String value) {
    if (value.isEmpty) return 'Obrigatório';
    return null;
  }

  String validateEmail(String value) {
    if (value.isEmpty) return 'Obrigatório';
    final RegExp emailExp = RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!emailExp.hasMatch(value)) return 'Endereço de email inválido';
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) return 'Obrigatório';
    return null;
  }

  String validateConfirmPassword(String value, String password) {
    if (value != password) return 'As senhas não coincidem';
    return null;
  }

  bool _isCpfValid(String cpf) {
    final RegExp cpfExp = RegExp('[0-9]{11}');
    if (!cpfExp.hasMatch(cpf)) return false;
    
    var sum = 0;
    for (var i = 1; i <= 9; i++)
      sum += int.parse(cpf.substring(i - 1, i)) * (11 - i);

    var rest = sum % 11;
    if (rest == 10 || rest == 11 || rest < 2)
      rest = 0;
    else rest = 11 - rest;

    if (rest != int.parse(cpf.substring(9, 10)))
      return false;

    sum = 0;
    for (var i = 1; i <= 10; i++)
      sum += int.parse(cpf.substring(i - 1, i)) * (12 - i);
    rest = sum % 11;

    if (rest == 10 || rest == 11 || rest < 2)
      rest = 0;
    else
      rest = 11 - rest;
 
    if (rest != int.parse(cpf.substring(10, 11))) return false;

    return true;
  }
}