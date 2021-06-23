class lang {
  final int id;
  final String name;
  final String flag;
  final String lanCode;

  lang(this.id, this.name, this.flag, this.lanCode);
  static List<lang> langList() {
    return <lang>[
      lang(1, 'English', 'us', 'en'),
      lang(2, 'Arabic', 'eg', 'ar'),
    ];
  }
}
