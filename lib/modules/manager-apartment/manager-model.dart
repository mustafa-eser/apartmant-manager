class ApartmantManagerInfoModel {
  String? name;
  String? address;
  String? manager;
  String? managerassistant;
  String? managerphone;
  String? managerassistantphone;

  ApartmantManagerInfoModel({
    this.name,
    this.address,
    this.manager,
    this.managerassistant,
    this.managerphone,
    this.managerassistantphone,
  });

  factory ApartmantManagerInfoModel.fromMap(Map<String, dynamic> json) => ApartmantManagerInfoModel(
        name: json["NAME"],
        address: json["ADDRESS"],
        manager: json["MANAGER"],
        managerassistant: json["MANAGERASSISTANT"],
        managerphone: json["MANAGERPHONE"],
        managerassistantphone: json["MANAGERASSISTANTPHONE"],
      );

  Map<String, dynamic> toMap() => {
        "NAME": name,
        "ADDRESS": address,
        "MANAGER": manager,
        "MANAGERASSISTANT": managerassistant,
        "MANAGERPHONE": managerphone,
        "MANAGERASSISTANTPHONE": managerassistantphone,
      };
}
