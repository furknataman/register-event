class ImageHelper {
  static String getImageForBranch(String? branch) {
    // ibAlani değerine göre görsel mapping
    const branchImageMap = {
      'DP': 'assets/lesson_images/ib_banner_dp.jpg',
      'MYP': 'assets/lesson_images/ib_banner_myp.jpg',
      'PYP': 'assets/lesson_images/ib_banner_pyp.jpg',
      'GENERAL': 'assets/lesson_images/ib_banner_general.jpg',
    };

    // Branch mapping'den kontrol et
    if (branch != null && branchImageMap.containsKey(branch)) {
      return branchImageMap[branch]!;
    }

    // Fallback: GENERAL görselini döndür
    return branchImageMap['GENERAL']!;
  }
}
