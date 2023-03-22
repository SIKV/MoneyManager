import 'package:moneymanager/data/repository/accounts_repository.dart';
import 'package:moneymanager/domain/account.dart';
import 'package:moneymanager/local_preferences.dart';

class CurrentAccountProvider {
  final AccountsRepository accountsRepository;
  final LocalPreferences localPreferences;

  CurrentAccountProvider(this.accountsRepository, this.localPreferences);

  int getCurrentAccountId() {
    final id = localPreferences.currentAccountId;
    if (id != null) {
      return id;
    } else {
      throw Exception('No current accountId is found.');
    }
  }

  Future<Account> getCurrentAccount() async {
    final account = await accountsRepository.getById(getCurrentAccountId());
    if (account != null) {
      return account;
    } else {
      return Future.error('No current account is found.');
    }
  }
}
