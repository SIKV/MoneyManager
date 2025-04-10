import 'package:moneymanager/data/repository/wallets_repository.dart';
import 'package:moneymanager/domain/wallet.dart';
import 'package:moneymanager/local_preferences.dart';

class CurrentWalletService {
  final WalletsRepository walletsRepository;
  final LocalPreferences localPreferences;

  CurrentWalletService(this.walletsRepository, this.localPreferences);

  void setCurrentWallet(int? id) {
    localPreferences.setCurrentWallet(id);
  }

  @Deprecated('Use getCurrentWalletOrNull()')
  int getCurrentWalletId() {
    final id = localPreferences.currentWalletId;
    if (id != null) {
      return id;
    } else {
      throw Exception('No current walletId is found.');
    }
  }

  @Deprecated('Use getCurrentWalletOrNull()')
  Future<Wallet> getCurrentWallet() async {
    final wallet = await walletsRepository.getById(getCurrentWalletId());
    if (wallet != null) {
      return wallet;
    } else {
      return Future.error('No current wallet is found.');
    }
  }

  Future<Wallet?> getCurrentWalletOrNull() async {
    final id = localPreferences.currentWalletId;
    if (id != null) {
      return walletsRepository.getById(id);
    } else {
      return null;
    }
  }
}
