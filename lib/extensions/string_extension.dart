extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }
}
