import 'package:moneymanager/data/repository/accounts_repository.dart';
import 'package:moneymanager/domain/account.dart';
import 'package:moneymanager/local_preferences.dart';

class CurrentAccountService {
  final AccountsRepository accountsRepository;
  final LocalPreferences localPreferences;

  CurrentAccountService(this.accountsRepository, this.localPreferences);

  @Deprecated('Use getCurrentAccountOrNull()')
  int getCurrentAccountId() {
    final id = localPreferences.currentAccountId;
    if (id != null) {
      return id;
    } else {
      throw Exception('No current accountId is found.');
    }
  }

  @Deprecated('Use getCurrentAccountOrNull()')
  Future<Account> getCurrentAccount() async {
    final account = await accountsRepository.getById(getCurrentAccountId());
    if (account != null) {
      return account;
    } else {
      return Future.error('No current account is found.');
    }
  }

  Future<Account?> getCurrentAccountOrNull() async {
    final id = localPreferences.currentAccountId;
    if (id != null) {
      return await accountsRepository.getById(id);
    } else {
      return null;
    }
  }
}
