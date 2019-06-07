
class LoginUser{
  String id;
  String token;
  String cookie;

  LoginUser({this.id, this.token, this.cookie});

  factory LoginUser.fromJson(Map<String, dynamic> json){
    return LoginUser(
      id : json['id'],
      token : json['token'],
      cookie : json['cookie']
    );
  }


  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'token': token,
      'cookie': cookie,
    };
}