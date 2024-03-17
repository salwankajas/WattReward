class RewardCalculator {
  static const double rewardRateLow = 0.03;
  static const double rewardRateMedium = 0.05;
  static const double rewardRateHigh = 0.07;
  static const double rewardRateVeryHigh = 0.1;


  static double calculateRewards(double purchaseAmount) {
    if (purchaseAmount < 100) {
      return purchaseAmount * rewardRateLow;
    } else if (purchaseAmount < 800) {
      return purchaseAmount * rewardRateMedium;
    } else if (purchaseAmount < 3000) {
      return purchaseAmount * rewardRateHigh;
    } else {
      return purchaseAmount * rewardRateVeryHigh;
    }
  }
}
