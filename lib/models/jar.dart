class Jar {
  int _id;
  String _name;
  String _value;
  String _percent;

  Jar(this._name, this._value, this._percent);

  Jar.withId(this._id, this._name, this._value, this._percent);

  int get id => _id;

  String get name => _name;

  String get value => _value;

  String get percent => _percent;

  set name(String newName) {
    if (newName.length <= 255) {
      this._name = newName;
    }
  }
  set value(String newValue) {
    this._value = newValue;
  }

  set percent(String newPercent) {
    this._percent = newPercent;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(id != null) {
      map['id'] = _id;
    }

    map['name'] = _name;

    map['value'] = _value;

    map['percent'] = _percent;

    return map;
  }

  Jar.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._value = map['value'];
    this._percent = map['percent'];
  }

}