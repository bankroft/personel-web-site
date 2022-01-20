String buildSharedPreferenceKey(String moduleKey, String key) {
  return "$moduleKey.$key";
}

List mergeList(List a, List b, {dynamic Function()? valid}) {
  if (valid != null) {
    return [];
  } else {
    return [...a, ...b];
  }
}
